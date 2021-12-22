#include "\fza_ah64_dms\headers\constants.h"
params ["_text", "_id", "_free"];
if (_text isEqualTo MPD_ICON_TEXT_FREE) exitWith {
    _free;
};
if (_text isEqualTo MPD_ICON_TEXT_ID) exitWith {
    [_id, 2, 0] call CBA_fnc_formatNumber;
};
_text;