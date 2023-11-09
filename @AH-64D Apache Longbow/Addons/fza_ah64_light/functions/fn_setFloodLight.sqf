/* ----------------------------------------------------------------------------
Function: fza_light_fnc_setFloodLight

Description:
    Sets the cockpit light to the correct state

Parameters:
    _heli - The heli to act upon
    _turret - the seat to toggle
    _state - whether the cockpit light should be off. 0 or false for off, 1 or true for on.

Returns:
    Nothing

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli", "_turret", "_state"];

private _value     = [false, true] select (_turret isEqualTo [-1]);
private _hitpoint  = ["#cpg_flood_sel", "#plt_flood_sel"] select _value;
private _variable  = ["fza_ah64_lightCpgFlood", "fza_ah64_lightPltFlood"] select _value;
private _texture   = ["\fza_ah64_us\tex\in\pushbut.paa", "\fza_ah64_us\tex\in\dlt.paa"] select _value;
private _texture   = ["", _texture] select _state;
private _selection = ["in_backlight2", "in_backlight"] select _value;
private _damageval = [1,0] select _state;

_heli setHitPointDamage [_hitpoint, _damageval];
_heli setVariable [_variable, _state];
_heli setObjectTextureGlobal [_selection, _texture];