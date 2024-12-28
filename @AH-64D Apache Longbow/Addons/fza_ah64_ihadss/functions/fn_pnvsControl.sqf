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
if (!_pnvsControl || !_acBusOn || !_dcBusOn || _monocle || _pnvsDamage > SYS_SIGHT_DMG_THRESH) exitwith {
    [_heli, "pnvs", -120] call fza_fnc_updateAnimations;
    [_heli, "pnvs_vert", 0] call fza_fnc_updateAnimations;
};

(( _heli vectorWorldToModelVisual getCameraViewDirection player) call CBA_fnc_vect2Polar) params ["_mag", "_az", "_el"];

private _az = [([_az] call CBA_fnc_simplifyAngle180), -120, 120] call BIS_fnc_clamp;

private _elCorTbl = 
[
 [-90.0,  3.2]
,[-45.0, -0.4] 
,[  0.0, -1.9]
,[ 45.0, -0.4]
,[ 90.0,  3.2]
];

private _elCor = [_elCorTbl, _az] call fza_fnc_linearInterp select 1;
private _el    = [([_el + _elCor] call CBA_fnc_simplifyAngle180), -45, 20] call BIS_fnc_clamp;

[_heli, "pnvs", rad _az] call fza_fnc_updateAnimations;
[_heli, "pnvs_vert", rad _el] call fza_fnc_updateAnimations;