#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
params ["_heli", "_mpdIndex"];


// #region ENGINE 1
private _e1np   = (_heli getVariable "fza_sfmplus_engPctNP" select 0) * 100;
private _e1ng   = (_heli getVariable "fza_sfmplus_engPctNG" select 0) * 1000;
private _e1tgt  = _heli getVariable "fza_sfmplus_engTGT" select 0;
private _e1trq  = (_heli getVariable "fza_sfmplus_engPctTQ" select 0) * 100;
private _e1opsi = (_heli getVariable "fza_sfmplus_engOilPSI" select 0) * 100;
if (_e1np <= (0.37 * 100)) then {
    _e1trq = 0;
};

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TORQUE_1), round _e1trq];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_TORQUE_1), _e1trq toFixed 0];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_NP_1), round _e1np];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NP_1), _e1np toFixed 0];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TGT_1), round _e1tgt];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_TGT_1), _e1tgt toFixed 0];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NG_1), (_e1ng/10) toFixed 1];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_OIL_PSI_1), _e1opsi toFixed 0];

// #region ENGINE 2
private _e2np   = (_heli getVariable "fza_sfmplus_engPctNP" select 1) * 100;
private _e2ng   = (_heli getVariable "fza_sfmplus_engPctNG" select 1) * 1000;
private _e2tgt  = _heli getVariable "fza_sfmplus_engTGT" select 1;
private _e2trq  = (_heli getVariable "fza_sfmplus_engPctTQ" select 1) * 100;
private _e2opsi = (_heli getVariable "fza_sfmplus_engOilPSI" select 1) * 100;
if (_e2np <= (0.37 * 100)) then {
    _e2trq = 0;
};

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TORQUE_2), round _e2trq];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_TORQUE_2), _e2trq toFixed 0];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_NP_2), round _e2np];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NP_2), _e2np toFixed 0];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TGT_2), round _e2tgt];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_TGT_2), _e2tgt toFixed 0];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NG_2), (_e2ng/10) toFixed 1];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_OIL_PSI_2), _e2opsi toFixed 0];

private _rotorRpm = ([_heli] call fza_sfmplus_fnc_getRtrRPM) * 100;

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_NR), round _rotorRpm];
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NR), _rotorRpm toFixed 0];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TGT_BAR), 965];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TORQUE_BAR), 125];

private _engineStates = _heli getVariable "fza_sfmplus_engState";

private _engineStarted = 0;

if (_engineStates # 0 in ["STARTING", "STARTED"]) then {
    _engineStarted = 1;
};

if (_engineStates # 1 in ["STARTING", "STARTED"]) then {
    _engineStarted = 2;
};

private _pagemode = [2,1] select ([_heli] call fza_sfmplus_fnc_onGround);
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_START), _engineStarted];
private _wcas = [_heli] call fza_fnc_coreGetWCAs;
_wcas = _wcas select {!(WCA_ADVISORY in _x)};
_wcas resize [5, [0," "]];
if (_wcas#0#1 isNotEqualTo " ") then {_pagemode = 3;};
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ENG_MODE), _pagemode];
for "_x" from 0 to 4 do {
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_IND_ENG_WCA_1 + _x), _wcas#_x#1];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_WCA_1 + _x), _wcas#_x#0];
};

//Hydraulics
private _priHydPSI       = round(_heli getVariable "fza_systems_priHydPsi");
private _priHydPSI_text  = format["%1", [str _priHydPSI, 4] call fza_fnc_padString];
private _utilHydPSI      = round(_heli getVariable "fza_systems_utilHydPsi");
private _utilHydPSI_text = format["%1", [str _utilHydPSI, 4] call fza_fnc_padString];
private _accHydPSI       = round((_heli getVariable "fza_systems_accHydPsi") / 10) * 10;
private _accHydPSI_text  = format["%1", [str _accHydPSI, 4] call fza_fnc_padString];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_PRI_HYD_PSI),  _priHydPSI_text];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_UTIL_HYD_PSI), _utilHydPSI_text];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_ACC_HYD_PSI),  _accHydPSI_text];

[_heli, _mpdIndex, MFD_IND_ENG_ACQ_BOX, MFD_TEXT_IND_ENG_ACQ_SRC] call fza_mpd_fnc_acqDraw;
