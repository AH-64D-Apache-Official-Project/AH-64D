#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

hintsilent format ["FCR Targets = %1", _heli getVariable "fza_ah64_fcrTargets"];

private _pointsArray = [];
// [_posMode, _pos, _tex, _color, _textMode, _text1, _text2]
{
    _x params ["_pos", "_type", "_speed", "_obj"];
// _obj == fza_ah64_mycurrenttarget
    private _distance_m       = _heli distance2d _pos;
    private _unitType         = ""; //adu, heli, tracked, unk, wheeled, flyer
    private _unitStatus       = ""; //loal, lobl, move
    private _unitSelAndWpnStatus = ""; //nts, ants

    //Unit type
    systemChat format ["Type: %1", _type];
    switch (_type) do {
        case FCR_TYPE_UNKNOWN: {
            _unitType = "unk";
        };
        case FCR_TYPE_WHEELED: {
            _unitType = "wheel";
        };
        case FCR_TYPE_HELICOPTER: {
            _unitType = "heli";
        };
        case FCR_TYPE_FLYER: {
            _unitType = "flyer";
        };
        case FCR_TYPE_TRACKED: {
            _unitType = "track";
        };
        case FCR_TYPE_ADU: {
            _unitType = "adu";
        };
    };
    systemChat format ["unitType: %1", _unitType];
    //Unit status
    if ((_speed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH) && (_distance_m >= FCR_LIMIT_MIN_RANGE && _distance_m <= FCR_LIMIT_MOVING_RANGE)) then {
        _unitStatus = "MOVE";
    } else {
        if (_distance_m >= FCR_LIMIT_MIN_RANGE && _distance_m <= FCR_LIMIT_STATIONARY_RANGE) then {
            _unitStatus = "LOBL";
        } else {
            _unitStatus = "LOAL";
        }
    };
    //Unit select status
    if (_obj == fza_ah64_myCurrentTarget) then {
        _unitSelAndWpnStatus = "_NTS";
        if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_NONE) then {
            _unitSelAndWpnStatus = "_NTS_NoMSL";
        };
    };  //Requires ANTS logic still

    private _tex = format ["\fza_ah64_mpd\tex\tsdIcons\%1%2%3.paa", _unitType, _unitStatus, _unitSelAndWpnStatus];

    _pointsArray pushBack [MPD_POSMODE_WORLD, _pos, _tex, MPD_ICON_COLOR_YELLOW, MPD_ICON_TYPE_A, "", ""];

} forEach (_heli getVariable "fza_ah64_fcrTargets");

[_heli, _pointsArray, _mpdIndex, (0.08125 * 1 / 1000)] call fza_mpd_fnc_drawIcons;
