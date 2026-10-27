/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsNvsReset

Description:
    Sets the TADS turned as an NVS sensor back to the turret.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_ihadss_fnc_tadsNvsReset

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_ihadss_tadsNvsDriving", false];
_heli setVariable ["fza_ihadss_tadsNvsLos", nil];
[_heli, "tads_nvs_tur", 0, true] call fza_anim_fnc_updateAnimations;
[_heli, "tads_nvs", 0, true] call fza_anim_fnc_updateAnimations;
