_array = _this;
_ah64 = _this select 0;
_weapon = _this select 1;
_ammotype = _this select 4;
_missobj = _this select 6;
_mags = magazines _ah64;
_offset1 = [-2.4, 2.1, -2.5];
_offset2 = [-1.7, 2.1, -2.5];
_offset3 = [1.7, 2.1, -2.5];
_offset4 = [2.4, 2.1, -2.5];
_offset = _offset1;

if (typeOf _missobj == "fza_275_m151" || typeOf _missobj == "fza_275_m229" || typeOf _missobj == "fza_275_m255" || typeOf _missobj == "fza_275_m261" || typeOf _missobj == "fza_275_m257") then {
    if (local _missobj) then {
        _rocketpos = _ah64 worldToModelVisual(getpos _missobj);
        _pbvar2 = _ah64 call fza_ah64_getpb;
        _helipitch = _pbvar2 select 0;
        _helibank = _pbvar2 select 1;
        _pbvar = _missobj call fza_ah64_getpb;
        _dir = direction _missobj + ((_ah64 animationphase "pylon1") * 10) * (sin _helibank) + (random 0.3) + (random - 0.3);
        _angle = (_pbvar select 0) + ((_ah64 animationphase "pylon1") * 10) * (cos _helibank) + (random 0.2) + (random - 0.2);
        _pitch = (_pbvar select 1) + (random 0.2) + (random - 0.2);

        _vecdx = sin(_dir) * cos(_angle);
        _vecdy = cos(_dir) * cos(_angle);
        _vecdz = sin(_angle);

        _vecux = cos(_dir) * cos(_angle) * sin(_pitch);
        _vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
        _vecuz = cos(_angle) * cos(_pitch);

        _missobj setvelocity[0, 0, 0];

        _missobj setVectorDirAndUp[[_vecdx, _vecdy, _vecdz], [_vecux, _vecuy, _vecuz]];

        fza_ah64_salvofired = fza_ah64_salvofired + 1;
    };
    [_missobj] call fza_ah64_fx_rktmsl;
};