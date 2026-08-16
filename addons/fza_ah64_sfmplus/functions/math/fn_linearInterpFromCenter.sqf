params ["_inMin", "_inMax", "_input", "_outMin", "_outMid", "_outMax"];

if (_input < 0) then {
    linearConversion[_inMin, 0, _input, _outMin, _outMid, true];
} else {
    linearConversion[0, _inMax, _input, _outMid, _outMax, true];
};
