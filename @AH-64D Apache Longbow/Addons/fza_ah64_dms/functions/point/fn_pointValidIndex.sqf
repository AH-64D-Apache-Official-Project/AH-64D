#include "\fza_ah64_dms\headers\constants.h"
params ["_pointType", "_index"];

switch _pointType do {
    case POINT_TYPE_WP;
    case POINT_TYPE_HZ;
    case POINT_TYPE_TG: {
        1 <= _index && _index <= 50;
    };
    case POINT_TYPE_CM: {
        51 <= _index && _index <= 99;
    };
    default {
        false;
    };
};