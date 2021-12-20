#include "\fza_ah64_dms\headers\constants.h"
if (_this isEqualTo []) exitWith {"?01"};

params ["_type", "_num"];

private _typeStr = "W";
switch (_type) do {
    case POINT_TYPE_HZ: {
        _typeStr = "H";
    };
    case POINT_TYPE_CM: {
        _typeStr = "C";
    };
    case POINT_TYPE_TG: {
        _typeStr = "T";
    };
};

_typeStr + ([_num, 2] call CBA_fnc_formatNumber)