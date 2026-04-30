/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_fuelUpdate

Description:
    Updates fuel cell masses each tick. Handles independent cell draw based on
    crossfeed valve position, XFER pump logic, IAFS gravity feed, and external
    tank transfer with outer/inner pressurisation dependency.

    Crossfeed NORM:  Eng1 draws from FWD, Eng2 draws from AFT.
    Crossfeed FWD:   Both engines draw from FWD.
    Crossfeed AFT:   Both engines draw from AFT.

    APU fuel source: Always AFT cell (independent of crossfeed selection).

    External transfer (pressurised air):
      stn2 (inner L) and stn3 (inner R) transfer independently.
      stn1 (outer L) requires stn2 to be present.
      stn4 (outer R) requires stn3 to be present.

Parameters:
    _heli - The helicopter to update [Unit].

Returns:
    None

Author:
    BradMick / FZA Development Team
---------------------------------------------------------------------------- */
params ["_heli"];

// Threshold constants (kg)
#define XFER_RATE_KGS       0.378   // ~50 lb/min pump transfer rate
#define FWD_LOW_THRESH_KG   109.0   // ~240 lb
#define AFT_LOW_THRESH_KG   118.0   // ~260 lb
#define AUTO_FILL_THRESH_KG 369.0   // ~814 lb (Table 2-6 AUTO trigger)
#define AUTO_FWD_MIN_SRC_KG 127.0   // ~280 lb min FWD source for AUTO TO AFT
#define AUTO_SPLIT_STOP_KG  9.1     // ~20 lb
#define AUTO_SPLIT_50_KG     22.7    // ~50 lb
#define AUTO_SPLIT_100_KG    45.4    // ~100 lb
#define AUTO_500_KG          226.8   // ~500 lb

private _deltaTime     = _heli getVariable "fza_sfmplus_deltaTime";
if (_deltaTime <= 0) exitWith {};

private _IAFSInstalled = _heli getVariable "fza_ah64_IAFSInstalled";
if (isNil "_IAFSInstalled") exitWith {};

private _maxFwdFuelMass = _heli getVariable "fza_sfmplus_maxFwdFuelMass";
private _maxCtrFuelMass = _heli getVariable "fza_sfmplus_maxCtrFuelMass";
private _maxAftFuelMass = _heli getVariable "fza_sfmplus_maxAftFuelMass";
private _maxTnkFuelMass = _heli getVariable "fza_sfmplus_maxExtFuelMass";
private _maxTotFuelMass = _heli getVariable "fza_sfmplus_maxTotFuelMass";
if (_maxTotFuelMass <= 0) exitWith {};

// If Arma fuel was changed externally (e.g. editor/trigger script), resync
// internal tank masses so subsequent simulation ticks stay consistent.
private _armaFuelFrac = fuel _heli;
private _storedTotFuelMass = _heli getVariable ["fza_sfmplus_totFuelMass", 0];
private _storedFuelFrac = if (_maxTotFuelMass > 0) then { _storedTotFuelMass / _maxTotFuelMass } else { 0 };
if (abs (_armaFuelFrac - _storedFuelFrac) > 0.01) then {
    [_heli] call fza_sfmplus_fnc_fuelSet;
};

/////////////////////////////////////////////////////////////////////////////////////////////
// Current cell masses from previous tick                                             //////
/////////////////////////////////////////////////////////////////////////////////////////////
private _fwdFuelMass  = _heli getVariable "fza_sfmplus_fwdFuelMass";
private _ctrFuelMass  = _heli getVariable "fza_sfmplus_ctrFuelMass";
private _aftFuelMass  = _heli getVariable "fza_sfmplus_aftFuelMass";
private _stn1FuelMass = _heli getVariable "fza_sfmplus_stn1FuelMass";
private _stn2FuelMass = _heli getVariable "fza_sfmplus_stn2FuelMass";
private _stn3FuelMass = _heli getVariable "fza_sfmplus_stn3FuelMass";
private _stn4FuelMass = _heli getVariable "fza_sfmplus_stn4FuelMass";

/////////////////////////////////////////////////////////////////////////////////////////////
// Fuel flow                                                                          //////
/////////////////////////////////////////////////////////////////////////////////////////////
private _apuFF_kgs  = _heli getVariable "fza_systems_apuFF_kgs";
private _engFF      = _heli getVariable "fza_sfmplus_engFF";
private _eng1FF_kgs = _engFF select 0;
private _eng2FF_kgs = _engFF select 1;

private _engState = _heli getVariable "fza_sfmplus_engState";
private _eng1On   = (_engState select 0) == "ON";
private _eng2On   = (_engState select 1) == "ON";

/////////////////////////////////////////////////////////////////////////////////////////////
// Crossfeed draw — source-based consumption with starvation                          //////
/////////////////////////////////////////////////////////////////////////////////////////////
private _crossfeedMode = _heli getVariable ["fza_fuel_crossfeedMode", "NORM"];

private _eng1Req = if (_eng1On) then { _eng1FF_kgs * _deltaTime } else { 0 };
private _eng2Req = if (_eng2On) then { _eng2FF_kgs * _deltaTime } else { 0 };
private _apuReq  = _apuFF_kgs * _deltaTime;

private _eng1Source = switch (_crossfeedMode) do {
    case "FWD": { "FWD" };
    case "AFT": { "AFT" };
    default     { "FWD" }; // NORM
};
private _eng2Source = switch (_crossfeedMode) do {
    case "FWD": { "FWD" };
    case "AFT": { "AFT" };
    default     { "AFT" }; // NORM
};

private _fwdReq = 0;
private _aftReq = _apuReq; // APU always draws from AFT
if (_eng1Source == "FWD") then { _fwdReq = _fwdReq + _eng1Req; } else { _aftReq = _aftReq + _eng1Req; };
if (_eng2Source == "FWD") then { _fwdReq = _fwdReq + _eng2Req; } else { _aftReq = _aftReq + _eng2Req; };

private _fwdFuelBefore = _fwdFuelMass;
private _aftFuelBefore = _aftFuelMass;

private _fwdDraw = _fwdReq min _fwdFuelMass;
private _aftDraw = _aftReq min _aftFuelMass;

_fwdFuelMass = (_fwdFuelMass - _fwdDraw) max 0;
_aftFuelMass = (_aftFuelMass - _aftDraw) max 0;

private _eps = 0.0001;
private _fwdFuelAvailLastFrame = _fwdFuelBefore > _eps;
private _aftFuelAvailLastFrame = _aftFuelBefore > _eps;

/////////////////////////////////////////////////////////////////////////////////////////////
// XFER pump — Table 2-6 logic                                                       //////
/////////////////////////////////////////////////////////////////////////////////////////////
private _xferStep   = XFER_RATE_KGS * _deltaTime;
private _fwdLow     = _fwdFuelMass < FWD_LOW_THRESH_KG;
private _aftLow     = _aftFuelMass < AFT_LOW_THRESH_KG;
private _apuOn      = _heli getVariable ["fza_systems_apuOn", false];
private _engBleedOn = _eng1On || _eng2On;
private _airAvail   = _apuOn || _engBleedOn;
private _xferMode   = _heli getVariable ["fza_fuel_xferMode", "OFF"];
private _intercellTransferActive = false;
private _intercellTransferDir = 0;

private _doFwdToAft = false;
private _doAftToFwd = false;

switch (_xferMode) do {
    case "AFT": {
        if (_fwdFuelMass > _xferStep && _aftFuelMass < _maxAftFuelMass) then {
            _doFwdToAft = true;
        };
    };
    case "FWD": {
        if (_aftFuelMass > _xferStep && _fwdFuelMass < _maxFwdFuelMass) then {
            _doAftToFwd = true;
        };
    };
    case "AUTO": {
        private _aftMinusFwd = _aftFuelMass - _fwdFuelMass;
        private _fwdMinusAft = _fwdFuelMass - _aftFuelMass;

        private _aftLeadEnough = if (_aftFuelMass > AUTO_500_KG) then {
            _aftMinusFwd > AUTO_SPLIT_100_KG
        } else {
            _aftMinusFwd > AUTO_SPLIT_50_KG
        };
        private _fwdLeadEnough = if (_fwdFuelMass > AUTO_500_KG) then {
            _fwdMinusAft > AUTO_SPLIT_100_KG
        } else {
            _fwdMinusAft > AUTO_SPLIT_50_KG
        };

        // BEGIN AUTO LEVELLING TO FWD (AFT -> FWD)
        if ((_eng1On || _eng2On)
                && _airAvail
                && (_fwdFuelMass < AUTO_FILL_THRESH_KG)
                && !_aftLow
                && (_aftFuelMass > FWD_LOW_THRESH_KG)
                && _aftLeadEnough
                // HALT guards
                && (_aftMinusFwd >= AUTO_SPLIT_STOP_KG) && (_fwdFuelMass < (_maxFwdFuelMass - 0.1))) then {
            _doAftToFwd = true;
        };

        // BEGIN AUTO LEVELLING TO AFT (FWD -> AFT)
        if (_eng1On && _eng2On
                && _airAvail
                && (_aftFuelMass < AUTO_FILL_THRESH_KG)
                && !_fwdLow
                && (_fwdFuelMass > AUTO_FWD_MIN_SRC_KG)
                && _fwdLeadEnough
                // HALT guards
                && (_fwdMinusAft >= AUTO_SPLIT_STOP_KG)) then {
            _doFwdToAft = true;
        };

        // HALT AUTO LEVELLING TO FWD/AFT when APU and engine bleed air are off.
        if (!_airAvail) then {
            _doAftToFwd = false;
            _doFwdToAft = false;
        };
    };
};

if (_doFwdToAft) then {
    private _amt = _fwdFuelMass min _xferStep min (_maxAftFuelMass - _aftFuelMass);
    _fwdFuelMass = _fwdFuelMass - _amt;
    _aftFuelMass = _aftFuelMass + _amt;
    if (_amt > 0) then {
        _intercellTransferActive = true;
        _intercellTransferDir = 1; // FWD -> AFT (down)
    };
};
if (_doAftToFwd) then {
    private _amt = _aftFuelMass min _xferStep min (_maxFwdFuelMass - _fwdFuelMass);
    _aftFuelMass = _aftFuelMass - _amt;
    _fwdFuelMass = _fwdFuelMass + _amt;
    if (_amt > 0) then {
        _intercellTransferActive = true;
        _intercellTransferDir = 2; // AFT -> FWD (up)
    };
};

/////////////////////////////////////////////////////////////////////////////////////////////
// IAFS (centre tank) gravity feeds into AFT and FWD when on and AFT/FWD have room   //////
// Inhibited only when any aux tank is actively transferring fuel (not just switched on).
/////////////////////////////////////////////////////////////////////////////////////////////
private _lAuxOn = _heli getVariable ["fza_fuel_lAuxOn", false];
private _rAuxOn = _heli getVariable ["fza_fuel_rAuxOn", false];

// Aux actively transferring only if tank has fuel > 10 lbs (4.5 kg)
private _anyAuxTransferring = (_lAuxOn && (_stn1FuelMass > 4.5 || _stn2FuelMass > 4.5)) || (_rAuxOn && (_stn3FuelMass > 4.5 || _stn4FuelMass > 4.5));

private _iafsAftFlowing = false;
private _iafsFwdFlowing = false;
if (_IAFSInstalled && (_heli getVariable ["fza_ah64_IAFSOn", false]) && !_anyAuxTransferring) then {
    if (_ctrFuelMass > 0 && _aftFuelMass < _maxAftFuelMass) then {
        private _iafsFlow = _xferStep min _ctrFuelMass min (_maxAftFuelMass - _aftFuelMass);
        _ctrFuelMass = _ctrFuelMass - _iafsFlow;
        _aftFuelMass = _aftFuelMass + _iafsFlow;
        if (_iafsFlow > 0) then { _iafsAftFlowing = true; };
    };
    if (_ctrFuelMass > 0 && _fwdFuelMass < _maxFwdFuelMass) then {
        private _iafsFlow = _xferStep min _ctrFuelMass min (_maxFwdFuelMass - _fwdFuelMass);
        _ctrFuelMass = _ctrFuelMass - _iafsFlow;
        _fwdFuelMass = _fwdFuelMass + _iafsFlow;
        if (_iafsFlow > 0) then { _iafsFwdFlowing = true; };
    };
};

/////////////////////////////////////////////////////////////////////////////////////////////
// External tank transfer (pressurised air → internal cells)                        //////
// stn1/stn2 (left, L AUX) feed FWD cell.                                           //////
// stn3/stn4 (right, R AUX) feed AFT cell.                                          //////
// stn1 outer-L requires stn2 present; stn4 outer-R requires stn3 present.           //////
/////////////////////////////////////////////////////////////////////////////////////////////
private _pylonMagazines = getPylonMagazines _heli;
private _stn1HasTank = ["auxTank", _pylonMagazines select 0]  call BIS_fnc_inString;
private _stn2HasTank = ["auxTank", _pylonMagazines select 4]  call BIS_fnc_inString;
private _stn3HasTank = ["auxTank", _pylonMagazines select 8]  call BIS_fnc_inString;
private _stn4HasTank = ["auxTank", _pylonMagazines select 12] call BIS_fnc_inString;

private _fwdRoom = _maxFwdFuelMass - _fwdFuelMass;
private _aftRoom = _maxAftFuelMass - _aftFuelMass;

// Left side: inner-L (stn2) then outer-L (stn1, requires stn2 for pressurised air path) → FWD
private _lAuxFlowTotal = 0;
if (_stn2HasTank && _lAuxOn && _stn2FuelMass > 0 && _fwdRoom > 0) then {
    private _flow = _xferStep min _stn2FuelMass min _fwdRoom;
    _stn2FuelMass  = _stn2FuelMass - _flow;
    _fwdFuelMass   = _fwdFuelMass  + _flow;
    _fwdRoom       = _fwdRoom      - _flow;
    _lAuxFlowTotal = _lAuxFlowTotal + _flow;
};
if (_stn1HasTank && _lAuxOn && _stn2HasTank && _stn1FuelMass > 0 && _fwdRoom > 0) then {
    private _flow = _xferStep min _stn1FuelMass min _fwdRoom;
    _stn1FuelMass  = _stn1FuelMass - _flow;
    _fwdFuelMass   = _fwdFuelMass  + _flow;
    _fwdRoom       = _fwdRoom      - _flow;
    _lAuxFlowTotal = _lAuxFlowTotal + _flow;
};
// Right side: inner-R (stn3) then outer-R (stn4, requires stn3 for pressurised air path) → AFT
private _rAuxFlowTotal = 0;
if (_stn3HasTank && _rAuxOn && _stn3FuelMass > 0 && _aftRoom > 0) then {
    private _flow = _xferStep min _stn3FuelMass min _aftRoom;
    _stn3FuelMass  = _stn3FuelMass - _flow;
    _aftFuelMass   = _aftFuelMass  + _flow;
    _aftRoom       = _aftRoom      - _flow;
    _rAuxFlowTotal = _rAuxFlowTotal + _flow;
};
if (_stn4HasTank && _rAuxOn && _stn3HasTank && _stn4FuelMass > 0 && _aftRoom > 0) then {
    private _flow = _xferStep min _stn4FuelMass min _aftRoom;
    _stn4FuelMass  = _stn4FuelMass - _flow;
    _aftFuelMass   = _aftFuelMass  + _flow;
    _rAuxFlowTotal = _rAuxFlowTotal + _flow;
};

private _lAuxFlowing = _lAuxFlowTotal > 0;
private _rAuxFlowing = _rAuxFlowTotal > 0;

/////////////////////////////////////////////////////////////////////////////////////////////
// Clamp all masses                                                                   //////
/////////////////////////////////////////////////////////////////////////////////////////////
_fwdFuelMass  = 0 max _fwdFuelMass  min _maxFwdFuelMass;
_aftFuelMass  = 0 max _aftFuelMass  min _maxAftFuelMass;
_ctrFuelMass  = 0 max _ctrFuelMass  min _maxCtrFuelMass;
_stn1FuelMass = 0 max _stn1FuelMass min _maxTnkFuelMass;
_stn2FuelMass = 0 max _stn2FuelMass min _maxTnkFuelMass;
_stn3FuelMass = 0 max _stn3FuelMass min _maxTnkFuelMass;
_stn4FuelMass = 0 max _stn4FuelMass min _maxTnkFuelMass;

private _fwdSrcAvail = _fwdFuelAvailLastFrame;
private _aftSrcAvail = _aftFuelAvailLastFrame;

private _eng1FuelAvail = (_eng1Req <= _eps) || ([_aftSrcAvail, _fwdSrcAvail] select (_eng1Source == "FWD"));
private _eng2FuelAvail = (_eng2Req <= _eps) || ([_aftSrcAvail, _fwdSrcAvail] select (_eng2Source == "FWD"));
private _apuFuelAvail  = (_apuReq  <= _eps) || _aftSrcAvail;

// 2-second starvation grace period
private _eng1StarvedSince = _heli getVariable ["fza_fuel_eng1StarvedSince", -1];
if (!_eng1FuelAvail) then {
    if (_eng1StarvedSince < 0) then { _eng1StarvedSince = CBA_missionTime; _heli setVariable ["fza_fuel_eng1StarvedSince", _eng1StarvedSince]; };
    _eng1FuelAvail = (CBA_missionTime - _eng1StarvedSince) < 2;
} else { _heli setVariable ["fza_fuel_eng1StarvedSince", -1]; };

private _eng2StarvedSince = _heli getVariable ["fza_fuel_eng2StarvedSince", -1];
if (!_eng2FuelAvail) then {
    if (_eng2StarvedSince < 0) then { _eng2StarvedSince = CBA_missionTime; _heli setVariable ["fza_fuel_eng2StarvedSince", _eng2StarvedSince]; };
    _eng2FuelAvail = (CBA_missionTime - _eng2StarvedSince) < 2;
} else { _heli setVariable ["fza_fuel_eng2StarvedSince", -1]; };

_heli setVariable ["fza_fuel_eng1FuelAvail", _eng1FuelAvail];
_heli setVariable ["fza_fuel_eng2FuelAvail", _eng2FuelAvail];
_heli setVariable ["fza_fuel_apuFuelAvail",  _apuFuelAvail];

/////////////////////////////////////////////////////////////////////////////////////////////
// Fuel status flags                                                                 //////
/////////////////////////////////////////////////////////////////////////////////////////////
_heli setVariable ["fza_fuel_intercellTransferActive", _intercellTransferActive];
_heli setVariable ["fza_fuel_intercellTransferDir",    _intercellTransferDir];
_heli setVariable ["fza_fuel_iafsFlowing",            _iafsAftFlowing || _iafsFwdFlowing];
_heli setVariable ["fza_fuel_iafsAftFlowing",         _iafsAftFlowing];
_heli setVariable ["fza_fuel_iafsFwdFlowing",         _iafsFwdFlowing];
_heli setVariable ["fza_fuel_lAuxFlowing",            _lAuxFlowing];
_heli setVariable ["fza_fuel_rAuxFlowing",            _rAuxFlowing];

/////////////////////////////////////////////////////////////////////////////////////////////
// Update Arma fuel fraction and write variables                                     //////
/////////////////////////////////////////////////////////////////////////////////////////////
private _totFuelMass = _fwdFuelMass + _ctrFuelMass + _aftFuelMass
                     + _stn1FuelMass + _stn2FuelMass + _stn3FuelMass + _stn4FuelMass;
if (local _heli) then {
    _heli setFuel (_totFuelMass / _maxTotFuelMass);
};

_heli setVariable ["fza_sfmplus_fwdFuelMass",  _fwdFuelMass];
_heli setVariable ["fza_sfmplus_ctrFuelMass",  _ctrFuelMass];
_heli setVariable ["fza_sfmplus_aftFuelMass",  _aftFuelMass];
_heli setVariable ["fza_sfmplus_stn1FuelMass", _stn1FuelMass];
_heli setVariable ["fza_sfmplus_stn2FuelMass", _stn2FuelMass];
_heli setVariable ["fza_sfmplus_stn3FuelMass", _stn3FuelMass];
_heli setVariable ["fza_sfmplus_stn4FuelMass", _stn4FuelMass];
_heli setVariable ["fza_sfmplus_totFuelMass",  _totFuelMass];
