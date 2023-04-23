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
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      _fcrScanDeltaTime % 2];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
};

//Total target count
private _fcrTgtCount  = count _fcrTargets;
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str _fcrTgtCount];

//Sight Select Status
private _sight        = [_heli] call fza_fnc_targetingGetSightSelect;
private _sightSelStat = "HMD";
switch (_sight) do {
    case 0: {
        _sightSelStat = "FCR ";
    };
    case 1: {
        _sightSelStat = "HMD ";
    };
    case 2: {
        _sightSelStat = "TADS";
    };
    case 3: {
        _sightSelStat = "FXD ";
    };
};
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_SSS), _sightSelStat];

//Range and Range Source
private _nts     = _heli getVariable "fza_ah64_fcrNts";
private _nts     = _nts # 0;
private _rngSrce = format["R%1", ((_heli distance _nts) / 1000) toFixed 1];
if (isNull _nts) then {
    if (driver _heli isEqualTo player) then {
        _rngSrce = "1.5";
    } else { _rngSrce = "3.0"};
};
if (!isNull laserTarget _heli) then {
    _rngSrce = format["*%1", round(_heli distance laserTarget _heli)];
};
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_RRS), _rngSrce];

//Sight Status
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_SS), ""];

//Weapon Control
private _wasState = _heli getVariable "fza_ah64_was";
private _mslTraj  = _heli getVariable "fza_ah64_hellfireTrajectory";
private _wpnCtrl  = "";
private _wpnStat  = "";
switch (_wasState) do {
    case WAS_WEAPON_NONE: {
        _wpnCtrl = "";
    };
    case WAS_WEAPON_GUN: {
        if (isManualFire _heli) then {
            _wpnCtrl = "";
            _wpnStat = format["ROUNDS %1", _heli ammo "fza_m230"];
        } else {
            _wpnCtrl = "CGUN";
        };
    };
    case WAS_WEAPON_MSL: {
        if (isManualFire _heli) then {
            _wpnCtrl = "";
            switch (_mslTraj) do {
                case "DIR": {
                    _wpnStat = "DIR MAN";
                };
                case "LO": {
                    _wpnStat = "LO MAN";
                };
                case "HI": {
                    _wpnStat = "HI MAN";
                };
            };
        } else {
            _wpnCtrl = "CMSL";
        };
    };
    case WAS_WEAPON_RKT: {
        if (isManualFire _heli) then {
            _wpnCtrl = "";
            private _rktAmmo = getText (configFile >> "CfgWeapons" >> (_heli getVariable "fza_ah64_selectedRocket") >> "fza_ammoType");
            private _rktCode = getText (configFile >> "CfgAmmo" >> _rktAmmo >> "fza_shortCode");
            _wpnStat              = format["%1 NORM %2", _rktCode, _heli ammo(_heli getVariable "fza_ah64_selectedRocket")];            
        } else {
            _wpnCtrl = "CRKT";
        };
    };
};
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_WC), _wpnCtrl];

//Acquisition Source
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_ACQ), "T01"];

//Weapon Status
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_WS), _wpnStat];

//FCR page draw
private _nts  = _heli getVariable "fza_ah64_fcrNts";
private _nts  = _nts # 0;
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
    if ((_speed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH) && (_distance_m >= FCR_LIMIT_MIN_RANGE && _distance_m <= FCR_LIMIT_MOVING_RANGE)) then {
        _unitStatus = "MOVE";
    } else {
        If (_unitType == "FLYER") then {
            _unitType = "UNK";
        };
        if (_distance_m >= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE && _distance_m <= FCR_LIMIT_STATIONARY_RANGE) then {
            _unitStatus = "LOAL";
        } else {
            _unitStatus = "LOBL";
        }
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
} forEach (_heli getVariable "fza_ah64_fcrTargets");

POINTSARRAY = _pointsArray;

[_heli, _pointsArray, _mpdIndex,  (0.08125 * 8 / 8000), [0.5, 0.87], _lastScanInfo # 0, _lastScanInfo #1] call fza_mpd_fnc_drawIcons;
