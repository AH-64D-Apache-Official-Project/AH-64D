/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_MissileCycleType

Description:
    Cycles to the Longbow FCR-guided AGM-114L missile type if available.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];
_heli = vehicle player;

private _missiles       = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
private _currentMissile = _heli getVariable "fza_ah64_selectedMissile";
private _nextMissile    = _missiles # 0;

if (_missiles isEqualTo []) exitWith {};
if (_currentMissile != "fza_agm114l_wep" && "fza_agm114l_wep" in _missiles) then {
    _nextMissile = "fza_agm114l_wep";
};

_heli setVariable ["fza_ah64_selectedMissile", _nextMissile, true];
