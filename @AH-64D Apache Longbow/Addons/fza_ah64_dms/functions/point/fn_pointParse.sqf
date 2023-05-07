#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_string"];
private _ret = _string regexFind ["^([WCT])(\d{2})$"];
if (count _ret == 0) exitWith {[]};
private _match = _ret # 0;

private _type = POINT_TYPE_WP;
switch (_match # 1 # 0) do {
    case "C": {
        _type = POINT_TYPE_CM;
    };
    case "T": {
        _type = POINT_TYPE_TG;
    };
};
private _number = parseNumber (_match # 2 # 0);
if ([_heli, [_type, _number]] call fza_dms_fnc_pointGetArrayIndex isEqualTo -1) exitWith {[]};
[_type, _number];