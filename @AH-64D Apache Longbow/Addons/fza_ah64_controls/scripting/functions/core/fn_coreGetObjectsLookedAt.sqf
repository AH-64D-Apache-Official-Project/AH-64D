/* ----------------------------------------------------------------------------
Function: fza_fnc_coreGetObjectsLookedAt

Description:
    Retrieves information about each object that is looked at by the user.

    Works for both pilot and gunner seats, and uses preconfigured sensitivity to
    determine the zone it works for.

Parameters:
    _heli - The apache helicopter to get information from [Unit].

Returns:
    2d array, an array for each control that is in range in the format of:
        [Pilot memory point, Gunner memory point, system, control, sensitivity, description, distance]

Examples:
    --- Code
    // Player not looking at anything
    _data = [_heli] call fza_fnc_coreGetObjectsLookedAt
    // _data = []

    // Player looking at the L1 button on the right MPD
    _data = [_heli] call fza_fnc_coreGetObjectsLookedAt
    // _data = [["ctrlref_rmpd_l1", "ctrlref_g_rmpd_l1", "rmpd", "l1", 0.015, "Right MPD L1"]]
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli"];

private _controls = _heli getvariable "fza_ah64_objectsDataArray";
private _horizontalPos = _heli getVariable "fza_ah64_freeCursorHpos";
private _verticalpos = _heli getVariable "fza_ah64_freeCursorVpos";

_controls select {
    _x params ["_pilotPos", "_gunnerPos", "_systemName", "_eventName", "_sensitivity", "_description", "_movable", "_distance"];
    private _point = [];
    if(driver _heli == player) then {
        if (_pilotPos isEqualTo "") then {continue;};
        if (_movable) exitwith {
            _point = _heli modelToWorldVisual (_heli selectionposition _pilotPos);
        };
        _point = _heli modelToWorldVisual _pilotPos;
    };
    if(gunner _heli == player) then {
        if (_gunnerPos isEqualTo "") then {continue;};
        if (_movable) exitwith {
            _point = _heli modelToWorldVisual (_heli selectionposition _gunnerPos);
        };
        _point = _heli modelToWorldVisual _gunnerPos;
    };
    _point =  (worldToScreen _point);
    if (_point isEqualTo []) then {continue};
    _distance = _point distance [_horizontalPos, _verticalpos];
    _x set [7, _distance];
    (_distance <= _sensitivity);
};