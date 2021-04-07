/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponguncontrol

Description:
    changes current acquisition

Parameters:
    _heli - The helicopter that fired it

Returns:

Examples:
	statement="[this] spawn weaponguncontrol";
    [_heli] spawn weaponguncontrol;

Author:
	
---------------------------------------------------------------------------- */
params ["_heli"];

_curAcq = [_heli] call fza_fnc_targetingGetSightSelect;
_curAcq = _curAcq + 1;
if (_curAcq > 3) then {
    _curAcq = 0;
};

[_heli, _curAcq] call fza_fnc_targetingSetSightSelect;