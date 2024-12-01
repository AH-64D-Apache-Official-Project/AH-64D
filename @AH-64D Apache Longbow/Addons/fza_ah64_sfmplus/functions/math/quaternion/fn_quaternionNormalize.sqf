// fza_sfmplus_fnc_quaternionNormalize by MadRussian (created long ago, updated 2/11/19)
// This performs a simple quaternion normalize.
// Call with: [Quaternion] call fza_sfmplus_fnc_quaternionNormalize;
// Example: _quaternionNormal = [[7,0,0,0]] call fza_sfmplus_fnc_quaternionNormalize;
// Result is [1,0,0,0]
//
//https://forums.bohemia.net/forums/topic/221791-quaternion-rotation-functions-release/    
params ["_Q"];
    
private ["_l","_result"];

_l = sqrt ( (_Q select 0)*(_Q select 0) + (_Q select 1)*(_Q select 1) + (_Q select 2)*(_Q select 2) + (_Q select 3)*(_Q select 3) );

_result = [0,0,0,0];
if (_l != 0) then { _result = [(_Q select 0)/_l, (_Q select 1)/_l, (_Q select 2)/_l, (_Q select 3)/_l] };

_result
