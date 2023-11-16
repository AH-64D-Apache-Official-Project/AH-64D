params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

private _variant      = _state get "subPageVarPage" select 1;
private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
private _routeInfo    = _routeData get _routeCurrent;

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_VARIANT), _variant];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_SELECTED), _routeCurrent];

if (count _routeInfo > 0) then {
    private _point1 = _routeInfo# (_state get "routeScroll");
    private _point1Data = [_heli, _point1, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _point1Str  = _point1Data call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R5), str _point1Str];
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R5), ""];
};
if (count _routeInfo > 1) then {
    private _point2 = _routeInfo # ((_state get "routeScroll") + 1);
    private _point2Data = [_heli, _point2, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _point2Str  = _point2Data call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R4), str _point2Str];
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R4), ""];
};
if (count _routeInfo > 2) then {
    private _point3 = _routeInfo# ((_state get "routeScroll") + 2);
    private _point3Data = [_heli, _point3, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _point3Str  = _point3Data call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R3), str _point3Str];
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R3), ""];
};
if (count _routeInfo > 3) then {
    private _point4 = _routeInfo# ((_state get "routeScroll") + 3);
    private _point4Data = [_heli, _point4, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _point4Str  = _point4Data call fza_dms_fnc_pointToString;
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R2), str _point4Str];
} else {
    _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R2), ""];
};

switch (_variant) do {
    case 1;
    case 2: {
        private _strPoint = (_state get "routePoint") call fza_dms_fnc_pointToString;
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_CURPNT), _strPoint];
    };
    case 3;
    case 4: {
        private _curPoint = _heli getVariable "fza_dms_routeNext";
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_CURPNT),
            _curPoint call fza_dms_fnc_pointToString];
    };
};