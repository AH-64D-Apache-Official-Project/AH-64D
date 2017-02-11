comment "script by general barron";

private ["_obj","_pitch","_bank","_yaw","_vdir","_vup","_sign", "_rotate"];

_obj = _this;

_yaw = getdir _obj;


_rotate =
{
private ["_v","_d","_x","_y"];


_v = +(_this select 0);
_d = _this select 1;

_x = _v select 0;
_y = _v select 1;

_v set [0, (cos _d)*_x - (sin _d)*_y];
_v set [1, (sin _d)*_x + (cos _d)*_y];


_v
};


_vdir = vectordir _obj;

_vdir = [_vdir, _yaw] call _rotate;

if ((_vdir select 1) != 0) then
{
_pitch = atan ((_vdir select 2) / (_vdir select 1));
}
else
{
if ((_vdir select 2) >= 0) then {_pitch = 90} else {_pitch = -90};
};

_vup = vectorup _obj;


_vup = [_vup, _yaw] call _rotate;

_vup = [_vup select 0] + ([[_vup select 1, _vup select 2], 360-_pitch] call _rotate);

if ((_vup select 2) != 0) then
{
_bank = atan ((_vup select 0) / (_vup select 2));
}
else
{
if ((_vdir select 2) >= 0) then {_bank = 90} else {_bank = -90};
};

if((_vup select 2) < 0) then
{
_sign = [1,-1] select (_bank < 0);
_bank = _bank - _sign*180;
};

[_pitch, _bank];