/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrTgtHandleControl

Description:
    TGT and ALL on an FCR format, with FCR as the crew station's sight. TGT
    (L4) selects the target store function, the cursor then storing the FCR
    targets it picks (fza_mpd_fnc_cursorEnter), and selected again leaves it.
    ALL (L5, while TGT is selected) stores every target displayed.

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
if (([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_FCR) exitWith {true};

if (_control == "l4") exitWith {
    // Only with targets to store
    if (_tgt == 0 && {(_heli getVariable ["fza_ah64_fcrDisplayTargets", []]) isEqualTo []}) exitWith {true};
    _state set ["tgt", 1 - _tgt];
    _state set ["tgtStored", []];
    true
};

// ALL: the targets displayed, top priority first
{
    [_heli, _state, _x # 0] call fza_mpd_fnc_fcrTgtStore;
} forEach ((_heli getVariable ["fza_ah64_fcrDisplayTargets", []]) select [0, FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS]);
true
