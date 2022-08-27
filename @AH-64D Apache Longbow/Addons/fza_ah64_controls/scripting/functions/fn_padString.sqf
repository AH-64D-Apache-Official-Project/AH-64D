
params ["_str", "_len", ["_right", false]];
private _add = [];
_add resize (_len - count _str);
_add = _add apply {" "};

if (_right) exitWith {
    _str + _add joinString ""
};
_add pushBack _str;
_add joinString "";