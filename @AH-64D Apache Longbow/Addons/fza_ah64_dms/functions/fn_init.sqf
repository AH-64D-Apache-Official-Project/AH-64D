#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];
private _newPointsArray = {
    params["_size"];
    private _ret = [];
    for "_i" from 1 to _size do {
        _ret pushBack -1;
    };
    _ret;
};

private _isLocal = if (typeName _heli == "OBJECT") then {local _heli} else {isServer};

if (!(_heli getVariable ["fza_dms_aircraftInitialised", false]) && _isLocal) then {
    _heli setVariable ["fza_dms_aircraftInitialised", true, true];

    _heli setVariable ["fza_dms_routeNext", [], true];

    _heli setVariable ["fza_dms_waypointsHazards", [POINT_COUNT_WP_HZ] call _newPointsArray, true];
    _heli setVariable ["fza_dms_controlMeasures", [POINT_COUNT_CM] call _newPointsArray, true];
    _heli setVariable ["fza_dms_targetsThreats", [POINT_COUNT_TG_TH] call _newPointsArray, true];
};