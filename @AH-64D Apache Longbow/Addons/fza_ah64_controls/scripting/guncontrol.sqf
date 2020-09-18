params ["_heli"];

_curAcq = [_heli] call fza_fnc_targetingGetAcquisitionSource;
_curAcq = _curAcq + 1;
if (_curAcq > 3) then {
    _curAcq = 0;
};

[_heli, _curAcq] call fza_fnc_targetingSetAcquisitionSource;