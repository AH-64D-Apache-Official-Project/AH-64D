/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_onGround

Description:
    Returns true or false based on being in contact with the ground.

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _radAlt   = _heli getVariable "fza_sfmplus_alt_radar";
private _onGround = false;

if (isTouchingGround _heli || _radAlt < 0.5) then {
    _onGround = true;
};

_onGround;