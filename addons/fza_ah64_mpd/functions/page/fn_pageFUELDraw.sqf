params["_heli", "_mpdIndex"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

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
private _IAFSInstalled = BOOLTONUM(_heli getVariable ["fza_ah64_IAFSInstalled", false]);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_INSTALLED), _IAFSInstalled];
private _IAFSOn = _heli getVariable ["fza_ah64_IAFSOn", false];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_ON), BOOLTONUM(_IAFSOn)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_IAFS), str (round (_ctrFuelWeight / 10) * 10)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_EMPTY), _ctrFuelWeight];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_TOT),  str (round (_totalFuelCellWeight / 10) * 10)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_ENDR_TOT), _totalEnduranceNumber];

// Crossfeed mode selection box
private _crossfeedMode = _heli getVariable ["fza_fuel_crossfeedMode", "NORM"];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CROSSFEED), (["FWD","NORM","AFT"] find _crossfeedMode) + 1];

// Boost pump
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_BOOST_ON), BOOLTONUM(_heli getVariable ["fza_fuel_boostOn", false])];

// XFER pump mode
private _xferMode = _heli getVariable ["fza_fuel_xferMode", "OFF"];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFER_MODE), ( ["OFF", "FWD", "AFT", "AUTO"] find _xferMode ) + 1];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFER_MENU), BOOLTONUM(_heli getVariable ["fza_fuel_xferMenuOpen", false])];

// Crossfeed open (any non-NORM mode)
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFEED_OPEN), BOOLTONUM(_crossfeedMode != "NORM")];

// Aux tank presence (read pylon magazines)
private _pylonMags = getPylonMagazines _heli;
private _stn1Present = ["auxTank", _pylonMags select 0]  call BIS_fnc_inString;
private _stn2Present = ["auxTank", _pylonMags select 4]  call BIS_fnc_inString;
private _stn3Present = ["auxTank", _pylonMags select 8]  call BIS_fnc_inString;
private _stn4Present = ["auxTank", _pylonMags select 12] call BIS_fnc_inString;

// FWD/AFT cell quantities (lbs) used by HPP threshold checks for low/empty states
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_FWD_LOW), _forwardCellWeight];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_AFT_LOW), _aftCellWeight];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_INTERCELL_XFER_ACTIVE), BOOLTONUM(_heli getVariable ["fza_fuel_intercellTransferActive", false])];
private _intercellPhase = floor (diag_tickTime * 6) % 4;
private _intercellDir = _heli getVariable ["fza_fuel_intercellTransferDir", 0];
if (_intercellDir == 2) then {
    _intercellPhase = _intercellPhase + 4;
};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_INTERCELL_XFER_PHASE), _intercellPhase];

// AUX on indicators
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_L_AUX_ON), BOOLTONUM(_heli getVariable ["fza_fuel_lAuxOn", false])];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_R_AUX_ON), BOOLTONUM(_heli getVariable ["fza_fuel_rAuxOn", false])];

// ── Line "new" flash (white 3 s when line first activates) ──────────────────────────────
private _lAuxOn = _heli getVariable ["fza_fuel_lAuxOn", false];
private _rAuxOn = _heli getVariable ["fza_fuel_rAuxOn", false];
private _anyAuxOn = _lAuxOn || _rAuxOn;

// Crossfeed: per-engine source tracking
// Eng1 feeds from FWD in NORM/FWD mode, from AFT in AFT mode
// Eng2 feeds from AFT in NORM/AFT mode, from FWD in FWD mode
private _eng1Src = ["FWD", "AFT"] select (_crossfeedMode == "AFT");
private _eng2Src = ["AFT", "FWD"] select (_crossfeedMode == "FWD");
if (_eng1Src != (_heli getVariable ["fza_fuel_prevEng1Src", _eng1Src])) then {
    _heli setVariable ["fza_fuel_eng1LineOpenTime", diag_tickTime];
};
_heli setVariable ["fza_fuel_prevEng1Src", _eng1Src];
if (_eng2Src != (_heli getVariable ["fza_fuel_prevEng2Src", _eng2Src])) then {
    _heli setVariable ["fza_fuel_eng2LineOpenTime", diag_tickTime];
};
_heli setVariable ["fza_fuel_prevEng2Src", _eng2Src];
private _eng1LineNew = (diag_tickTime - (_heli getVariable ["fza_fuel_eng1LineOpenTime", -99])) < 3;
private _eng2LineNew = (diag_tickTime - (_heli getVariable ["fza_fuel_eng2LineOpenTime", -99])) < 3;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG1_LINE_NEW), BOOLTONUM(_eng1LineNew)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG2_LINE_NEW), BOOLTONUM(_eng2LineNew)];

// Intercell: flash when transfer becomes active
private _intercellActive = _heli getVariable ["fza_fuel_intercellTransferActive", false];
if (_intercellActive && !(_heli getVariable ["fza_fuel_prevIntercellActive", _intercellActive])) then {
    _heli setVariable ["fza_fuel_intercellLineOpenTime", diag_tickTime];
};
_heli setVariable ["fza_fuel_prevIntercellActive", _intercellActive];
private _intercellLineNew = _intercellActive && ((diag_tickTime - (_heli getVariable ["fza_fuel_intercellLineOpenTime", -99])) < 3);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_INTERCELL_LINE_NEW), BOOLTONUM(_intercellLineNew)];

// Intercell flowing: transfer active with source cell having fuel
private _intercellXferDir = _heli getVariable ["fza_fuel_intercellTransferDir", 0];
private _intercellHasSourceFuel = if (_intercellXferDir == 0) then { _forwardCellWeight > 0 } else { _aftCellWeight > 0 };
private _intercellFlowing = _intercellActive && _intercellHasSourceFuel;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_INTERCELL_FLOWING), BOOLTONUM(_intercellFlowing)];

// IAFS: flash when centre tank transfer turns on
if (_IAFSOn && !(_heli getVariable ["fza_fuel_prevIAFSOn", _IAFSOn])) then {
    _heli setVariable ["fza_fuel_iAFSLineOpenTime", diag_tickTime];
};
_heli setVariable ["fza_fuel_prevIAFSOn", _IAFSOn];
private _iAFSLineNew = _IAFSOn && ((diag_tickTime - (_heli getVariable ["fza_fuel_iAFSLineOpenTime", -99])) < 3);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_LINE_NEW), BOOLTONUM(_iAFSLineNew)];

// Aux: flash when any aux transfer first activates
if (_anyAuxOn && !(_heli getVariable ["fza_fuel_prevAnyAuxOn", _anyAuxOn])) then {
    _heli setVariable ["fza_fuel_auxLineOpenTime", diag_tickTime];
};
_heli setVariable ["fza_fuel_prevAnyAuxOn", _anyAuxOn];
private _auxLineNew = _anyAuxOn && ((diag_tickTime - (_heli getVariable ["fza_fuel_auxLineOpenTime", -99])) < 3);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_AUX_LINE_NEW), BOOLTONUM(_auxLineNew)];

// ── "Flowing" flags (50 % thicker when fuel actively passing through) ───────────────────
// Per-engine: consuming fuel and source cell has fuel
private _eng1SrcHasFuel = if (_eng1Src == "AFT") then {_aftCellWeight > 0} else {_forwardCellWeight > 0};
private _eng2SrcHasFuel = if (_eng2Src == "AFT") then {_aftCellWeight > 0} else {_forwardCellWeight > 0};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG1_FLOWING), BOOLTONUM(_eng1FuelCons > 0 && _eng1SrcHasFuel)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_ENG2_FLOWING), BOOLTONUM(_eng2FuelCons > 0 && _eng2SrcHasFuel)];

// Aux tank fuel masses (fetch early for use in IAFS and Aux logic)
private _stn1FuelMassRaw = _heli getVariable ["fza_sfmplus_stn1FuelMass", 0];
private _stn2FuelMassRaw = _heli getVariable ["fza_sfmplus_stn2FuelMass", 0];
private _stn3FuelMassRaw = _heli getVariable ["fza_sfmplus_stn3FuelMass", 0];
private _stn4FuelMassRaw = _heli getVariable ["fza_sfmplus_stn4FuelMass", 0];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN1_MASS), if (_stn1Present) then {_stn1FuelMassRaw * 2.205} else {-1}];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN2_MASS), if (_stn2Present) then {_stn2FuelMassRaw * 2.205} else {-1}];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN3_MASS), if (_stn3Present) then {_stn3FuelMassRaw * 2.205} else {-1}];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN4_MASS), if (_stn4Present) then {_stn4FuelMassRaw * 2.205} else {-1}];

// IAFS and aux flowing flags — determined by fuelUpdate each tick
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_FWD_FLOWING), BOOLTONUM(_heli getVariable ["fza_fuel_iafsFwdFlowing", false])];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_AFT_FLOWING), BOOLTONUM(_heli getVariable ["fza_fuel_iafsAftFlowing", false])];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_AUX_FLOWING),      BOOLTONUM(_heli getVariable ["fza_fuel_auxFlowing",     false])];

// Aux empty flag: true if any aux tank is actively selected and empty (< 10 lbs ≈ 4.5 kg)
private _anyAuxEmpty = (_lAuxOn && _stn1FuelMassRaw < 4.5) || (_lAuxOn && _stn2FuelMassRaw < 4.5) || (_rAuxOn && _stn3FuelMassRaw < 4.5) || (_rAuxOn && _stn4FuelMassRaw < 4.5);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_AUX_EMPTY), BOOLTONUM(_anyAuxEmpty)];

// CHECK sub-mode
private _checkActive = _heli getVariable ["fza_fuel_checkActive", false];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CHECK_ACTIVE), BOOLTONUM(_checkActive)];
if (_checkActive) then {
    private _elapsedSec = _heli getVariable ["fza_fuel_checkElapsedSec", 0];
    private _burnRate   = _heli getVariable ["fza_fuel_checkBurnRate",   0];
    private _burnoutMin = _heli getVariable ["fza_fuel_checkBurnoutMin", 0];
    private _vfrRes     = _heli getVariable ["fza_fuel_checkVFRRes",     0];
    private _ifrRes     = _heli getVariable ["fza_fuel_checkIFRRes",     0];

    private _elapsedMin  = floor (_elapsedSec / 60);
    private _elapsedSec2 = floor (_elapsedSec % 60);
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_ELAPSED),
        format ["T+%1:%2", _elapsedMin toFixed 0, [_elapsedSec2, 2] call CBA_fnc_formatNumber]];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_BURN),    _burnRate   toFixed 0];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_BURNOUT), (floor _burnoutMin) toFixed 0];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_VFR),     _vfrRes     toFixed 0];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_IFR),     _ifrRes     toFixed 0];
} else {
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_ELAPSED), ""];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_BURN),    ""];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_BURNOUT), ""];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_VFR),     ""];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_CHK_IFR),     ""];
};
