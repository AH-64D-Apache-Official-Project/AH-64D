// MRU_V3_QRotation by MadRussian (created long ago, updated 2/11/19)
// This performs a simple(?) quaternion rotation.
// Call with: [OrigVector, RotationAxis, RotationAngle] call MRU_V3_QRotation;
//  where OrigVector is the original 3D vector to be translated
//        RotationAxis is the rotational axis to be rotated about, represented by a 3D vector
//        RotationalAngle is the angle to rotate by in degrees
//
// Example: _vector3 = [ [0,0,1], [1,0,0], 90 ] call MRU_V3_QRotation;
//		would result in a rotated 3D vector of [0,1,0]
//
//https://forums.bohemia.net/forums/topic/221791-quaternion-rotation-functions-release/
params ["_origV","_rotAxis","_rotAng"];

private ["_origQ","_rotAxisQ","_rotAxisNormQ","_sinAD","_rotAxisTransQ","_rotAxisConjQ","_preResultQ","_resultQ"];

_origQ         = [_origV] call fza_sfmplus_fnc_quaternionFromVec3;
_rotAxisQ      = [_rotAxis] call fza_sfmplus_fnc_quaternionFromVec3;

_rotAxisNormQ  = [_rotAxisQ] call fza_sfmplus_fnc_quaternionNormalize;
_sinAD         = sin(_rotAng/2);
_rotAxisTransQ = [ (_rotAxisNormQ select 0)*_sinAD, (_rotAxisNormQ select 1)*_sinAD, (_rotAxisNormQ select 2)*_sinAD, cos(_rotAng/2) ];
_rotAxisConjQ  = [_rotAxisTransQ] call fza_sfmplus_fnc_quaternionConjugate;

_preResultQ    = [_rotAxisTransQ, _origQ] call fza_sfmplus_fnc_quaternionMultiply;
_resultQ       = [_preResultQ, _rotAxisConjQ] call fza_sfmplus_fnc_quaternionMultiply;

[_resultQ select 0, _resultQ select 1, _resultQ select 2]