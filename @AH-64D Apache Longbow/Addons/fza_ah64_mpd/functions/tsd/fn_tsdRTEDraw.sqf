params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

private _variant      = _state get "subPageVarPage" select 1;
private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
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

if (count _routeInfo > 3) then {
    private _point4 = _routeInfo# (_routeScroll + 3);
    private _point4Data = [_heli, _point4, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _point4Str  = _point4Data call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R2), str _point4Str];
    if (_point4 isEqualTo _directTo) then {
        _currentPoint = 3;
    };
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R2), ""];
};
if (count _routeInfo > 2) then {
    private _point3 = _routeInfo# (_routeScroll + 2);
    private _point3Data = [_heli, _point3, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _point3Str  = _point3Data call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R3), str _point3Str];
    if (_point3 isEqualTo _directTo) then {
        _currentPoint = 2;
    };
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R3), ""];
};
if (count _routeInfo > 1) then {
    private _point2 = _routeInfo # (_routeScroll + 1);
    private _point2Data = [_heli, _point2, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _point2Str  = _point2Data call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R4), str _point2Str];
    if (_point2 isEqualTo _directTo) then {
        _currentPoint = 1;
    };
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R4), ""];
};
if (count _routeInfo > 0) then {
    private _point1 = _routeInfo# _routeScroll;
    private _point1Data = [_heli, _point1, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _point1Str  = _point1Data call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R5), str _point1Str];
    if (_point1 isEqualTo _directTo) then {
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