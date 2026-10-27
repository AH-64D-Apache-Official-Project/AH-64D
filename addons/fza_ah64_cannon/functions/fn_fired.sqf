/* ----------------------------------------------------------------------------
Function: fza_cannon_fnc_eventFired

Description:

Parameters:
    Schema of the "fired" event handler.

Returns:
    Nothing

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli", "_weapon", "_muzzle", "_mode", "_ammotype", "_magazine", "_missobj"];

if !(["fza_m230", _weapon] call BIS_fnc_inString) exitWith {};

// The round leaves the barrel muzzle along the gun's commanded direction (fza_fnc_weaponTurretAim) at the muzzle speed,
// plus the aircraft's velocity. Set as it is created, so it is on this path from its first frame.
private _gunAim = _heli getVariable "fza_cannon_gunAim";
if (!isNil "_gunAim" && {!isNull _missobj}) then {
    if (isNil "fza_cannon_ballistics") then {[_heli, getPosASL _heli] call fza_cannon_fnc_aimSolve};
    // The fire mode's dispersion (rad), which the engine's own aim would have applied
    private _dispersion = deg getNumber (configFile >> "CfgWeapons" >> _weapon >> _mode >> "dispersion");
    private _dir = _heli vectorModelToWorldVisual ([1, (_gunAim # 0) + random [-_dispersion, 0, _dispersion], (_gunAim # 1) + random [-_dispersion, 0, _dispersion]] call CBA_fnc_polar2vect);
    _missobj setPosASL (_heli modelToWorldVisualWorld (_heli selectionPosition ["usti hlavne", "Memory"]));
    _missobj setVectorDir _dir;
    _missobj setVelocity ((_dir vectorMultiply (fza_cannon_ballistics # 0)) vectorAdd velocity _heli);
};
private _burstLimit = _heli getVariable "fza_ah64_burst_limit";
private _CannonFired = (_heli getVariable "fza_ah64_burst_fired") + 1;

if (_burstLimit != -1) then {
    if (_CannonFired >= _burstLimit) then {
        [_heli] spawn {
            params["_heli"];
            waitUntil {
                _heli selectWeaponTurret ["fza_cannon_limit", [0], "fza_cannon_limit"]; // Select weapon Must use the first 3 inputs
                inputAction "defaultAction" < 0.5
            };
            if (currentWeapon _heli != "fza_cannon_limit") exitWith {};
            _heli selectWeaponTurret ["fza_m230", [0], "fza_m230"];
        };
    };
    _heli setVariable ["fza_ah64_burst_fired", _CannonFired];
};

//ACE3 OVERHEATING
//Author: Commy2 and esteldunedain
[_heli, "fza_m230", 3500] call ace_overheating_fnc_updateTemperature;
[_heli] call fza_cannon_fnc_update;
