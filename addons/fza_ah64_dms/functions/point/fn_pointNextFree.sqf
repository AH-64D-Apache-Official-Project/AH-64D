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
    case POINT_TYPE_SHOT: {
        _varName = "fza_dms_shotAt";
        _offset = 1;
    };
};

// Not the target file's special points after its stored ones (POINT_COUNT_TG_TH_ALL)
private _points = _heli getVariable _varName;
if (_type == POINT_TYPE_TG) then {_points = _points select [0, POINT_COUNT_TG_TH]};
private _index = _points findIf {_x isEqualTo -1};
if (_index == -1) exitWith {[]};
[_type, _index + _offset];
