params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _variant      = _state get "subPageVarPage" select 1;
private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
private _rteIndex     = _heli getVariable "fza_ah64_routeCurPnt";
private _routeInfo    = _routeData # _routeCurrent;
private _directTo     = (_heli getVariable "fza_dms_routeNext")#0;
private _routeScroll  = _state get "routeScroll";
private _currentPoint = -1;
private _rvwIndex     = _heli getVariable "fza_mpd_tsdRteCurrentRvw";

private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
private _scrollV = [_routeScroll, 0, _upper] call BIS_fnc_clamp;
_state set ["routeScroll", _scrollV];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_VARIANT), _variant];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_TEXT_POINTS), -1];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_END_INDEX), (count _routeInfo - _routeScroll)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_POINTEDIT), BOOLTONUM(_variant == 0)];
if (_rvwIndex isEqualTo -1) then {_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_RVW_INDEX), -1];};

private _drawRtePoint = {
    params ["_heli", "_routeInfo", "_routeScroll", "_positionIndex"];
    private _index = _routeScroll + _positionIndex;
    if (count _routeInfo <= _index) exitwith {" ";};
    private _point = _routeInfo#_index;
    private _pointData = [_heli, _point, POINT_GET_ID] call fza_dms_fnc_pointGetValue;
    private _pointStr  = _pointData call fza_dms_fnc_pointToString;
    if (_rteIndex != _index) exitWith {_pointStr;};
    [_pointStr,_positionIndex];
};

([_heli, _routeInfo, _routeScroll, 0] call _drawRtePoint)
    params ["_pointStr", "_currentPoint"];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R5), _pointStr];

([_heli, _routeInfo, _routeScroll, 1] call _drawRtePoint)
    params ["_pointStr", "_currentPoint"];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R4), _pointStr];

([_heli, _routeInfo, _routeScroll, 2] call _drawRtePoint)
    params ["_pointStr", "_currentPoint"];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R3), _pointStr];

([_heli, _routeInfo, _routeScroll, 3] call _drawRtePoint)
    params ["_pointStr", "_currentPoint"];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_POINT_R2), _pointStr];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_POINT), _currentPoint];

switch (_variant) do {
    case 1;
    case 2: {
        private _curPoint = _heli getVariable "fza_mpd_tsdRteCurrentSel";
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_CURPNT),
            _curPoint call fza_dms_fnc_pointToString];
        if (_curPoint isequalto [] && _variant != 1) then {
            _state set ["subPageVarPage", TSD_RTE_ADD_NOPOINTSEL];
        };
        if (_curPoint isNotEqualTo [] && _variant != 2) then {
            _state set ["subPageVarPage", TSD_RTE_ADD_POINTSEL];
        };
    };
    case 3: {
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_CURPNT),
            _directTo call fza_dms_fnc_pointToString];
    };
    case 4;
    case 5: {
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_CURPNT),
            _directTo call fza_dms_fnc_pointToString];
        if (_directTo isequalto [] && _variant != 4) then {
            _state set ["subPageVarPage", TSD_RTE_DIR_NOPOINTSEL];
        };
        if (_directTo isNotEqualTo [] && _variant != 5) then {
            _state set ["subPageVarPage", TSD_RTE_DIR_POINTSEL];
        };
    };
    case 6: {
        if (_rvwIndex isEqualTo -1) exitwith {};
        private _pointDetails = [_heli, (_routeInfo#_rvwIndex), POINT_GET_FULL] call fza_dms_fnc_pointGetValue;
        private _currentPointStr = (_routeInfo#_rvwIndex) call fza_dms_fnc_pointToString;
        //Line 1
        private _dstToWpt_m  = (_pointDetails # POINT_GET_ARMA_POS) distance2D (getPos _heli);
        private _heliVel_mps = vectorMagnitude velocity _heli;
        private _timeToWpt   = "99:99:99";
        private _arriveAtWpt = "99:99:99";
        if (_heliVel_mps > 0.514) then { //>1kt (0.514m/s)
            private _timeToWpt_sec = _dstToWpt_m / _heliVel_mps;
            _timeToWpt   = [_timeToWpt_sec, "HH:MM:SS"] call BIS_fnc_secondsToString;
            _arriveAtWpt = [dayTime + (_timeToWpt_sec / 3600), "HH:MM:SS"] call BIS_fnc_timeToString;
        };
        private _wptDetails_1 = format["%1 %2 %3 ETE %4 ETA %5L", _currentPointStr, _pointDetails select POINT_GET_IDENT, [_pointDetails select POINT_GET_FREE_TEXT,3]  call fza_fnc_padString, _timeToWpt, _arriveAtWpt];
        //Line 2
        private _dstToWpt_km  = ((_pointDetails # POINT_GET_ARMA_POS) distance2D (getPos _heli)) * 0.001;
        private _wptDetails_2 = format["                              %1 KM", [_dstToWpt_km, 2, 1] call CBA_fnc_formatNumber];
        //Line 3
        private _dstToWpt_nm  = ((_pointDetails # POINT_GET_ARMA_POS) distance2D (getPos _heli)) * 0.000539957;
        private _wptDetails_3 = format["                              %1 NM",[_dstToWpt_nm,2,1] call CBA_fnc_formatNumber];

        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_RVW_DETAILS_1), _wptDetails_1];
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_RVW_DETAILS_2), _wptDetails_2];
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_RVW_DETAILS_3), _wptDetails_3];
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_RVW_INDEX), (_rvwIndex - _routeScroll)];
    };
};
