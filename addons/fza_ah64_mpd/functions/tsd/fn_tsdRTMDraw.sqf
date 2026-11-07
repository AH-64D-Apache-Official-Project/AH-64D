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
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTM_CONFIRM), _names param [_confirm, ""]];

{
    private _route  = 5 * _page + _forEachIndex;
    private _points = _routeData param [_route, []];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTM_NAME_1 + _forEachIndex), _names param [_route, ""]];
    for "_row" from 0 to 5 do {
        private _text = "";
        if (_row < count _points) then {
            private _id = [_heli, _points # _row, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
            if (!isNil "_id") then {_text = _id call fza_dms_fnc_pointToString};
        };
        _heli setUserMFDText [MFD_INDEX_OFFSET(_x + _row), _text];
    };
} forEach MFD_TEXT_IND_TSD_RTM_COLS;
