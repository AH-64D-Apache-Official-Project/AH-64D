params ["_input"];
if (count _input > 8) exitWith {false};
private _ret = _input call fza_dms_fnc_gridToPos;
if (_ret isEqualTo -1) exitWith {false};
[true, _ret];