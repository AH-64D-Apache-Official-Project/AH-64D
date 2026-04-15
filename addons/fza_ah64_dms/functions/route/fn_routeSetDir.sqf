params["_heli", "_point", ["_manual", false]];

if (_manual) exitWith {
    _heli setVariable ["fza_dms_routeNext", [_point, getPos _heli], true];
};
_heli setVariable ["fza_dms_routeNext", [_point, [0,0,0]], true];
