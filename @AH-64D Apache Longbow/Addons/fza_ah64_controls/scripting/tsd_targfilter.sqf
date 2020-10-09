params ["_heli"];

_tsdSort = (_heli getVariable "fza_ah64_tsdsort") + 1;
if (_tsdSort == 12) then {
    _tsdSort = 0;
};
_heli setVariable ["fza_ah64_tsdsort", _tsdSort, true];