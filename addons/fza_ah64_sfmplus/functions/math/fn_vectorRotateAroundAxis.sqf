// Rodrigues' rotation formula: rotates _inVec around _axis by _angle degrees
params ["_inVec", "_axis", "_angle"];

private _sin = sin _angle;
private _cos = cos _angle;
private _dot = (_inVec select 0) * (_axis select 0)
             + (_inVec select 1) * (_axis select 1)
             + (_inVec select 2) * (_axis select 2);

private _cross =
[
    (_inVec select 1) * (_axis select 2) - (_inVec select 2) * (_axis select 1),
    (_inVec select 2) * (_axis select 0) - (_inVec select 0) * (_axis select 2),
    (_inVec select 0) * (_axis select 1) - (_inVec select 1) * (_axis select 0)
];

[
    (_inVec select 0) * _cos + (_cross select 0) * _sin + (_axis select 0) * _dot * (1 - _cos),
    (_inVec select 1) * _cos + (_cross select 1) * _sin + (_axis select 1) * _dot * (1 - _cos),
    (_inVec select 2) * _cos + (_cross select 2) * _sin + (_axis select 2) * _dot * (1 - _cos)
];
