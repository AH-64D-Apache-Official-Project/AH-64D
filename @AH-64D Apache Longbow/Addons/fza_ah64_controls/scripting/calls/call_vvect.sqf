private["_heli"];
_heli = _this select 0;

if (!(player in _heli)) exitwith {};

_vertvect = ((velocity _heli select 2) atan2 sqrt(((velocity _heli select 0) * (velocity _heli select 0)) + ((velocity _heli select 1) * (velocity _heli select 1))));
_helipb = _heli call fza_ah64_getpb;

_vertvect = (_vertvect - (_helipb select 0));
_horveldir = (velocity _heli select 0) atan2(velocity _heli select 1);
if (_horveldir < 0) then {
    _horveldir = _horveldir + 360;
};
_theta = (360 + (_horveldir - (direction _heli))) Mod 360;
_targhead = _theta;
if (_theta >= 180) then {
    _targhead = _theta - 360;
} else {
    _targhead = _theta;
};
_horvect = _targhead * 0.00555 + 0.625;

_vertvect1 = (sin(_helipb select 1)) * _targhead;
_vertvect2 = (cos(_helipb select 1)) * _vertvect;
_vertvect = (_vertvect1 + _vertvect2) * 0.00555;

_horvect1 = (cos(_helipb select 1)) * _targhead;
_horvect2 = (sin(_helipb select 1)) * _vertvect;
_horvect = (_horvect1 + _horvect2) * 0.00555;

[_vertvect, _horvect];