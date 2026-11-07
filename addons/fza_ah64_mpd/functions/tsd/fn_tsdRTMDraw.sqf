// The route menu: five routes a page, each with its name and first six points
params ["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

private _page      = _state getOrDefault ["rtmPage", 0];
private _confirm   = _state getOrDefault ["rtmConfirm", -1];
private _routeData = _heli getVariable "fza_ah64_routeData";
private _names     = _heli getVariable ["fza_ah64_routeNames", ROUTE_NAME_DEFAULTS];
private _column    = (_heli getVariable "fza_ah64_routeSelected") - 5 * _page;

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_VARIANT), 7];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTM_PAGE), _page];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTM_CURRENT), [-1, _column] select (_column >= 0 && _column < 5)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTM_DELETE), _state getOrDefault ["rtmDelete", 0]];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTM_CONFIRM), BOOLTONUM(_confirm >= 0)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTM_PAGE), format ["%1/2", _page + 1]];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTM_CONFIRM), if (_confirm >= 0) then {_names param [_confirm, ""]} else {""}];

// The point labels, rebuilt only when this page's routes change; a deep copy, as the routes are changed in place
private _routes = _routeData select [5 * _page, 5];
private _cache  = _state getOrDefault ["rtmCache", [[], []]];
if (_routes isNotEqualTo (_cache # 0)) then {
    private _built = [];
    {
        for "_row" from 0 to 5 do {
            private _text = "";
            if (_row < count _x) then {
                private _id = [_heli, _x # _row, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
                if (!isNil "_id") then {_text = _id call fza_dms_fnc_pointToString};
            };
            _built pushBack _text;
        };
    } forEach _routes;
    _cache = [+_routes, _built];
    _state set ["rtmCache", _cache];
};
private _texts = _cache # 1;

{
    private _col = _forEachIndex;
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTM_NAME_1 + _col), _names param [5 * _page + _col, ""]];
    for "_row" from 0 to 5 do {
        _heli setUserMFDText [MFD_INDEX_OFFSET(_x + _row), _texts param [6 * _col + _row, ""]];
    };
} forEach MFD_TEXT_IND_TSD_RTM_COLS;
