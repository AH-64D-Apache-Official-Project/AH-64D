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

_gunner = getShotParents _missobj#1;//EH Gunner PARAM is fucked
if (player != _gunner) exitwith {};

_this call fza_cannon_fnc_fired;
_this call fza_hydra_fnc_fired;

//Damages any outside occupants if wing stores used
if (!(_weapon == "fza_m230")) then {
    {
        _x setdamage((damage _x) + 0.05);
    }
    foreach(crew _heli - [gunner _heli, driver _heli]);
};