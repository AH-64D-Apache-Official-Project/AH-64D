/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_MissileCycle

Description:
    Cycles through the available hellfire types

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_weapons_fnc_MissileCycle

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};

if (_missiles isEqualTo []) exitWith {};

private _nextMissile = [_missiles, _heli getVariable "fza_ah64_selectedMissile"] call fza_fnc_cycle;

_heli setVariable ["fza_ah64_selectedMissile", _nextMissile, true];
[_heli] call fza_weapons_fnc_UpdateSelected;