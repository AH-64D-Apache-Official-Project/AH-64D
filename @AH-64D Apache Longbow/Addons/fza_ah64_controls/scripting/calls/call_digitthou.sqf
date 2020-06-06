private["_val", "_char", "_digtth"];
_val = _this select 0;
_char = _this select 1;

_digtth = round(floor(_val * 0.001));
_digformat = _char + (format["%1", _digtth]) + "_ca.paa";

_digformat;