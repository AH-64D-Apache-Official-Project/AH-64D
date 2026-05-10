/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_MissileCycleTypeSal

Description:
    Cycles through the available SAL (semi-active laser) Hellfire types,
    excluding the AGM-114L FCR variant.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

private _missiles = (weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]}) - ["fza_agm114l_wep"];

if (_missiles isEqualTo []) exitWith {};

private _nextMissile = [_missiles, _heli getVariable "fza_ah64_selectedMissile"] call fza_fnc_cycle;

_heli setVariable ["fza_ah64_selectedMissile", _nextMissile, true];
