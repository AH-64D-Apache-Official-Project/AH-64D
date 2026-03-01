#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params["_heli", "_mpdIndex", "_state", "_persistState"];

#define SCALE_METERS_FEET 3.28084

private _pageType = _state get "pageType";
private _pageNumber = _state get "pageNumber";
private _pageNumberMax = _state get "pageNumberMax";
private _pointselected = _state get "PointSelected";
private _pageNumberstr = str _pageNumber + "/" + str _pageNumberMax;
private _shotatdel = _state get "shotatdel";
private _pointsArray = [];

for "_i" from 2 to 19 do {
    _heli setUserMfdText[MFD_INDEX_OFFSET(_i), ""];
};

_heli setUserMfdtext  [MFD_INDEX_OFFSET(MFD_TEXT_COORD_PAGENUM), _pageNumberstr];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_POINT), _pointselected];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_SHOTDEL), _shotatdel];

switch (_pageType) do {
    case 1;
    case 2;
    case 5: {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), _pageType];
        _state set ["pageNumberMax", 9];
        private _posHeli = getPos _heli;
        private _type = 4;
        private _ident = "WP";
        private _offset = 0;
        private _min = 50;
        private _variable = _heli getvariable (switch (_pageType) do {
            case 1: {
                _type = 0;
                _ident = "WP";
                "fza_dms_waypointsHazards"
            };
            case 2: {
                _type = 2;
                _ident = "CM";
                _offset = 50;
                _min = 49;
                "fza_dms_controlMeasures"
            };
            case 5: {
                _type = 4;
                _ident = "TG";
                "fza_dms_targetsThreats"
            };
        });

        private _pageNumeber = (count _variable) / 6;

        for "_i" from 0 to 5 step 1 do {
            private _pointValue = (_i + (6 *_pageNumber)) - 6;
            private _pointInfo = _variable # (_pointValue min (50 min _min));
            private _mfdTextIndex = (_i * 3 + 3);

            if (_pointValue < 50) then {;
                if ((_i + 1) != _pointselected) then {
                    if (_pointInfo isnotEqualTo -1) then {
                        _pointInfo params ["_MPD_POSMODE_WORLD", "_armaPos", "_freeText", "_type","_id","_ident","_gridCoord","_latLong", "_altMSL"];
                        _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex), format["%1 %2 %3 W84 47 13S FU %4 %5 %6 FT", (_id call fza_dms_fnc_pointToString), _ident, [_freeText, 3] call fza_fnc_padString, (str(_armaPos # 0)) select [0,4], str((_armaPos # 1)) select [0,4], [(_altMSL * SCALE_METERS_FEET) toFixed 0, 5] call fza_fnc_padString]];
                    } else {
                    _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex), format["%1 %2 %3 W84 47 13S FU %4 %5 %6 FT", ([_type, (_pointValue + (1 + _offset))] call fza_dms_fnc_pointToString), _ident, "AAA", "XXXX", "XXXX", "XXXXX"]];
                };
                } else {
                    if (_pointInfo isnotEqualTo -1) then {
                        _pointInfo params ["_MPD_POSMODE_WORLD", "_armaPos", "_freeText", "_type","_id","_ident","_gridCoord","_latLong", "_altMSL"];
                        //Line 1
                        private _dstToWpt_m  = (_pointInfo # POINT_GET_ARMA_POS) distance2D _posHeli;
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
                        private _hdg          = (_heli getDir _armaPos) tofixed 0;
                        private _dstToWpt_km  = (_armaPos distance2D _posHeli) * 0.001;
                        private _line2 = format[" %1 W84 47 13S FU  %2 %3 %4° %5 KM   ",(_id call fza_dms_fnc_pointToString), (str(_armaPos # 0)) select [0,4], str((_armaPos # 1)) select [0,4], _hdg,[_dstToWpt_km, 2, 1] call CBA_fnc_formatNumber];
                        //line 3
                        private _dstToWpt_nm  = (_armaPos distance2D _posHeli) * 0.000539957;
                        private _line3 = format["   %1 %2 FT %3 NM ", _latLong, [[(_altMSL) * SCALE_METERS_FEET,0,0] call CBA_fnc_formatNumber, 5] call fza_fnc_padString, [_dstToWpt_nm,2,1] call CBA_fnc_formatNumber];

                        _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex - 1), _line1];
                        _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex),     _line2];
                        _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex + 1), _line3];
                    } else {
                        _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex - 1),  ([format["?01 %1 AAA ETE 00:00:00 ETA 00:00:00L", _ident], 39] call fza_fnc_padString)];
                        _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex),      ([([(format["%1 W84 47 13S FU  XXXX XXXX XXX° XX.X KM", ([_type, (_pointValue + (1 + _offset))] call fza_dms_fnc_pointToString)]), 45, true] call fza_fnc_padString), 46] call fza_fnc_padString)];
                        _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex + 1), (["NXX XX.XX WXXX XX.XX XXXXX FT XX.X NM", 39] call fza_fnc_padString)];
                    };
                };
            };//45
        };
    };
    case 3;
    case 4: {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), _pageType];
        _state set ["pageNumberMax", 9];
        private _variable = _heli getvariable switch (_pageType) do {
            case 1: {"fza_dms_lines"};
            case 2: {"fza_dms_area"};
        };
    };
    case 6: {
        _heli setUserMFDValue[MFD_INDEX_OFFSET(MFD_IND_COORD_PAGE_TYPE), 6];
        private _variable = _heli getVariable "fza_dms_shotAt";
        private _posHeli = getPos _heli;
        _state set ["pageNumberMax", ((abs ceil ( count((vehicle player getVariable "fza_dms_shotAt") select {_x isNotEqualto -1}) / 6)) max 1)];

        for "_i" from 0 to 5 step 1 do {
            private _pointValue = (_i + (6 *_pageNumber)) - 6;
            private _pointInfo = _variable # (_pointValue min 16);
            private _mfdTextIndex = (_i * 3 + 2);
            _pointInfo params ["_shotNum", "_ident", "_missileType", "_triggerTime", "_shotPos", "_ind", "_old", "_overwriteValue"];

            if (_pointInfo isnotEqualTo -1) then {
                _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex), [[format["%1     %2 %3L %4", ([(_pointValue + 1), 2] call CBA_fnc_formatNumber), [_missileType, 3, true] call fza_fnc_padString, _triggerTime, _ind], 28, true] call fza_fnc_padString, 29] call fza_fnc_padString];
                _heli setUserMfdText[MFD_INDEX_OFFSET(_mfdTextIndex + 1), [format["W84 47 13S FU %1 %2", ([(_shotPos#0)/10, 4] call CBA_fnc_formatNumber), ([(_shotPos#1)/10, 4] call CBA_fnc_formatNumber)], 28] call fza_fnc_padString];
            };
        
            //draw icon
            _pointsArray pushBack [MPD_POSMODE_SCREEN, [0.35,(0.20 + (0.1185 * _i)),0], "", POINT_TYPE_FCR, _i, _ident];
        };
    };
};
[_heli, _pointsArray, _mpdIndex, 5000, [0.5, 0.87]] call fza_mpd_fnc_drawIcons;