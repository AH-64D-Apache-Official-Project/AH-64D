params["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\bmkhs_helisim\functions\core\core.hpp"

[_heli] call fza_mpd_fnc_fuelGetData params [ "_forwardCellWeight"
                                            , "_ctrFuelWeight"
                                            , "_aftCellWeight"
                                            , "_mainFuelCellWeight"
                                            , "_totalFuelCellWeight"
                                            , "_eng1FuelCons"
                                            , "_eng2FuelCons"
                                            , "_totalFuelConsumption"
                                            , "_mainEnduranceNumber"
                                            , "_totalEnduranceNumber"
                                            , "_sfrText"
                                            ];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FWD),      str (round (_forwardCellWeight / 10) * 10)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_AFT),      str (round (_aftCellWeight / 10) * 10)];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_1),   str (round (_eng1FuelCons / 10) * 10)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_2),   str (round (_eng2FuelCons / 10) * 10)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_TOT), str (round (_totalFuelConsumption / 10) * 10)];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_INT),      str (round (_mainFuelCellWeight / 10) * 10)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_ENDR_INT), _mainEnduranceNumber];

// Warn when internal endurance < 20 minutes
private _endrIntMin = if (_totalFuelConsumption > 0) then { (_mainFuelCellWeight / _totalFuelConsumption * 60) min 599 } else { 599 };
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENDR_INT_LOW), BOOLTONUM(_endrIntMin < 20)];

// SFR (blank when not airborne or no flow)
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_SFR), _sfrText];

// IAFS / centre tank
private _IAFSInstalled = BOOLTONUM(_heli getVariable ["bmkhs_ctrTankInstalled", false]);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_INSTALLED), _IAFSInstalled];
private _IAFSOn = _heli getVariable ["bmkhs_ctrTankXferOn", false];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_ON), BOOLTONUM(_IAFSOn)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_IAFS), str (round (_ctrFuelWeight / 10) * 10)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_EMPTY), _ctrFuelWeight];

// Crossfeed mode selection box
private _crossfeedMode = _heli getVariable ["bmkhs_crossfeedMode", "NORM"];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CROSSFEED), (["FWD","NORM","AFT"] find _crossfeedMode) + 1];

// Boost pump
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_BOOST_ON), BOOLTONUM(_heli getVariable ["bmkhs_boostOn", false])];

// XFER pump mode
private _xferMode = _heli getVariable ["bmkhs_xferMode", "OFF"];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFER_MODE), ( ["OFF", "FWD", "AFT", "AUTO"] find _xferMode ) + 1];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFER_MENU), BOOLTONUM((_state get "xferMenuOpen") > 0)];

// Crossfeed open (any non-NORM mode)
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFEED_OPEN), BOOLTONUM(_crossfeedMode != "NORM")];

// Aux tank presence (read pylon magazines)
private _pylonMags = getPylonMagazines _heli;
private _stn1Present = ["auxTank", _pylonMags select 0]  call BIS_fnc_inString;
private _stn2Present = ["auxTank", _pylonMags select 4]  call BIS_fnc_inString;
private _stn3Present = ["auxTank", _pylonMags select 8]  call BIS_fnc_inString;
private _stn4Present = ["auxTank", _pylonMags select 12] call BIS_fnc_inString;
private _showTotalFuel = (_IAFSInstalled > 0) || _stn1Present || _stn2Present || _stn3Present || _stn4Present;
private _totalFuelText = str (round (_totalFuelCellWeight / 10) * 10);
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_TOT), ["", _totalFuelText] select _showTotalFuel];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_ENDR_TOT), ["", _totalEnduranceNumber] select _showTotalFuel];

// FWD/AFT cell quantities (lbs) used by HPP threshold checks for low/empty states
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_FWD_LOW), _forwardCellWeight];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_AFT_LOW), _aftCellWeight];
// XFER pump flags, declared per destination in helisim_fuel.hpp
private _xferToFwd       = _heli getVariable "bmkhs_xferToFwdFlowing";
private _xferToAft       = _heli getVariable "bmkhs_xferToAftFlowing";
private _intercellActive = _xferToFwd || _xferToAft;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_INTERCELL_XFER_ACTIVE), BOOLTONUM(_intercellActive)];
private _intercellPhase = floor (CBA_missionTime * 6) % 4;
if (_xferToFwd) then {
    _intercellPhase = _intercellPhase + 4;
};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_INTERCELL_XFER_PHASE), _intercellPhase];

private _lAuxOn = _heli getVariable ["bmkhs_lAuxOn", false];
private _rAuxOn = _heli getVariable ["bmkhs_rAuxOn", false];

if (_lAuxOn && (_heli getVariable ["bmkhs_stn1TankMass", 0] <= 0) && (_heli getVariable ["bmkhs_stn2TankMass", 0] <= 0)) then {
    [_heli, "bmkhs_lAuxOn", false] call fza_fnc_updateNetworkGlobal;
    _lAuxOn = false;
};
if (_rAuxOn && (_heli getVariable ["bmkhs_stn3TankMass", 0] <= 0) && (_heli getVariable ["bmkhs_stn4TankMass", 0] <= 0)) then {
    [_heli, "bmkhs_rAuxOn", false] call fza_fnc_updateNetworkGlobal;
    _rAuxOn = false;
};

private _anyAuxOn = _lAuxOn || _rAuxOn;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_L_AUX_ON), BOOLTONUM(_lAuxOn)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_R_AUX_ON), BOOLTONUM(_rAuxOn)];

// Crossfeed: per-engine source tracking
// Eng1 feeds from FWD in NORM/FWD mode, from AFT in AFT mode
// Eng2 feeds from AFT in NORM/AFT mode, from FWD in FWD mode
private _eng1Src = ["FWD", "AFT"] select (_crossfeedMode == "AFT");
private _eng2Src = ["AFT", "FWD"] select (_crossfeedMode == "FWD");
if (_eng1Src != (_heli getVariable ["bmkhs_prevEng1Src", _eng1Src])) then {
    _heli setVariable ["bmkhs_eng1LineOpenTime", CBA_missionTime];
};
_heli setVariable ["bmkhs_prevEng1Src", _eng1Src];
if (_eng2Src != (_heli getVariable ["bmkhs_prevEng2Src", _eng2Src])) then {
    _heli setVariable ["bmkhs_eng2LineOpenTime", CBA_missionTime];
};
_heli setVariable ["bmkhs_prevEng2Src", _eng2Src];
private _eng1LineNew = (CBA_missionTime - (_heli getVariable ["bmkhs_eng1LineOpenTime", -99])) < 3;
private _eng2LineNew = (CBA_missionTime - (_heli getVariable ["bmkhs_eng2LineOpenTime", -99])) < 3;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG1_LINE_NEW), BOOLTONUM(_eng1LineNew)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG2_LINE_NEW), BOOLTONUM(_eng2LineNew)];

// Intercell: flash when transfer becomes active
if (_intercellActive && !(_heli getVariable ["bmkhs_prevIntercellActive", _intercellActive])) then {
    _heli setVariable ["bmkhs_intercellLineOpenTime", CBA_missionTime];
};
_heli setVariable ["bmkhs_prevIntercellActive", _intercellActive];
private _intercellLineNew = _intercellActive && ((CBA_missionTime - (_heli getVariable ["bmkhs_intercellLineOpenTime", -99])) < 3);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_INTERCELL_LINE_NEW), BOOLTONUM(_intercellLineNew)];

// Intercell flowing: a flag is only set while fuel actually moved, so the source had fuel
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_INTERCELL_FLOWING), BOOLTONUM(_intercellActive)];

// IAFS: flash when centre tank transfer turns on
if (_IAFSOn && !(_heli getVariable ["bmkhs_prevIafsOn", _IAFSOn])) then {
    _heli setVariable ["bmkhs_iafsLineOpenTime", CBA_missionTime];
};
_heli setVariable ["bmkhs_prevIafsOn", _IAFSOn];
private _iAFSLineNew = _IAFSOn && ((CBA_missionTime - (_heli getVariable ["bmkhs_iafsLineOpenTime", -99])) < 3);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_LINE_NEW), BOOLTONUM(_iAFSLineNew)];

// Aux: flash when any aux transfer first activates
if (_anyAuxOn && !(_heli getVariable ["bmkhs_prevAnyAuxOn", _anyAuxOn])) then {
    _heli setVariable ["bmkhs_auxLineOpenTime", CBA_missionTime];
};
_heli setVariable ["bmkhs_prevAnyAuxOn", _anyAuxOn];
private _auxLineNew = _anyAuxOn && ((CBA_missionTime - (_heli getVariable ["bmkhs_auxLineOpenTime", -99])) < 3);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_AUX_LINE_NEW), BOOLTONUM(_auxLineNew)];

// Flowing flags
// Per-engine: consuming fuel and source cell has fuel
private _eng1SrcHasFuel = if (_eng1Src == "AFT") then {_aftCellWeight > 0} else {_forwardCellWeight > 0};
private _eng2SrcHasFuel = if (_eng2Src == "AFT") then {_aftCellWeight > 0} else {_forwardCellWeight > 0};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG1_FLOWING), BOOLTONUM(_eng1FuelCons > 0 && _eng1SrcHasFuel)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG2_FLOWING), BOOLTONUM(_eng2FuelCons > 0 && _eng2SrcHasFuel)];

// Aux tank fuel masses (fetch early for use in IAFS and Aux logic)
private _stn1FuelMassRaw = _heli getVariable ["bmkhs_stn1TankMass", 0];
private _stn2FuelMassRaw = _heli getVariable ["bmkhs_stn2TankMass", 0];
private _stn3FuelMassRaw = _heli getVariable ["bmkhs_stn3TankMass", 0];
private _stn4FuelMassRaw = _heli getVariable ["bmkhs_stn4TankMass", 0];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN1_MASS), if (_stn1Present) then {_stn1FuelMassRaw * 2.205} else {-1}];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN2_MASS), if (_stn2Present) then {_stn2FuelMassRaw * 2.205} else {-1}];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN3_MASS), if (_stn3Present) then {_stn3FuelMassRaw * 2.205} else {-1}];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN4_MASS), if (_stn4Present) then {_stn4FuelMassRaw * 2.205} else {-1}];

// IAFS and aux flowing flags — determined by fuelUpdate each tick
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_FWD_FLOWING), BOOLTONUM(_heli getVariable ["bmkhs_iafsFwdFlowing", false])];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_AFT_FLOWING), BOOLTONUM(_heli getVariable ["bmkhs_iafsAftFlowing", false])];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_L_AUX_FLOWING),    BOOLTONUM(_heli getVariable ["bmkhs_lAuxFlowing",    false])];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_R_AUX_FLOWING),    BOOLTONUM(_heli getVariable ["bmkhs_rAuxFlowing",    false])];

// Fire panel armed: hides engine fuel lines to show fuel shutoff
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG1_FIRE_ARMED), BOOLTONUM((_heli getVariable ["fza_ah64_fireArmed1", [false, 0, 0]]) #0)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG2_FIRE_ARMED), BOOLTONUM((_heli getVariable ["fza_ah64_fireArmed2", [false, 0, 0]]) #0)];

// CHECK sub-mode
private _checkActive  = (_state get "checkActive") > 0;
private _checkRunning = _heli getVariable ["bmkhs_checkRunning", false];
private _checkDone    = _heli getVariable ["bmkhs_checkDone",    false];
private _checkMinutes = _heli getVariable ["bmkhs_checkMinutes", 15];

// Sync per-seat CHECK-open state — set when CHECK sub-format is open, cleared by fn_update when off fuel page
private _checkSeatVar = ["bmkhs_checkActiveCpg", "bmkhs_checkActivePlt"] select (player == driver _heli);
[_heli, _checkSeatVar, _checkActive] call fza_fnc_updateNetworkGlobal;

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CHECK_ACTIVE),  BOOLTONUM(_checkActive)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CHECK_RUNNING), BOOLTONUM(_checkRunning)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CHECK_DONE),    BOOLTONUM(_checkDone)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CHECK_MINUTES), _checkMinutes];

if (_checkRunning || _checkDone) then {
    private _startTime   = _heli getVariable ["bmkhs_checkStartTime", 0];
    private _startFuel   = _heli getVariable ["bmkhs_checkStartFuel", 0];
    private _currentFuel = _heli getVariable ["bmkhs_totFuelMass", 0];
    private _elapsedSec  = if (_checkRunning) then {
        (CBA_missionTime - _startTime) min (_checkMinutes * 60)
    } else {
        _heli getVariable ["bmkhs_checkElapsedSec", 0]
    };
    private _burnRate = if (_checkRunning && _elapsedSec > 0) then {
        ((_startFuel - _currentFuel) * 2.20462) / (_elapsedSec / 3600)
    } else {
        _heli getVariable ["bmkhs_checkBurnRate", 0]
    };
    private _elapsedMin  = floor (_elapsedSec / 60);
    private _elapsedSecR = floor (_elapsedSec % 60);
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_ELAPSED),
        format ["%1:%2", [_elapsedMin, 2] call CBA_fnc_formatNumber, [_elapsedSecR, 2] call CBA_fnc_formatNumber]];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_BURN),  str (round (_burnRate / 10) * 10)];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_START), _heli getVariable ["bmkhs_checkStartZulu", ""]];
} else {
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_ELAPSED), ""];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_BURN),    ""];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_START),   ""];
};

if (_checkDone) then {
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_BURNOUT), _heli getVariable ["bmkhs_checkBurnoutZulu", ""]];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_VFR),     _heli getVariable ["bmkhs_checkVfrZulu",     ""]];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_IFR),     _heli getVariable ["bmkhs_checkIfrZulu",     ""]];
} else {
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_BURNOUT), ""];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_VFR),     ""];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_IFR),     ""];
};
