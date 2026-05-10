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
    // Barrel positions are cached each draw3D frame by fn_cannonPylonController
    // (selectionPosition is unreliable during a Fired EH — visual LOD state differs)
    private _muzzleASL = _heli getVariable "fza_ah64_cannonMuzzleASL";
    private _konecASL  = _heli getVariable "fza_ah64_cannonKonecASL";
    // Fallback: re-query if cache is not yet populated (first round after mission start)
    if (isNil "_muzzleASL") then {
        _muzzleASL = _heli modelToWorldVisualWorld (_heli selectionPosition "Usti hlavne");
        _konecASL  = _heli modelToWorldVisualWorld (_heli selectionPosition "Konec hlavne");
    };
    // Direction from breech (Konec) toward muzzle tip (Usti) — forward along barrel
    private _barrelDir = vectorNormalized (_muzzleASL vectorDiff _konecASL);

    private _origDir   = vectorNormalized (velocity _missobj);
    private _spd       = vectorMagnitude velocity _missobj;
    private _parallel  = _barrelDir vectorMultiply (_origDir vectorDotProduct _barrelDir);
    private _perp      = _origDir vectorDiff _parallel;   // pure dispersion component
    private _finalDir  = vectorNormalized (_barrelDir vectorAdd _perp);
    _missobj setPosASL _muzzleASL;
    _missobj setVelocity (_finalDir vectorMultiply _spd);
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
