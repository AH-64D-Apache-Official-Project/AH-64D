// fza_sfmplus_fnc_quaternionConjugate by MadRussian (created long ago, updated 2/11/19)
// This returns a simple quaternion conjugate.
// Call with: [Quaternion] call fza_sfmplus_fnc_quaternionConjugate;
// Example: _quaternionConjugate = [[1,1,1,0]] call fza_sfmplus_fnc_quaternionConjugate;
// Result is [-1,-1,-1,0]
//
//https://forums.bohemia.net/forums/topic/221791-quaternion-rotation-functions-release/
params ["_Q"];

private ["_x","_y","_z","_w"];

_x = -(_Q select 0);
_y = -(_Q select 1);
_z = -(_Q select 2);
_w =  (_Q select 3);

[_x, _y ,_z ,_w]