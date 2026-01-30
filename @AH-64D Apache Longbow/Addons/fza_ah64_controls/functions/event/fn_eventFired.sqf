/* ----------------------------------------------------------------------------
Function: fza_fnc_eventFired

Description:
    Event handler that handles any ammunition fired by the apache

    - Ensures correct number of rockets fired in salvo
    - Damages people holding on external stores if pylons fired
    - Checks for gun overheat

Parameters:
    Schema of the "fired" event handler.

Returns:
    Nothing

Examples:

Author:
    unknown, Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli", "_weapon", "_muzzle", "_mode", "_ammotype", "_magazine", "_missobj"];

_gunner = getShotParents _missobj#1;//unable to retrieve correct gunner from EH
if (player != _gunner) exitwith {};

_this call fza_cannon_fnc_fired;
_this call fza_hydra_fnc_fired;

//Damages any outside occupants if wing stores used
{
    _x params ["_unit"];
    switch _weapon do {
        case (_x iskindof "fza_hydra70"): {
            [_unit, 0.12, (selectRandom ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"]), "thermalburn", _unit] call ace_medical_fnc_addDamageToUnit;
            [_unit, 0.1] call ace_medical_fnc_adjustPainLevel;
        };
        case (_x iskindof "fza_hellfire"): {{
                [_unit, 0.3, _x, "backblast", _unit] call ace_medical_fnc_addDamageToUnit;
            } foreach ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"];
            [_unit, 0.3] call ace_medical_fnc_adjustPainLevel;
        };
        case (_x iskindof "fza_m230"): {
            [_unit, 0.1] call ace_medical_fnc_adjustPainLevel;
        };
    };  
}
foreach(crew _heli - [gunner _heli, driver _heli]);