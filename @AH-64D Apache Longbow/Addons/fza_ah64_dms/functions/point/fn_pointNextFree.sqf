#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_type"];

private _varName = "";
private _offset = 0;
switch (_type) do {
    case POINT_TYPE_WP;
    case POINT_TYPE_HZ: {
        _varName = "fza_dms_waypointsHazards";
        _offset = 1;
    };
    case POINT_TYPE_CM: {
        _varName = "fza_dms_controlMeasures";
        _offset = 51;
    };
    case POINT_TYPE_TG: {
        _varName = "fza_dms_targetsThreats";
        _offset = 1;
    };
};

private _index = (_heli getVariable _varName) findIf {_x isEqualTo -1};
if (_index == -1) exitWith {[]};
[_type, _index + _offset];