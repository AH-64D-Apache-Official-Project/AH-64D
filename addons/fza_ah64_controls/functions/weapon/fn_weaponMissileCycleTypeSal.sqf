/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponMissileCycleTypeSal

Description:
    Cycles through the available hellfire types

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_fnc_weaponMissileCycle

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
private _missiles = _missiles - ["fza_agm114l_wep"];

if (_missiles isEqualTo []) exitWith {};

private _nextMissile = [_missiles, _heli getVariable "fza_ah64_selectedMissile"] call fza_fnc_cycle;

_heli setVariable ["fza_ah64_selectedMissile", _nextMissile, true];
[_heli] call fza_fnc_weaponUpdateSelected;
