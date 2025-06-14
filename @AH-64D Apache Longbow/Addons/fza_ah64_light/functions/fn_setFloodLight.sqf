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

private _animation = ["cpg_flood", "plt_flood"] select (_turret isEqualTo [-1]);

_heli animateSource [_animation, ([0,1] select _state)];