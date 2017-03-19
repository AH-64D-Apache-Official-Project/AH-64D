private ["_val","_char","_digth"];
_val = _this select 0;
_char = _this select 1;

_digth = round(floor(10*((_val * 0.001) - floor(_val * 0.001))));
_digformat = _char + (format ["%1",_digth]) + "_ca.paa";

_digformat;