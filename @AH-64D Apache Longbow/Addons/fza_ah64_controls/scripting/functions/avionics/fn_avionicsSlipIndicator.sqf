private["_heli"];
_heli = _this select 0;

if (!(player in _heli)) exitwith {};

_helipb = _heli call fza_fnc_getPitchBank;
_pitch = _helipb select 0;
_bank = _helipb select 1;

fza_ah64_dps = (fza_ah64_lastdir - direction _heli) * 11;

fza_ah64_slip = ((fza_ah64_dps * cos(abs _bank)) * sin(abs _pitch)) * 0.11;

fza_ah64_lastdir = direction _heli;