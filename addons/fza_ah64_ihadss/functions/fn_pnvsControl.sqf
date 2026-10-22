/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_pnvsControl

Description:
    Handles the movement of the PNVS when the player moves their head or mouse (depending on if they are in head tracking mode.)
    The PNVS is moved by the crew station with it as their night vision sensor (fza_ihadss_fnc_nvsState), the pilot by
    default; with nobody there, by the machine the aircraft is local to, which stows it. It turns at PNVS_SLEW_RATE.

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
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli"];

private _pnvsSeat = ["cpg", "plt"] select ((_heli getVariable ["fza_ah64_nvsTadsSeat", "cpg"]) == "cpg");
private _owner    = [gunner _heli, driver _heli] select (_pnvsSeat == "plt");
if (_owner != player && {isPlayer _owner || {!local _heli}}) exitWith {};

private _acBusOn        = _heli getVariable "bmkhs_acBusOn";
private _dcBusOn        = _heli getVariable "bmkhs_dcBusOn";
private _pnvsControl    = [NVS_MODE_OFF, ([_heli, _pnvsSeat] call fza_ihadss_fnc_nvsState) # 0] select (_owner == player);
private _pnvsDamage     = _heli getHitPointDamage "hit_msnEquip_pnvs_turret";

// Turned from where it points now at its slew rate
private _slew = {
    params ["_az", "_el"];
    private _step  = PNVS_SLEW_RATE * ((["fza_ihadss_pnvsSlew"] call BIS_fnc_deltaTime) min 0.1);
    private _nowAz = deg (_heli animationPhase "pnvs");
    private _nowEl = deg (_heli animationPhase "pnvs_vert");
    [_heli, "pnvs", rad (_nowAz + (((_az - _nowAz) max -_step) min _step)), true] call fza_anim_fnc_updateAnimations;
    [_heli, "pnvs_vert", rad (_nowEl + (((_el - _nowEl) max -_step) min _step)), true] call fza_anim_fnc_updateAnimations;
};

//Pnvs Stowed; the head is tracked by the IHADSS helmet, not the monocle, so NORM follows the head with the monocle up too,
//and with no helmet has no head to follow
private _noHead = _pnvsControl == NVS_MODE_NORM && {!([_owner] call fza_ihadss_fnc_hasHelmet)};
if ((_pnvsControl == NVS_MODE_OFF) || _noHead || !_acBusOn || !_dcBusOn || _pnvsDamage > SYS_SIGHT_DMG_THRESH) exitWith {
    [-120, 0] call _slew;
};

(( _heli vectorWorldToModelVisual getCameraViewDirection player) call CBA_fnc_vect2Polar) params ["_mag", "_az", "_el"];
// FIXED: fixed forward, 4.9 deg below the airframe datum
if (_pnvsControl == NVS_MODE_FIXED) then {
    _az = 0;
    _el = NVS_FIXED_EL;
};

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

// The CPG's picture needs its own correction for the head it follows (fza_ihadss_fnc_nvsBias); FIXED follows none, so
// only the turret's own correction above applies and its picture is the view along the fixed LOS
private _bias = [0, 0];
if (_pnvsControl == NVS_MODE_NORM) then {_bias = [_heli, ["plt", "cpg"] select (_owner == gunner _heli), _az] call fza_ihadss_fnc_nvsBias};
_bias params ["_azBias", "_elBias"];

private _elCor = ([_elCorTbl, _az] call fza_fnc_linearInterp select 1) + _elBias;
private _el    = [([_el + _elCor] call CBA_fnc_simplifyAngle180), -45, 20] call BIS_fnc_clamp;
_az = [_az + _azBias, -90, 90] call BIS_fnc_clamp;

[_az, _el] call _slew;
