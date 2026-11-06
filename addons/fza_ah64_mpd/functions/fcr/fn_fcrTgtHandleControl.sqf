/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrTgtHandleControl

Description:
    TGT and ALL on an FCR format. TGT (L4), with FCR as the crew station's
    sight, selects the target store function, the cursor then storing the FCR
    targets it picks (fza_mpd_fnc_cursorEnter), and selected again leaves it,
    whatever the sight. ALL (L5, while TGT is selected, with FCR as the sight)
    stores every target displayed.

Parameters:
    _heli     - The helicopter
    _mpdIndex - 0 left MPD, 1 right
    _control  - The button pressed
    _state    - The FCR format's page state

Returns:
    True if it was TGT or ALL

Examples:
    --- Code
    if ([_heli, _mpdIndex, _control, _state] call fza_mpd_fnc_fcrTgtHandleControl) exitWith {};
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_control", "_state"];

if !(_control in ["l4", "l5"]) exitWith {false};
private _tgt = _state getOrDefault ["tgt", 0];
if (_control == "l5" && {_tgt == 0}) exitWith {false};
private _fcrSight = ([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) == SIGHT_FCR;

if (_control == "l4") exitWith {
    // Left whatever the sight; selected only with the FCR as the sight and targets to store
    if (_tgt == 0 && {!_fcrSight || {(_heli getVariable ["fza_ah64_fcrDisplayTargets", []]) isEqualTo []}}) exitWith {true};
    _state set ["tgt", 1 - _tgt];
    _state set ["tgtStored", []];
    _state set ["tgtStoredTargets", []];
    true
};
if (!_fcrSight) exitWith {true};

// ALL: the target symbols the format draws (fza_mpd_fnc_fcrGTMDraw, fza_mpd_fnc_fcrATMDraw, fza_mpd_fnc_fcrRMAPDraw), top
// priority first
[_heli, _state, (_state getOrDefault ["cursorTargets", []]) apply {[_x # 3, _x # 2]}] call fza_mpd_fnc_fcrTgtStore;
true
