// fza_sfmplus_fnc_quaternionMultiply by MadRussian (created long ago, updated 2/11/19)
// This performs a simple quaternion multiplication.
// Call with: [Quaternion1, Quaternion2] call fza_sfmplus_fnc_quaternionMultiply;
// Example: _quaternion = [ [1,1,1,0], [0,0,0,1] ] call fza_sfmplus_fnc_quaternionMultiply;
// Result is [1,1,1,0]
//
//https://forums.bohemia.net/forums/topic/221791-quaternion-rotation-functions-release/
params ["_qA","_qB"];

private ["_x","_y","_z","_w"];

_x = (_qA select 3)*(_qB select 0) + (_qA select 0)*(_qB select 3) + (_qA select 1)*(_qB select 2) - (_qA select 2)*(_qB select 1);
_y = (_qA select 3)*(_qB select 1) - (_qA select 0)*(_qB select 2) + (_qA select 1)*(_qB select 3) + (_qA select 2)*(_qB select 0);
_z = (_qA select 3)*(_qB select 2) + (_qA select 0)*(_qB select 1) - (_qA select 1)*(_qB select 0) + (_qA select 2)*(_qB select 3);
_w = (_qA select 3)*(_qB select 3) - (_qA select 0)*(_qB select 0) - (_qA select 1)*(_qB select 1) - (_qA select 2)*(_qB select 2);

[_x, _y, _z, _w]