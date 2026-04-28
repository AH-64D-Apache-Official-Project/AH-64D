/* ----------------------------------------------------------------------------
Function: fza_fnc_eventFired

Description:
    Event handler that handles any ammunition fired by the apache

    - Routes trigger-weapon presses to the scripted weapon fire dispatcher
    - Damages people holding on external stores if pylons fired

Parameters:
    Schema of the "fired" event handler.

Returns:
    Nothing

Examples:

Author:
    unknown, Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli", "_weapon", "_muzzle", "_mode", "_ammotype", "_magazine", "_missobj"];

// -----------------------------------------------------------------------
// Invisible trigger weapon — routes fire input to scripted weapon loops.
// The Fired EH runs on every machine that registered it; only the shooter's
// machine acts. Dispatch is then remoteExec'd to the vehicle owner.
// -----------------------------------------------------------------------
if (_weapon == "fza_ah64_trigger") exitWith {
    if (_weapon isKindOf "fza_trigger") exitwith {};
    private _shooter = getShotParents _missobj # 1;
    deleteVehicle _missobj;
    if (player != _shooter) exitWith {};
    // Determine which crew seat fired so handleControl reads the correct WAS
    private _seat = ["plt", "cpg"] select (_shooter == gunner _heli);
    // Execute on the machine where _heli is local (vehicle owner)
    [_heli, _seat] remoteExecCall ["fza_weapons_fnc_handleControl", _heli];
};

// -----------------------------------------------------------------------
// M230: redirect bullet to animated cannon barrel (turret aims at TADS)
// -----------------------------------------------------------------------
if (_weapon isKindOf ["fza_m230", configFile >> "CfgWeapons"] && local _missobj) then {
    private _muzzlePosWorld = _heli modelToWorldVisualWorld (_heli selectionPosition "Usti hlavne");
    private _authSeat = [_heli, WAS_WEAPON_GUN] call fza_weapons_fnc_getWasSeat;
    private _tPos     = (_heli getVariable ["fza_ah64_sightData_" + _authSeat, [[0,0,0],[0,0,0],0,""]]) # 0;
    private _barrelDir = if !(_tPos isEqualTo [0,0,0]) then {
        vectorNormalized (_tPos vectorDiff _muzzlePosWorld)
    } else {
        private _konecPosWorld = _heli modelToWorldVisualWorld (_heli selectionPosition "Konec hlavne");
        vectorNormalized (_muzzlePosWorld vectorDiff _konecPosWorld)
    };
    _missobj setPosASL _muzzlePosWorld;
    _missobj setVelocity (_barrelDir vectorMultiply (vectorMagnitude velocity _missobj));
};

// -----------------------------------------------------------------------
// All other weapons — guard so only the local shooter runs the damage code
// -----------------------------------------------------------------------
private _gunner = getShotParents _missobj # 1;
if (player != _gunner) exitWith {};

//Damages any outside occupants if wing stores used
{
    _x params ["_unit"];
    switch _weapon do {
        case (_weapon isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]): {
            [_unit, 0.12, (selectRandom ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"]), "thermalburn", _unit] call ace_medical_fnc_addDamageToUnit;
            [_unit, 0.1] call ace_medical_fnc_adjustPainLevel;
        };
        case (_weapon isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]): {
            {
                [_unit, 0.3, _x, "backblast", _unit] call ace_medical_fnc_addDamageToUnit;
            } forEach ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"];
            [_unit, 0.3] call ace_medical_fnc_adjustPainLevel;
        };
        case (_weapon isKindOf ["fza_m230", configFile >> "CfgWeapons"]): {
            [_unit, 0.1] call ace_medical_fnc_adjustPainLevel;
        };
    };
}
forEach (crew _heli - [gunner _heli, driver _heli]);
