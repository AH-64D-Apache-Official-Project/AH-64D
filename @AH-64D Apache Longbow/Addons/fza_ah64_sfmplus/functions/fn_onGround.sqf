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

([_heli] call fza_sfmplus_fnc_getAltitude)
    params ["_barAlt", "_radAlt"];

private _onGround = false;

if (isTouchingGround _heli || _radAlt < 0.5) then {
    _onGround = true;
};

_onGround;