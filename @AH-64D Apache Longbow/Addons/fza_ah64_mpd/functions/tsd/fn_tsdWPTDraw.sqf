params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

#ifdef POINTMODE_THREAT
#define POINT_CURRENTSEL "fza_mpd_tsdThrtCurrentSel"

#else //Wpt
#define POINT_CURRENTSEL "fza_mpd_tsdWptCurrentSel"
#endif

private _currentPoint    = _heli getVariable POINT_CURRENTSEL;
private _currentPointStr = _currentPoint call fza_dms_fnc_pointToString;

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_WPT_VARIANT), _state get "subPageVarPage" select 1];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_CURRENT_POINT), _currentPointStr];

private _pointDetails = [_heli, _currentPoint, POINT_GET_FULL] call fza_dms_fnc_pointGetValue;

if (isNil "_pointDetails") then {
    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_1), "?01 WP AAA ETE 00:00:00 ETA 00:00:00L"];
    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_2), "W84 47 13S FU  XXXX XXXX XXX* XX.X KM"];
    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_3), "NXX XX.XX WXXX XX.XX  XXXX FT XX.X NM"];
} else {
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
    private _hdg          = _heli getDir (_pointDetails select POINT_GET_ARMA_POS);
    private _dstToWpt_km  = ((_pointDetails # POINT_GET_ARMA_POS) distance2D (getPos _heli)) * 0.001;
    private _wptDetails_2 = format["W84 47 13S FU  %1 %2 %3* %4 KM", _pointDetails select POINT_GET_GRID_COORD select [0,4], _pointDetails select POINT_GET_GRID_COORD select [4,4],  [_hdg, 3, 0] call CBA_fnc_formatNumber, [_dstToWpt_km, 2, 1] call CBA_fnc_formatNumber];
    //Line 3
    private _wptLatLong   = _pointDetails select POINT_GET_LAT_LONG;
    private _dstToWpt_nm  = ((_pointDetails # POINT_GET_ARMA_POS) distance2D (getPos _heli)) * 0.000539957;
    private _wptDetails_3 = format["%1  %2 FT %3 NM", _wptLatLong, [[_pointDetails select POINT_GET_ALT_MSL,0,0] call CBA_fnc_formatNumber,4] call fza_fnc_padString, [_dstToWpt_nm,2,1] call CBA_fnc_formatNumber];

    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_1), _wptDetails_1];
    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_2), _wptDetails_2];
    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_3), _wptDetails_3];
};

private _variant = _state get "subPageVarPage" select 1;
switch (_variant) do {
    case 1: {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_WPT_ADD_TYPE), _state get "addType"];
    };
};
