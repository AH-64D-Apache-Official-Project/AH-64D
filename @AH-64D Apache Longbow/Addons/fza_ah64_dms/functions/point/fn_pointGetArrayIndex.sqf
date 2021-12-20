#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_id"];

if (_id isEqualTo []) exitWith {-1};

_id params ["_type", "_index"];
if (_type == POINT_TYPE_WP || _type == POINT_TYPE_HZ) exitWith {
    private _arrIndex = _index - 1;

    if (_arrIndex < 0 || _arrIndex >= POINT_COUNT_WP_HZ) exitwith {-1};
    ["fza_dms_waypointsHazards", _arrIndex]
};

if (_type == POINT_TYPE_CM) exitWith {
    private _arrIndex = _index - 51;

    if (_arrIndex < 0 || _arrIndex >= POINT_COUNT_CM) exitwith {-1};
    ["fza_dms_controlMeasures", _arrIndex];
};

if (_type == POINT_TYPE_TG || _type == POINT_TYPE_TH) exitWith {
    private _arrIndex = _index - 1;

    if (_arrIndex < 0 || _arrIndex >= POINT_COUNT_TG_TH) exitwith {-1};
    ["fza_dms_controlMeasures", _arrIndex];
};

-1;

//Either -1 if invalid, or [_varName, _arrIndex]