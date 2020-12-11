_heli = _this select 0;
_missobj = _this select 6;
_burstdist = 500;
_Tgpos = screentoworld[0.5, 0.5];

waituntil{(_missobj distance _Tgpos < _burstdist && _missobj distance _heli > 400)};


if (typeOf _missobj == "fza_275_m255" || typeOf _missobj == "fza_275_m261") then {
    triggerAmmo _missobj;
};