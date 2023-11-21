params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

private _variant      = _state get "subPageVarPage" select 1;
private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
private _rteIndex     = _heli getVariable "fza_ah64_routeCurPnt";
private _routeInfo    = _routeData # _routeCurrent;
private _directTo     = _heli getVariable "fza_dms_routeNext";
private _routeScroll  = _state get "routeScroll";
private _currentPoint = -1;

private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
private _scrollV = [_routeScroll, 0, _upper] call BIS_fnc_clamp;
_state set ["routeScroll", _scrollV];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_VARIANT), _variant];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_TEXT_POINTS), -1];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_END_INDEX), (count _routeInfo - _routeScroll)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_POINTEDIT), BOOLTONUM(_variant == 0)];

if (count _routeInfo > 3) then {
    private _index = _routeScroll + 3;
    private _point = _routeInfo#_index;
    private _pointData = [_heli, _point, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _pointStr  = _pointData call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R2), str _pointStr];
    if (_rteIndex == _index) then {
        _currentPoint = 3;
    };
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R2), ""];
};
if (count _routeInfo > 2) then {
    private _index = _routeScroll + 2;
    private _point = _routeInfo#_index;
    private _pointData = [_heli, _point, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _pointStr  = _pointData call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R3), str _pointStr];
    if (_rteIndex == _index) then {
        _currentPoint = 2;
    };
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R3), ""];
};
if (count _routeInfo > 1) then {
    private _index = _routeScroll + 1;
    private _point = _routeInfo#_index;
    private _pointData = [_heli, _point, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _pointStr  = _pointData call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R4), str _pointStr];
    if (_rteIndex == _index) then {
        _currentPoint = 1;
    };
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R4), ""];
};
if (count _routeInfo > 0) then {
    private _index = _routeScroll;
    private _point = _routeInfo#_index;
    private _pointData = [_heli, _point, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _pointStr  = _pointData call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R5), str _pointStr];
    if (_rteIndex == _index) then {
        _currentPoint = 0;
    };
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R5), ""];
};

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_POINT), _currentPoint];

switch (_variant) do {
    case 1;
    case 2: {
        private _curPoint = _heli getVariable "fza_mpd_tsdRteCurrentSel";
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_CURPNT),
            _curPoint call fza_dms_fnc_pointToString];
    };
    case 3;
    case 4: {
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_CURPNT),
            _directTo call fza_dms_fnc_pointToString];
    };
};