/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingStore

Description:
    Stores a position as the next free target point (T##). With every target
    point stored, they are overwritten in turn from T01. The point stored is
    shown for 3 seconds in the inhibit message location of the crew station
    that stored it.

Parameters:
    _heli   - The helicopter
    _posASL - The position to store, PositionASL

Returns:
    The point id stored

Examples:
    --- Code
    [_heli, _ntsPos] call fza_fnc_targetingStore;
    ---

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_posASL"];

private _id = [_heli, POINT_TYPE_TG] call fza_dms_fnc_pointNextFree;
if (_id isEqualTo []) then {
    private _index = _heli getVariable ["fza_ah64_targetStoreOverwrite", 1];
    _id = [POINT_TYPE_TG, _index];
    _heli setVariable ["fza_ah64_targetStoreOverwrite", _index % POINT_COUNT_TG_TH + 1, true];
};
[_heli, _id, "TG", "", ASLToAGL _posASL, _posASL # 2] call fza_dms_fnc_pointCreate;

// Shown to the crew station that stored it, on its own HAD and on the VIDEO page (fza_ihadss_fnc_htmlModel)
_heli setVariable ["fza_ah64_targetStoreMsg", [_id call fza_dms_fnc_pointToString, CBA_missionTime + 3, [_heli] call fza_fnc_getSeat], true];
_id
