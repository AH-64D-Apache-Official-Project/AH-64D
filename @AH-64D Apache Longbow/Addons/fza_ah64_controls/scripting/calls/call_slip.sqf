private ["_heli"];
_heli = _this select 0;

if(!(player in _heli)) exitwith {};

_helipb = _heli call fza_ah64_getpb;
_pitch = _helipb select 0;
_bank = _helipb select 1;

_dps = (fza_ah64_dps - direction _heli)*11;

fza_ah64_slip = ((_dps * cos (abs _bank)) * sin (abs _pitch))*0.11;

fza_ah64_dps = direction _heli;