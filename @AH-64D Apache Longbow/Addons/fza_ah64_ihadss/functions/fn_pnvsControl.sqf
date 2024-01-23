/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_pnvsControl

Description:
    Handles the movement of the PNVS when the player moves their head or mouse (depending on if they are in head tracking mode.)

Parameters:
    _heli - The helicopter to act on

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_pnvsControl
    ---

Author:
    Unknown
---------------------------------------------------------------------------- */
#include "\fza_ah64_systems\headers\systems.hpp"
params["_heli"];

if (player != driver _heli) exitwith {};

private _acBusOn        = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn        = _heli getVariable "fza_systems_dcBusOn";
private _pnvsControl    = _heli getVariable "fza_ah64_ihadss_pnvs_cam";
private _monocle        = _heli getVariable "fza_ah64_monocleinbox";
private _pnvsDamage     = _heli getHitPointDamage "hit_msnEquip_pnvs_turret";

//Pnvs Stowed
if !(_pnvsControl || _acBusOn || _dcBusOn || !_monocle || _pnvsDamage > SYS_SIGHT_DMG_THRESH) exitwith {
    if (_heli animationsourcephase "pnvs" != -120) then {
        _heli animateSource["pnvs", -120];
    };
    if (_heli animationsourcephase "pnvs_vert" != 0) then {
        _heli animateSource["pnvs_vert", 0];
    };
};

(( _heli vectorWorldToModelVisual getCameraViewDirection player) call CBA_fnc_vect2Polar) params ["_mag", "_az", "_el"];
_heli animateSource["pnvs", rad ([_az] call CBA_fnc_simplifyAngle180)];
_heli animateSource["pnvs_vert", rad ([_el] call CBA_fnc_simplifyAngle180)];