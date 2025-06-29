/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_TurretAim

Description:
    Points turrets, sensors and weaponry at the correct positions according to acquisition sources.

Parameters:
    _heli - the heli to fix the turret for.

Returns:
    Nothing

Examples:
    [_heli] call fza_weapons_fnc_TurretAim

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_sfmplus\headers\core.hpp"
params["_heli"];

if (_heli getVariable "fza_ah64_was_cpg" == WAS_WEAPON_GUN && ([_heli] call fza_fnc_getSeat != "cpg")) exitWith {};
if (_heli getVariable "fza_ah64_was_cpg" != WAS_WEAPON_GUN && ([_heli] call fza_fnc_getSeat == "cpg")) exitwith {};

private _was             = [_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable;
private _sight           = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _inhibit         = "";

private _gunDamage     = (_heli getHitPointDamage "hit_msnEquip_gun_turret" > SYS_WPN_DMG_THRESH);
private _magDamage     = (_heli getHitPointDamage "hit_msnEquip_magandrobbie" > SYS_WPN_DMG_THRESH && _heli animationPhase "magazine_set_1200" == 1);
private _utilLevelMin  = (_heli getVariable "fza_systems_utilLevel_pct" < SYS_HYD_MIN_LVL);
private _utilHydFailed = (_heli getVariable "fza_systems_utilHydPSI" < SYS_MIN_HYD_PSI);
private _acBusOn       = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn       = _heli getVariable "fza_systems_dcBusOn";
private _gunFailed = (_utilHydFailed || _utilLevelMin || _gunDamage || !_acBusOn || !_dcBusOn || _magDamage);
private _mainturret = 0;
private _maingun = 0.298;
private _cameraTarget = objNull;

(_heli call fza_weapons_fnc_sightData) params ["_targPos", "_targVel", "_targDistance", "_inhibit"];

if (_was == WAS_WEAPON_GUN) then {
    if (_gunFailed) exitwith {
        // If the gun is failed, we don't want to do anything
    };
    private _tadsElevation = _heli getVariable "fza_ah64_tadsElevation";
    private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
    if !(-86 < _tadsAzimuth && _tadsAzimuth < 86) then {
        _inhibit = "AZ LIMIT";
    };
    if !(-60 < _tadsElevation && _tadsElevation < 11) then {
        _inhibit = "EL LIMIT";
    };
    if (_inhibit != "") then {
        _safemessage = "_inhibit";
        // If the gun is inhibited, we don't want to do anything
    } else {
        if (Currentweapon _heli == "fza_gun_inhibit") then {
            //allow the gun to be used
        };
    };
    if (_sight == SIGHT_FXD) exitwith {
        _mainturret = 0;
        _maingun = 0;
        _inhibit = "GUN FIXED";
        //safeMessage //GUN FIXED
    };
    _mainturret = -rad ([_tadsAzimuth, -86, 86] call BIS_fnc_clamp);
    _maingun = rad ([_tadsElevation, -60, 11] call BIS_fnc_clamp);
};
if (_gunFailed) then {
    _mainturret = _heli animationphase "mainTurret";
    _maingun = 0.298;
};

[_heli, "mainTurret", _mainturret] call fza_fnc_updateAnimations;
[_heli, "mainGun", _maingun] call fza_fnc_updateAnimations;

[_heli, "fza_ah64_weaponInhibited", _inhibit] call fza_fnc_updateNetworkGlobal;