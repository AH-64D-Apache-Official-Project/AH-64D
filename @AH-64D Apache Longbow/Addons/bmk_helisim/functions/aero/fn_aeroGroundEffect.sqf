/* ----------------------------------------------------------------------------
Function: bmk_fn_aeroGroundEffect

Description:
  ...

Parameters:
  ...

Returns:

Examples:
  ...

Author:
  BradMick
---------------------------------------------------------------------------- */
params["_heli", "_heightAGL", "_rotorParams"];

//Currently suspect, need to investigate that it's doing what it's supposed to do...

_rotorParams params ["_a", "_b", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s", "_polarMOI"];

_heightAGL           = _heightAGL  + (ASLToAGL getPosASL _heli # 2);

private _rtrDiameter = _R * 2.0;
private _rtrFactor   = _heightAGL / _rtrDiameter;

private _gndEffScalar_1 = -18.133 * (_rtrFactor * _rtrFactor);
private _gndEffScalar_2 =  58.857 * (_rtrFactor * _rtrFactor);
private _gndEffScalar_3 = -68.152 * (_rtrFactor * _rtrFactor);

private _gndEffScalar = 1 - ((_gndEffScalar_1 + _gndEffScalar_2 + _gndEffScalar_3 + 28.64) / 100.0);
_gndEffScalar = [_gndEffScalar, 0.85, 1.0] call BIS_fnc_clamp;

//systemChat format ["%1", _gndEffScalar toFixed 2];

[_gndEffScalar];