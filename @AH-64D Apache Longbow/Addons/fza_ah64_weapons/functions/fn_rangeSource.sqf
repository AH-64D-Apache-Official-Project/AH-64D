private _targDistance = _heli distance _targPos;
if (_targPos isequalto [0,0,0] && _sight == SIGHT_TADS) then {
    _targDistance = 1000;
    _targPos = _worldTargetpos;
};