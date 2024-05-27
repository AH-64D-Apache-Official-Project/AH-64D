// bmkhs_fnc_quaternionFromV3 by MadRussian (created long ago, updated 2/11/19)
// This is a simple vector to quaternion conversion.
// Call with: [Vector3] call bmkhs_fnc_quaternionFromV3;
// Example: _quaternion = [[1,1,1]] call bmkhs_fnc_quaternionFromV3;
// Result is [1,1,1,0]
//
//https://forums.bohemia.net/forums/topic/221791-quaternion-rotation-functions-release/
params ["_V"];

[_V select 0, _V select 1, _V select 2, 0]