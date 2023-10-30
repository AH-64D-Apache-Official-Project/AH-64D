params ["_heli", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _heliVel  = velocityModelSpace _heli;
private _heliVelX = _heliVel # 0 + EPSILON;
private _heliVelY = _heliVel # 1 + EPSILON;
private _heliVelZ = _heliVel # 2 + EPSILON;

private _gravity  = [[0.0, 0.0, -9.806], (_heli call BIS_fnc_getPitchBank) # 1, 1] call BIS_fnc_rotateVector3D;
_gravityX         = _gravity # 0;
_gravityY         = _gravity # 1;
_gravityZ         = _gravity # 2;

//X Axis Acceleration
private _prevVelX = _heli getVariable "fza_sfmplus_fuselagePrevVelX";
private _curVelX  = _heliVelX;
_heli setVariable ["fza_sfmplus_fuselagePrevVelX", _curVelX];

private _deltaX   = (_curVelX - _prevVelX) / _deltaTime;
private _accelX   = _heli getVariable "fza_sfmplus_fuselageAccelX";
_accelX           = [_accelX, _deltaX, _deltaTime] call BIS_fnc_lerp;
_heli setVariable ["fza_sfmplus_fuselageAccelX", _accelX];
private _accelX_g = (_accelX + _gravityX) / 9.806;
//Y Axis Acceleration
private _prevVelY = _heli getVariable "fza_sfmplus_fuselagePrevVelY";
private _curVelY  = _heliVelY;
_heli setVariable ["fza_sfmplus_fuselagePrevVelY", _curVelY];

private _deltaY   = (_curVelY - _prevVelY) / _deltaTime;
private _accelY   = _heli getVariable "fza_sfmplus_fuselageAccelY";
_accelY           = [_accelY, _deltaY, _deltaTime] call BIS_fnc_lerp;
_heli setVariable ["fza_sfmplus_fuselageAccelY", _accelY];
private _accelY_g = (_accelY + _gravityY) / 9.806;

//Z Axis Acceleration
private _prevVelZ = _heli getVariable "fza_sfmplus_fuselagePrevVelZ";
private _curVelZ  = _heliVelZ;
_heli setVariable ["fza_sfmplus_fuselagePrevVelZ", _curVelZ];

private _deltaZ   = (_curVelZ - _prevVelZ) / _deltaTime;
private _accelZ   = _heli getVariable "fza_sfmplus_fuselageAccelZ";
_accelZ           = [_accelZ, _deltaZ, _deltaTime] call BIS_fnc_lerp;
_heli setVariable ["fza_sfmplus_fuselageAccelZ", _accelZ];
private _accelZ_g = (_accelZ + _gravityZ) / 9.806;

private _beta     = if (vectorMagnitude [_accelX, _accelY, _accelZ] < EPSILON) then { 0.0; } else { asin (_accelX / sqrt(vectorMagnitude [_accelX, _accelY, _accelZ])); };


_heli setVariable ["fza_sfmplus_fuselageAccel", [_accelX_g, _accelY_g, _accelZ_g]];


systemChat format ["_beta = %1", _beta toFixed 2];