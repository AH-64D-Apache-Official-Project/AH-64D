#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params["_heli", "_mpdIndex", "_state", "_persistState"];

#define SCALE_METERS_FEET 3.28084

private _pageType = _state get "pageType";
private _pageNumber = _state get "pageNumber";
private _pageNumberMax = _state get "pageNumberMax";
private _pointselected = _state get "PointSelected";
private _pageNumberstr = str _pageNumber + "/" + str _pageNumberMax;

for "_i" from 2 to 19 do {
    _heli setUserMfdText[MFD_INDEX_OFFSET(_i), ""];
};

_heli setUserMfdtext  [MFD_INDEX_OFFSET(MFD_TEXT_COORD_PAGENUM), _pageNumberstr];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_POINT), _pointselected];

switch (_pageType) do {
    case "WPTHZ": {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), 1];

        //fza_dms_waypointsHazards

    };
    case "CTRLM": {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), 2];


        //fza_dms_controlMeasures
    };
    case "LINE": {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), 3];


        //fza_dms_Line
    };
    case "AREA": {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), 4];


        //fza_dms_Area
    };
    case "COORD": {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), 5];
        
        private _targetThreats = _heli getvariable "fza_dms_targetsThreats";
        private _pageNumeber = (count _targetThreats) / 6;

        for "_i" from 0 to 5 step 1 do {
            private _pointValue = (_i + (6 *_pageNumber)) - 6;
            private _pointInfo = _targetThreats # (_pointValue min 50);
            private _mfdTextIndex = (_i * 3 + 3);
            private _textString = format["%1 %2 %3 W84 47 13S FU %4 %5 %6 FT", ([4, (_pointValue + 1)] call fza_dms_fnc_pointToString), "TG", "AAA", "XXXX", "XXXX", "XXXXX"];

            if ((_i + 1) == _pointselected) then {
                if (_pointInfo isEqualTo -1) then {continue;};
                _pointInfo params ["_MPD_POSMODE_WORLD", "_armaPos", "_freeText", "_type","_id","_ident","_gridCoord","_latLong", "_altMSL"];
                _textString = format["%1 %2 %3 W84 47 13S FU %4 %5 %6 FT", (_id call fza_dms_fnc_pointToString), _ident, [_freeText, 3] call fza_fnc_padString, (str(_armaPos # 0)) select [0,4], str((_armaPos # 1)) select [0,4], [(_altMSL * SCALE_METERS_FEET) toFixed 0, 5] call fza_fnc_padString];
            } else {


            };


            if (_pointValue > 49) then {_textstring = ""};
            _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex), _textString];

            hintSILENT str format [" page type = %1,
                                    \n pagenum = %2
                                    \n pagenummax = %3
                                    \n pagenumstring = %4
                                    \n textstring = %5
                                    \n mfdtextindex = %6%",_pageType, _pageNumber, _pageNumberMax, _pageNumberstr, _textString, MFD_TEXT_IND_COORD_LINE ];

        };
    };
    case "SHOT": {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), 6];
        
        
        //fza_dms_shotAt
    };
};





/*
//MPD_TEXT_USER(MFD_TEXT_IND_COORD_Line_16))

if (isNil "_pointDetails") then {
    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_1), format["?01 %1 AAA ETE 00:00:00 ETA 00:00:00L", POINT_DEFAULTIDENT]];
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
    private _wptDetails_3 = format["%1  %2 FT %3 NM", _wptLatLong, [[(_pointDetails select POINT_GET_ALT_MSL) * SCALE_METERS_FEET,0,0] call CBA_fnc_formatNumber,4] call fza_fnc_padString, [_dstToWpt_nm,2,1] call CBA_fnc_formatNumber];

    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_1), _wptDetails_1];
    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_2), _wptDetails_2];
    _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_DETAILS_3), _wptDetails_3];
};