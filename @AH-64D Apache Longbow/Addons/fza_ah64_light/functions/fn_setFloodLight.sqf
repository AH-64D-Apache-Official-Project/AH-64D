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
private _animation = ["cpg_flood", "plt_flood"] select _value;
private _texture   = ["\fza_ah64_us\tex\in\pushbut.paa", "\fza_ah64_us\tex\in\dlt.paa"] select _value;
private _texture   = ["", _texture] select _state;
private _selection = ["in_backlight2", "in_backlight"] select _value;

_heli animateSource [_animation, ([0,1] select _state)];
_heli setObjectTextureGlobal [_selection, _texture];