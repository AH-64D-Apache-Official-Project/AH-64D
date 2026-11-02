/* ----------------------------------------------------------------------------
Function: fza_fnc_damagePartVisible

Description:
    Shows or hides a damageable part of the airframe, and the parts mounted on it.

Parameters:
    _heli      - The helicopter
    _selection - The hidden selection name
    _visible   - true to show, false to hide

Returns:
    Nothing

Examples:
    --- Code
    [_heli, "skin_tailboom", false] call fza_fnc_damagePartVisible
    ---

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_selection", "_visible"];

private _attached = createHashMapFromArray [
    ["skin_tailboom", ["skin_vtail", "hstab"]],
    ["skin_vtail", ["skin_tailrotor"]]
];
{
    [_heli, _x, _visible] call fza_fnc_damagePartVisible;
} forEach (_attached getOrDefault [toLowerANSI _selection, []]);

private _animations = createHashMapFromArray [
    ["blade1", ["blade1_blur", "blade1_still"]],
    ["blade2", ["blade2_blur", "blade2_still"]],
    ["blade3", ["blade3_blur", "blade3_still"]],
    ["blade4", ["blade4_blur", "blade4_still"]],
    ["skin_tailrotor", [
        "tblade1_blur", "tblade2_blur", "tblade3_blur", "tblade4_blur",
        "tblade1_still", "tblade2_still", "tblade3_still", "tblade4_still"
    ]]
];
{
    _heli animateSource [_x, [0, 1] select _visible, true];
} forEach (_animations getOrDefault [toLowerANSI _selection, []]);

private _index = (getArray (configOf _heli >> "hiddenSelections")) findIf {_x == _selection};
if (_index < 0) exitWith {
    diag_log format ["fza_fnc_damagePartVisible: %1 is not a hidden selection of %2", _selection, typeOf _heli];
};

private _saved = _heli getVariable ["fza_damage_partTextures", createHashMap];
if (_visible) then {
    private _default = (getArray (configOf _heli >> "hiddenSelectionsTextures")) param [_index, ""];
    _heli setObjectTextureGlobal [_index, _saved getOrDefault [_selection, _default]];
    _saved deleteAt _selection;
} else {
    if !(_selection in _saved) then {_saved set [_selection, (getObjectTextures _heli) # _index]};
    _heli setObjectTextureGlobal [_index, ""];
};
_heli setVariable ["fza_damage_partTextures", _saved, true];
