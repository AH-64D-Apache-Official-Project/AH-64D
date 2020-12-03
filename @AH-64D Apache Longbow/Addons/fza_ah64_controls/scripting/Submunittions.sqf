_heli = _this select 0;
_missobj = _this select 6;
_burstdist = 500;

if(player in _heli && !(isNull fza_ah64_mycurrenttarget)) then {_burstdist = (fza_ah64_mycurrenttarget distance _heli) - 300};

waituntil{(_missobj distance _heli > _burstdist)};

if (typeOf _missobj == "fza_275_m255" || typeOf _missobj == "fza_275_m261") then {
    triggerAmmo _missobj;
};