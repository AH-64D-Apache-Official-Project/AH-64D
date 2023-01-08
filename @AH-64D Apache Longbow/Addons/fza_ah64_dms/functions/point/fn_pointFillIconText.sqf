#include "\fza_ah64_dms\headers\constants.h"
params ["_point", "_text"];
if (_text isEqualTo MPD_ICON_TEXT_FREE) exitWith {
    _point # POINT_GET_FREE_TEXT;
};
if (_text isEqualTo MPD_ICON_TEXT_ID) exitWith {
    [_point # POINT_GET_ID # 1, 2, 0] call CBA_fnc_formatNumber;
};
_text;