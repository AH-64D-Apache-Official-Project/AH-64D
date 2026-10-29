#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params["_heli", "_mpdIndex", "_state", "_persistState"];

// Point altitudes read like the aircraft's barometric altitude
private _altBase = [_heli] call fza_dms_fnc_pointAltitudeBase;

#define SCALE_METERS_FEET 3.28084

private _pageType = _state get "pageType";
private _pageNumber = _state get "pageNumber";
private _pageNumberMax = _state get "pageNumberMax";
private _pointselected = _state get "PointSelected";
private _shotatdel = _state get "shotatdel";
private _pointsArray = [];

for "_i" from 2 to 19 do {
    _heli setUserMFDText[MFD_INDEX_OFFSET(_i), ""];
};

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_POINT), _pointselected];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_SHOTDEL), _shotatdel];

switch (_pageType) do {
    case 1;
    case 2;
    case 5: {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), _pageType];
        private _posHeli = getPos _heli;
        private _variable = _heli getVariable (switch (_pageType) do {
            case 1: {"fza_dms_waypointsHazards"};
            case 2: {"fza_dms_controlMeasures"};
            case 5: {"fza_dms_targetsThreats"};
        });

        // Only the points stored in the database, six to a page; the page and the line selected are held within them
        // as points are added and deleted
        private _points = _variable select {_x isNotEqualTo -1};
        _pageNumberMax = (ceil (count _points / 6)) max 1;
        _state set ["pageNumberMax", _pageNumberMax];
        if (_pageNumber > _pageNumberMax) then {
            _pageNumber = _pageNumberMax;
            _state set ["pageNumber", _pageNumber];
        };
        private _pagePoints = _points select [(_pageNumber - 1) * 6, 6];
        // The point ids on the lines, for the point select buttons (fza_mpd_fnc_pageCOORDHandleControl)
        _state set ["pagePoints", _pagePoints apply {_x # POINT_GET_ID}];
        if (_pointselected > count _pagePoints) then {
            _pointselected = -1;
            _state set ["PointSelected", -1];
            _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_POINT), -1];
        };

        {
            private _i = _forEachIndex;
            private _pointInfo = _x;
            private _mfdTextIndex = (_i * 3 + 3);
            _pointInfo params ["_MPD_POSMODE_WORLD", "_armaPos", "_freeText", "_type","_id","_ident","_gridCoord","_latLong", "_altMSL"];

            if ((_i + 1) != _pointselected) then {
                _heli setUserMFDText[MFD_INDEX_OFFSET(_mfdTextIndex), format["%1 %2 %3 W84 47 13S FU %4 %5 %6 FT", (_id call fza_dms_fnc_pointToString), _ident, [_freeText, 3] call fza_fnc_padString, _gridCoord select [0,4], _gridCoord select [4,4], [(_altMSL * SCALE_METERS_FEET + _altBase) toFixed 0, 5] call fza_fnc_padString]];
            } else {
                //Line 1
                private _dstToWpt_m  = _armaPos distance2D _posHeli;
                private _heliVel_mps = vectorMagnitude velocity _heli;
                private _timeToWpt   = "99:99:99";
                private _arriveAtWpt = "99:99:99";
                if (_heliVel_mps > 0.514) then { //>1kt (0.514m/s)
                    private _timeToWpt_sec = _dstToWpt_m / _heliVel_mps;
                    _timeToWpt   = [_timeToWpt_sec, "HH:MM:SS"] call BIS_fnc_secondsToString;
                    _arriveAtWpt = [dayTime + (_timeToWpt_sec / 3600), "HH:MM:SS"] call BIS_fnc_timeToString;
                };
                private _line1 = format["    %1 %2 %3 ETE %4 ETA %5L  ",(_id call fza_dms_fnc_pointToString), _ident, [_freeText, 3] call fza_fnc_padString, _timeToWpt, _arriveAtWpt];
                //line 2
                private _hdg          = (_heli getDir _armaPos) toFixed 0;
                private _dstToWpt_km  = (_armaPos distance2D _posHeli) * 0.001;
                private _line2 = format[" %1 W84 47 13S FU  %2 %3 %4° %5 KM   ",(_id call fza_dms_fnc_pointToString), _gridCoord select [0,4], _gridCoord select [4,4], _hdg,[_dstToWpt_km, 2, 1] call CBA_fnc_formatNumber];
                //line 3
                private _dstToWpt_nm  = (_armaPos distance2D _posHeli) * 0.000539957;
                private _line3 = format["   %1 %2 FT %3 NM ", _latLong, [[(_altMSL) * SCALE_METERS_FEET + _altBase,0,0] call CBA_fnc_formatNumber, 5] call fza_fnc_padString, [_dstToWpt_nm,2,1] call CBA_fnc_formatNumber];

                _heli setUserMFDText[MFD_INDEX_OFFSET(_mfdTextIndex - 1), _line1];
                _heli setUserMFDText[MFD_INDEX_OFFSET(_mfdTextIndex),     _line2];
                _heli setUserMFDText[MFD_INDEX_OFFSET(_mfdTextIndex + 1), _line3];
            };
        } forEach _pagePoints;
    };
    case 3;
    case 4: {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), _pageType];
        _state set ["pageNumberMax", 9];
        private _varName = switch (_pageType) do {
            case 1: {"fza_dms_lines"};
            case 2: {"fza_dms_area"};
        };
        private _variable = _heli getVariable _varName;
    };
    case 6: {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), 6];
        private _variable = _heli getVariable "fza_dms_shotAt";
        private _posHeli = getPos _heli;
        _state set ["pageNumberMax", ((abs ceil ( count((_heli getVariable "fza_dms_shotAt") select {_x isNotEqualTo -1}) / 6)) max 1)];

        for "_i" from 0 to 5 step 1 do {
            private _pointValue = (_i + (6 *_pageNumber)) - 6;
            private _pointInfo = _variable # (_pointValue min 16);
            private _mfdTextIndex = (_i * 3 + 2);
            _pointInfo params ["_shotNum", "_ident", "_missileType", "_triggerTime", "_shotPos", "_ind", "_old", "_overwriteValue"];

            if (_pointInfo isNotEqualTo -1) then {
                private _shotGrid = [_shotPos] call fza_dms_fnc_posToGrid;
                _heli setUserMFDText[MFD_INDEX_OFFSET(_mfdTextIndex), [[format["%1     %2 %3L %4", ([(_pointValue + 1), 2] call CBA_fnc_formatNumber), [_missileType, 3, true] call fza_fnc_padString, _triggerTime, _ind], 28, true] call fza_fnc_padString, 29] call fza_fnc_padString];
                _heli setUserMFDText[MFD_INDEX_OFFSET(_mfdTextIndex + 1), [format["W84 47 13S FU %1 %2", _shotGrid select [0,4], _shotGrid select [4,4]], 28] call fza_fnc_padString];
                _pointsArray pushBack [MPD_POSMODE_SCREEN, [0.35,(0.20 + (0.1185 * _i)),0], "", POINT_TYPE_FCR, _i, _ident];
            };

        };
    };
};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_COORD_PAGENUM), format ["%1/%2", _state get "pageNumber", _state get "pageNumberMax"]];
[_heli, _pointsArray, _mpdIndex, 5000, [0.5, 0.87]] call fza_mpd_fnc_drawIcons;
