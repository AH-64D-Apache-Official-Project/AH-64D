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

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FWD),      _forwardCellWeight toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_AFT),      _aftCellWeight toFixed 0];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_1),   _eng1FuelCons toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_2),   _eng2FuelCons toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_TOT), _totalFuelConsumption toFixed 0];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_INT),      _mainFuelCellWeight toFixed 0];
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
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_IAFS), _ctrFuelWeight toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_TOT),  _totalFuelCellWeight toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_ENDR_TOT), _totalEnduranceNumber];

// Crossfeed mode selection box
private _crossfeedMode = _heli getVariable ["fza_fuel_crossfeedMode", "NORM"];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CROSSFEED_FWD),  BOOLTONUM(_crossfeedMode == "FWD")];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CROSSFEED_NORM), BOOLTONUM(_crossfeedMode == "NORM")];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_CROSSFEED_AFT),  BOOLTONUM(_crossfeedMode == "AFT")];

// Boost pump
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_BOOST_ON), BOOLTONUM(_heli getVariable ["fza_fuel_boostOn", false])];

// XFER pump mode
private _xferMode = _heli getVariable ["fza_fuel_xferMode", "OFF"];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFER_OFF),  BOOLTONUM(_xferMode == "OFF")];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFER_AFT),  BOOLTONUM(_xferMode == "AFT")];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFER_FWD),  BOOLTONUM(_xferMode == "FWD")];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFER_AUTO), BOOLTONUM(_xferMode == "AUTO")];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFER_MENU), BOOLTONUM(_heli getVariable ["fza_fuel_xferMenuOpen", false])];

// Crossfeed open (any non-NORM mode)
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_XFEED_OPEN), BOOLTONUM(_crossfeedMode != "NORM")];

// Aux tank presence (read pylon magazines)
private _pylonMags = getPylonMagazines _heli;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN1_PRESENT), BOOLTONUM(["auxTank", _pylonMags select 0]  call BIS_fnc_inString)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN2_PRESENT), BOOLTONUM(["auxTank", _pylonMags select 4]  call BIS_fnc_inString)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN3_PRESENT), BOOLTONUM(["auxTank", _pylonMags select 8]  call BIS_fnc_inString)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_STN4_PRESENT), BOOLTONUM(["auxTank", _pylonMags select 12] call BIS_fnc_inString)];

// FWD/AFT cell quantities (lbs) used by HPP threshold checks for low/empty states
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_FWD_LOW), _forwardCellWeight];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_AFT_LOW), _aftCellWeight];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_INTERCELL_XFER_ACTIVE), BOOLTONUM(_heli getVariable ["fza_fuel_intercellTransferActive", false])];

// AUX on indicators
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_L_AUX_ON), BOOLTONUM(_heli getVariable ["fza_fuel_lAuxOn", false])];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FUEL_R_AUX_ON), BOOLTONUM(_heli getVariable ["fza_fuel_rAuxOn", false])];

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
