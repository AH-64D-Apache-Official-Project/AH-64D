private["_val", "_char", "_digit"];
_val = _this select 0;
_char = _this select 1;

_digit = round(10 * ((_val * 0.1) - floor(_val * 0.1)));
if (_digit > 9) then {
    _digit = 9;
};
_digformat = _char + (format["%1", _digit]) + "_ca.paa";

_digformat;