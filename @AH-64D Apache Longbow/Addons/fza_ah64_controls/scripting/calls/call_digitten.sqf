private ["_val","_char","_digtt"];
_val = _this select 0;
_char = _this select 1;

_digtt = round(10*(((floor(_val * 0.1)) * 0.1) - floor((floor(_val * 0.1)) * 0.1)));
_digformat = _char + (format ["%1",_digtt]) + "_ca.paa";

_digformat;