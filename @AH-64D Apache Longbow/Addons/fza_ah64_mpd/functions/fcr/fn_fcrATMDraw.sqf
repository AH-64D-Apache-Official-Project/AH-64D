#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time"];
private _displayTargets = _heli getVariable "fza_ah64_fcrTargets";
private _SystemWas = _heli getVariable "fza_ah64_was";

//ATM Rear block
If (_fcrScanState == FCR_MODE_ON_SINGLE || _fcrScanState == FCR_MODE_ON_CONTINUOUS) then {
    if (_fcrScanStartTime + 3.2 >= time) then {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ATM_BLOCK), 0];
    };
};

//FCR wiper
if (_fcrScanState != FCR_MODE_OFF) then {
    private _fcrScanDeltaTime = time - _fcrScanStartTime;
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      _fcrScanDeltaTime % 6.4];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    if (_fcrScanDeltaTime >= 2.93) then {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ATM_BLOCK), 1];
    };
    if ((_fcrScanDeltaTime % 6.4) < 2.96 || (_fcrScanDeltaTime % 6.4) > 3.44 ) then {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
    } else {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
    };
} else {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
};

//FCR page draw
private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _displayTargets findIf {_x # 3 == _nts};
private _antsIndex = -1;
if (count _displayTargets > 0 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (count _displayTargets min 16);
};

private _pointsArray = [];
private _scale = (0.08125 * 8 / 8000);
private _heliCtr = [0.5, 0.87];
{
    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];
    private _distance_m          = _scanPos distance2d _pos;
    private _unitType            = "unk";
    private _unitStatus          = ""; //loal, lobl, move
    private _unitSelAndWpnStatus = []; //nts, ants

    //FCR max show
    if (count _pointsArray > 15) exitwith {};
    
    if ((_type != FCR_TYPE_FLYER && _type != FCR_TYPE_HELICOPTER)) then {continue;};

    //Unit type
    switch (_type) do {
        case FCR_TYPE_HELICOPTER: {
            _unitType = "HELI";
        };
        case FCR_TYPE_FLYER: {
            _unitType = "FLYER";
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
        if (_unitType == "FLYER") then {
        };
    };
    if (_forEachIndex == _antsIndex) then {
        _unitSelAndWpnStatus = ["ANTS"];
    };
    if (_unitType == "" || _unitStatus == "") then {continue;};
    private _ident = (["FCR",_unitType,_unitStatus] + _unitSelAndWpnStatus) joinString "_";
    
    private _x = _heliCtr#0 + sin _aziAngle * (_range * _scale);
    private _y = _heliCtr#1 - cos _aziAngle * (_range * _scale);
    private _uiCtr = [_x, _y, 0];

    _pointsArray pushBack [MPD_POSMODE_SCREEN, _uiCtr, "", POINT_TYPE_FCR, _forEachIndex, _ident];
} forEach _displayTargets;

//Total target count
private _fcrTgtCount  = count _displayTargets;
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str _fcrTgtCount];

[_heli, _mpdIndex, MFD_IND_FCR_ACQ_BOX, MFD_TEXT_IND_FCR_ACQ_SRC] call fza_mpd_fnc_acqDraw;

[_heli, _pointsArray, _mpdIndex,  _scale, _heliCtr, _dir, _scanPos] call fza_mpd_fnc_drawIcons;