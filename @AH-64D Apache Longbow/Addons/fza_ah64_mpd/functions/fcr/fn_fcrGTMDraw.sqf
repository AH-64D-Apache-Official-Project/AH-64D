#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

private _fcrState     = _heli getVariable "fza_ah64_fcrState";
private _lastScanInfo = _heli getVariable "fza_ah64_fcrLastScan";
private _SystemWas    = _heli getVariable "fza_ah64_was";

_fcrState params ["_fcrScanState", "_fcrScanStartTime"];
//FCR wiper
if (_fcrScanState != FCR_MODE_OFF) then {
    private _fcrScanDeltaTime = time - _fcrScanStartTime;
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      _fcrScanDeltaTime % 3.2];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
} else {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
};

//fcr post proccess display
private _displayTargets = [_heli, (0.08125 * 8 / 8000), [0.5, 0.87]] call fza_fcr_fnc_PostProccess;

//Total target count
private _fcrTgtCount  = count _displayTargets;
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str _fcrTgtCount];

//FCR page draw
private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _displayTargets findIf {_x # 3 == _nts};
private _antsIndex = -1;
if (count _displayTargets > 0 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (count _displayTargets min 16);
};

private _pointsArray = [];
{
    _x params ["_pos", "_type", "_moving", "_obj","","","","_uiCtr"];
    private _distance_m          = _lastScanInfo #1 distance2d _pos;
    private _unitType            = ""; //adu, heli, tracked, unk, wheeled, flyer
    private _unitStatus          = ""; //loal, lobl, move
    private _unitSelAndWpnStatus = []; //nts, ants

    //FCR max show
    if (count _pointsArray > 15) exitwith {};
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
    if ((_moving && (_distance_m >= FCR_LIMIT_MIN_RANGE && _distance_m <= FCR_LIMIT_MOVING_RANGE)) || _unitType == "FLYER") then {
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
    //Unit select status
    if (_forEachIndex == _ntsIndex) then {
        if (_SystemWas == WAS_WEAPON_NONE) then {
            _unitSelAndWpnStatus = ["NTS", "NOMSL"];
        } else {
            _unitSelAndWpnStatus = ["NTS"];
        };
    };
    if (_forEachIndex == _antsIndex) then {
        _unitSelAndWpnStatus = ["ANTS"];
    };
    if (_unitType == "" || _unitStatus == "") exitwith {};
    private _ident = (["FCR",_unitType,_unitStatus] + _unitSelAndWpnStatus) joinString "_";
    _pointsArray pushBack [MPD_POSMODE_SCREEN, _uiCtr, "", POINT_TYPE_FCR, _forEachIndex, _ident];
} forEach _displayTargets;

POINTSARRAY = _pointsArray;

[_heli, _mpdIndex, MFD_IND_FCR_ACQ_BOX, MFD_TEXT_IND_FCR_ACQ_SRC] call fza_mpd_fnc_acqDraw;

[_heli, _pointsArray, _mpdIndex,  (0.08125 * 8 / 8000), [0.5, 0.87], _lastScanInfo#0, _lastScanInfo #1] call fza_mpd_fnc_drawIcons;