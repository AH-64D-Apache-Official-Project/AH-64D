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

private _onGround = false;

if (currentpilot _heli == player) then {
    ([_heli] call fza_sfmplus_fnc_getAltitude)
        params ["_barAlt", "_radAlt"];

    if (isTouchingGround _heli || _radAlt < 1) then {
        _onGround = true;
    };
    _heli setVariable ["fza_ah64_groundContact", _onGround];
} else {
    _onGround = _heli getvariable "fza_ah64_groundContact";
};

_onGround;