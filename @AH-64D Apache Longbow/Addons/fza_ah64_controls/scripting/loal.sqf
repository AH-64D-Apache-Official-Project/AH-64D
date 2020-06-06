_missobj = _this select 0;
_angle = 0;
_minangle = 0;
_alt = getposasl _missobj select 2;

while {
    (alive _missobj)
}
do {
    _curalt = getposasl _missobj select 2;
    _x = (getposatl _missobj select 0) + (sin(direction _missobj)) * 500;
    _y = (getposatl _missobj select 1) + (cos(direction _missobj)) * 500;
    if (count(nearestObjects[[_x, _y, 0], ["Car", "Tank", "Ship", "LaserTarget"], 50]) > 0 || _curalt > _alt + 500) exitWith {
        _minangle = _angle
    };
    _pbvar = _missobj call fza_ah64_getpb;
    _dir = direction _missobj;
    _angle = _pbvar select 0;
    _angle = _angle + 2;
    if (_angle > 30) then {
        _angle = 30;
    };
    _pitch = (_pbvar select 1);

    _vecdx = sin(_dir) * cos(_angle);
    _vecdy = cos(_dir) * cos(_angle);
    _vecdz = sin(_angle);

    _vecux = cos(_dir) * cos(_angle) * sin(_pitch);
    _vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
    _vecuz = cos(_angle) * cos(_pitch);

    _missobj setVectorDirAndUp[[_vecdx, _vecdy, _vecdz], [_vecux, _vecuy, _vecuz]];
    sleep 0.001;
};

while {
    (alive _missobj)
}
do {
    if (_angle < (_minangle * -1)) exitWith {
        _missobj setvelocity[0, 0, 0];
    };
    _pbvar = _missobj call fza_ah64_getpb;
    _dir = direction _missobj;
    _angle = _pbvar select 0;
    _angle = _angle - 2;
    _pitch = (_pbvar select 1);

    _vecdx = sin(_dir) * cos(_angle);
    _vecdy = cos(_dir) * cos(_angle);
    _vecdz = sin(_angle);

    _vecux = cos(_dir) * cos(_angle) * sin(_pitch);
    _vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
    _vecuz = cos(_angle) * cos(_pitch);

    _missobj setVectorDirAndUp[[_vecdx, _vecdy, _vecdz], [_vecux, _vecuy, _vecuz]];
    sleep 0.001;
};