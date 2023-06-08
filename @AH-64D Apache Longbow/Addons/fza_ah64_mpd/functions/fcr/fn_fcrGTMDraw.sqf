#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];


private _fcrState     = _heli getVariable "fza_ah64_fcrState";
private _fcrTargets   = _heli getVariable "fza_ah64_fcrTargets";
private _lastScanInfo = _heli getVariable "fza_ah64_fcrLastScan";

_fcrState params ["_fcrScanState", "_fcrScanStartTime"];
//FCR wiper
if (_fcrScanState != FCR_MODE_OFF) then {
    private _fcrScanDeltaTime = time - _fcrScanStartTime;
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      _fcrScanDeltaTime % 4];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
};

//Total target count
private _fcrTgtCount  = count _fcrTargets;
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str _fcrTgtCount];

//FCR page draw
private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _fcrTargets findIf {_x # 3 == _nts};
private _antsIndex = 0;
if (count _fcrTargets > 0) then {
    _antsIndex = (_ntsIndex + 1) mod (count _fcrTargets);
};

private _pointsArray = [];
{
    _x params ["_pos", "_type", "_speed", "_obj"];
    private _distance_m          = _heli distance2d _pos;
    private _unitType            = ""; //adu, heli, tracked, unk, wheeled, flyer
    private _unitStatus          = ""; //loal, lobl, move
    private _unitSelAndWpnStatus = []; //nts, ants
    //Unit type
    switch (_type) do {
        case FCR_TYPE_UNKNOWN: {
            _unitType = "UNK";
        };
        case FCR_TYPE_WHEELED: {
            _unitType = "WHEEL";
        };
        case FCR_TYPE_HELICOPTER: {
            _unitType = "HELI";
        };
        case FCR_TYPE_FLYER: {
            _unitType = "FLYER";
        };
        case FCR_TYPE_TRACKED: {
            _unitType = "TRACK";
        };
        case FCR_TYPE_ADU: {
            _unitType = "ADU";
        };
    };
    //Unit status
    if ( _unitType != "FLYER") then {
        if ((_speed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH) && (_distance_m >= FCR_LIMIT_MIN_RANGE && _distance_m <= FCR_LIMIT_MOVING_RANGE)) then {
            _unitStatus = "MOVE";
        } else {
            if (_distance_m >= FCR_LIMIT_MIN_RANGE && _distance_m <= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) then {
                _unitStatus = "LOBL";
            };
            if (_distance_m > FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE && _distance_m <= FCR_LIMIT_STATIONARY_RANGE) then {
                _unitStatus = "LOAL";
            };
            if (_distance_m > FCR_LIMIT_STATIONARY_RANGE) then {
                continue;
            };
        };
    };
    //Unit select status
    if (_forEachIndex == _ntsIndex) then {
        if (_wasState == WAS_WEAPON_NONE) then {
            _unitSelAndWpnStatus = ["NTS", "NOMSL"];
        } else {
            _unitSelAndWpnStatus = ["NTS"];
        };
    };
    if (_forEachIndex == _antsIndex) then {
        _unitSelAndWpnStatus = ["ANTS"];
    };
    private _ident = (["FCR",_unitType,_unitStatus] + _unitSelAndWpnStatus) joinString "_";
    _pointsArray pushBack [MPD_POSMODE_WORLD, _pos, "", POINT_TYPE_FCR, _forEachIndex, _ident];
} forEach _fcrTargets;

POINTSARRAY = _pointsArray;

[_heli, _mpdIndex, MFD_IND_FCR_ACQ_BOX, MFD_TEXT_IND_FCR_ACQ_SRC] call fza_mpd_fnc_acqDraw;

[_heli, _pointsArray, _mpdIndex,  (0.08125 * 8 / 8000), [0.5, 0.87], _lastScanInfo # 0, _lastScanInfo #1] call fza_mpd_fnc_drawIcons;