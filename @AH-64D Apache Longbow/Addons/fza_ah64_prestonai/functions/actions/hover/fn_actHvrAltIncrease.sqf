params ["_heli"];

private _setAltAGL = _heli getVariable "fza_prestonai_setAltAGL";
_setAltAGL         = _setAltAGL + 5;
_setAltAGL         = [_setAltAGL, 0.0, 1420] call BIS_fnc_clamp;

systemChat format ["Climbing to %1 feet...", _setAltAGL];

_heli setVariable ["fza_prestonai_setAltAGL", _setAltAGL];