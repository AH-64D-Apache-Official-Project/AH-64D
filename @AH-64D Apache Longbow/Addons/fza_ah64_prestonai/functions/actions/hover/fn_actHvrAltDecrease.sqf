params ["_heli"];

#define FEET_TO_METERS 0.3048

private _curAltAGL = ASLToAGL getPosASL _heli # 2;
private _setAltAGL = _heli getVariable "fza_prestonai_setAltAGL";

_setAltAGL = _setAltAGL - 5;
_setAltAGL = [_setAltAGL, 0.0, 1420] call BIS_fnc_clamp;

systemChat format ["Descending to %1 feet...", _setAltAGL];

_heli setVariable ["fza_prestonai_setAltAGL", _setAltAGL];