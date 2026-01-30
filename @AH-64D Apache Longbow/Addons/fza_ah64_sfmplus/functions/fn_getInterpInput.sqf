params ["_currentInput", "_previousInput"];

private _output       = 0.0;
private _targetOutput = 0.0;

if (_currentInput > 0.0) then {
    _targetOutput =  1.0;
};

if (_currentInput < 0.0) then {
    _targetOutput = -1.0;
};

if (_currentInput == 0.0) then {
    _targetOutput = _previousInput;
};

_output = _previousInput + (_targetOutput - _previousInput) * (abs _currentInput);
_output = [_output, -1.0, 1.0] call BIS_fnc_clamp;

_output;