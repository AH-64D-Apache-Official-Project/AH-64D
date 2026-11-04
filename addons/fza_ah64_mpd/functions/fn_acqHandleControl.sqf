/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_acqHandleControl

Description:
    The acquisition source list of pages with an ACQ button. ACQ (R6) opens it
    on that MPD; it lists the sources the crew station can select at R1 PHS,
    R2 GHS, R5 FCR, R6 FXD, B5 the crew station's coordinate point and B6 TADS.
    While it is open it takes every button: a listed source selects it, and any
    press closes the list.

Parameters:
    _heli     - The helicopter
    _mpdIndex - 0 left, 1 right
    _control  - The button pressed
    _canOpen  - Whether ACQ opens the list from this page state

Returns:
    True when the button was used by the list

Examples:
    if ([_heli, _mpdIndex, _control] call fza_mpd_fnc_acqHandleControl) exitWith {};

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_mpdIndex", "_control", ["_canOpen", true]];

private _open = +(_heli getVariable ["fza_mpd_acqMenu", [false, false]]);
if !(_open # _mpdIndex) exitWith {
    if (_canOpen && _control == "r6") then {
        _open set [_mpdIndex, true];
        _heli setVariable ["fza_mpd_acqMenu", _open];
        _heli setUserMFDValue [[MFD_IND_ACQ_OPEN_L, MFD_IND_ACQ_OPEN_R] select _mpdIndex, 1];
        true
    } else {false};
};

private _option = ["r1", "r2", "r3", "r4", "r5", "r6", "b6"] find _control;
if (_option >= 0) then {
    [_heli, ["PHS", "GHS", "SKR", "RFI", "FCR", "FXD", "TADS"] # _option] call fza_fnc_targetingAcqSet;
};
if (_control == "b4") then {
    // TRN, the crew station's terrain point from CAQ, if it has one
    private _trn = [POINT_TYPE_TG, [POINT_INDEX_TG_TRN_PLT, POINT_INDEX_TG_TRN_CPG] select (([_heli] call fza_fnc_getSeat) == "cpg")];
    if (!isNil {[_heli, _trn, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue}) then {
        [_heli, _trn call fza_dms_fnc_pointToString] call fza_fnc_targetingAcqSet;
    };
};
if (_control == "b5") then {
    [_heli, _heli getVariable ["fza_ah64_acqPoint_" + ([_heli] call fza_fnc_getSeat), ACQ_POINT_NONE]] call fza_fnc_targetingAcqSet;
};
_open set [_mpdIndex, false];
_heli setVariable ["fza_mpd_acqMenu", _open];
_heli setUserMFDValue [[MFD_IND_ACQ_OPEN_L, MFD_IND_ACQ_OPEN_R] select _mpdIndex, 0];
true
