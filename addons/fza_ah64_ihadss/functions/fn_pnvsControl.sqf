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
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params["_heli"];

if (player != driver _heli && (_heli animationPhase "plt_nvsmode" == 0 && (_heli animationPhase "cpg_nvsmode" != 0))) exitWith {};

private _acBusOn        = _heli getVariable "bmkhs_acBusOn";
private _dcBusOn        = _heli getVariable "bmkhs_dcBusOn";
private _pnvsControl    = _heli getVariable "fza_ah64_nvsModeSwitchNorm";
private _monocle        = _heli getVariable "fza_ah64_monocleinbox";
private _pnvsDamage     = _heli getHitPointDamage "hit_msnEquip_pnvs_turret";

//Pnvs Stowed
if ((_pnvsControl == 0) || !_acBusOn || !_dcBusOn || _monocle || _pnvsDamage > SYS_SIGHT_DMG_THRESH) exitWith {
    [_heli, "pnvs", -120] call fza_anim_fnc_updateAnimations;
    [_heli, "pnvs_vert", 0] call fza_anim_fnc_updateAnimations;
};
if (_pnvsControl == 1) exitWith {
    [_heli, "pnvs", 0] call fza_anim_fnc_updateAnimations;
    [_heli, "pnvs_vert", 0] call fza_anim_fnc_updateAnimations;
};

(( _heli vectorWorldToModelVisual getCameraViewDirection player) call CBA_fnc_vect2Polar) params ["_mag", "_az", "_el"];

// The PNVS field of regard is +-90 deg; -120 is only the stow position
private _az = [([_az] call CBA_fnc_simplifyAngle180), -90, 90] call BIS_fnc_clamp;

// Includes a +3 deg bias found in game to line the PNVS picture up with the world
private _elCorTbl =
[
 [-90.0,  5.2]
,[-45.0,  1.3]
,[  0.0,  0.3]
,[ 45.0,  1.3]
,[ 90.0,  5.2]
];

// Live tunes in the debug console: fza_ihadss_pnvsElCorTbl replaces the table above, fza_ihadss_pnvsElBias adds degrees to it
private _tuneTbl = missionNamespace getVariable ["fza_ihadss_pnvsElCorTbl", []];
if (_tuneTbl isEqualType [] && {count _tuneTbl > 1 && {_tuneTbl findIf {!(_x isEqualTypeArray [0, 0])} == -1}}) then {
    _elCorTbl = _tuneTbl;
};
private _elBias = missionNamespace getVariable ["fza_ihadss_pnvsElBias", 0];
if !(_elBias isEqualType 0) then {_elBias = 0};

private _elCor = ([_elCorTbl, _az] call fza_fnc_linearInterp select 1) + _elBias;
private _el    = [([_el + _elCor] call CBA_fnc_simplifyAngle180), -45, 20] call BIS_fnc_clamp;

[_heli, "pnvs", rad _az, true] call fza_anim_fnc_updateAnimations;
[_heli, "pnvs_vert", rad _el, true] call fza_anim_fnc_updateAnimations;
