params["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"

private _phase        = BOOLTONUM(_persistState get "mode" == "atk");
private _rangesetting = _persistState get "tsdScale";
private _tsdScale     = 0.125 * 5 / (_persistState get "tsdScale");
private _ctrX         = 0.5;  
private _ctrY         = 0.75 - 0.25 * (_persistState get "ctr");

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_PHASE), _phase];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SUBPAGE), _state get "subPageVarPage" select 0];

//Show options
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SCALE_BOXES), _rangesetting];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_HSI),  BOOLTONUM(_heli getVariable "fza_mpd_tsdShowHsi" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WIND), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowWind" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_ENDR), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowEndr" select _phase)];

/////////////////////////////////////////////////////////////////////////////////////////////
// Wind Data        /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
_heli call fza_sfmplus_fnc_getWindDirVel
    params ["_windDir", "_windVel"]; //067°/15
private _wind_text = format["%1° /%2", [_windDir, 3] call CBA_fnc_formatNumber, [_windVel, 2] call CBA_fnc_formatNumber];
if (_windvel < 5) then {_wind_text = "  CALM  ";};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WIND), _wind_text];

//ASE footprint
private _rlwrPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_rlwrPwr" == "off");
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ASE_FOOTPRINT), _rlwrPwr];

//TSD Centering
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_CTR), _persistState get "ctr"];

//TSD phase
if (_persistState get "mode" == "atk") then {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowAtkCurrRoute")];
} else {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowNavWptData")];
};
switch (_state get "subPageVarPage" select 0) do {
    case 0: { //Root
        [_heli, true] call fza_mpd_fnc_tsdWaypointStatusText params ["_waypointId", "_groundspeed", "_waypointDist", "_waypointEta"];
        
        [_heli] call fza_mpd_fnc_fuelGetData params [ "" 
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , "_totalEnduranceNumber"
                                                    ];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WPDEST), _waypointId];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WPDIST), _waypointDist];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WPETA),  _waypointEta];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_GROUNDSPEED), _groundSpeed];
        
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_ENDR), _totalEnduranceNumber]
    };
    case 1: {   //SHOW
        _this call fza_mpd_fnc_tsdShowDraw;
    };
    case 2: {   //WPT
        _this call fza_mpd_fnc_tsdWptDraw;
    };
    case 3: {   //RTE
        _this call fza_mpd_fnc_tsdRteDraw;
    };
    case 4: {   //THRT
        _this call fza_mpd_fnc_tsdThrtDraw;
    };
};

_this call fza_mpd_fnc_tsdScaleDraw;

private _pointsArray = [];
//TSD Points
private _pointsArray      = [];
private _showEnemy        = _heli getVariable "fza_mpd_tsdShowEnemy" select _phase;
private _showFriendly     = _heli getVariable "fza_mpd_tsdShowFriendly" select _phase;
private _showPlanTgts     = _heli getVariable "fza_mpd_tsdShowPlanTgts" select _phase;
private _showCtrlmeasures = _heli getVariable "fza_mpd_tsdShowCtrlMeasures" select _phase;
private _showAtkShot      = _heli getVariable "fza_mpd_tsdShowAtkShot";
private _showAtkHazzard   = _heli getVariable "fza_mpd_tsdShowAtkHazard";

{
    {
        _x params ["_MPD_POSMODE_WORLD", "_armaPos", "_freeText", "_type","_id","_ident","_gridCoord","_latLong"];
        if (_x isEqualTo -1) then {continue;};
        (_ident call fza_dms_fnc_pointGetIdentDetails)
            params ["_iconTex", "_iconTex2", "_iconSize", "_color", "_textA", "_textB"];
        //Ctrl Measures
        if (_type == POINT_TYPE_CM) then {
            if (!_showEnemy && _color isEqualTo [1.0, 0.0, 0.2, 1]) then {continue;};
            if (!_showFriendly && _color isEqualTo [0.4, 0.6, 1.0, 1]) then {continue;};
            if (!_showCtrlmeasures && _color isEqualTo [0.0, 1.0, 0.5, 1]) then {continue;};
        };
        //Hazards
        if (_type == POINT_TYPE_HZ && !_showAtkHazzard && _phase == 1) then {continue;};
        //PLANNED TGT/THRT
        if (_type == POINT_TYPE_TG && !_showPlanTgts) then {continue;};
        
        _pointsArray pushBack (_x select [0,7]);
    } forEach (_heli getVariable _x);
} forEach (["fza_dms_waypointsHazards", "fza_dms_controlMeasures", "fza_dms_targetsThreats"]);

//FCR Points
_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time"];
private _displayTargets = _heli getVariable "fza_ah64_fcrTargets";
private _SystemWas = _heli getVariable "fza_ah64_was";

{
    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];
    private _distance_m          = _scanPos distance2d _pos;
    private _unitType            = ""; //adu, heli, tracked, unk, wheeled, flyer
    private _unitStatus          = ""; //loal, lobl, move
    private _unitSelAndWpnStatus = []; //nts, ants
    private _ident               = "";
    
    if (_rangesetting < 25000) then {
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
        if (_unitType == "" || _unitStatus == "") exitwith {continue;};
        _ident = (["FCR",_unitType,_unitStatus] + _unitSelAndWpnStatus) joinString "_";
    } else {
        _ident= "FCR_TSD_SC25_50";
    };

    private _x = _ctrX + sin _aziAngle * (_range * _tsdScale);
    private _y = _ctrY - cos _aziAngle * (_range * _tsdScale);
    private _uiCtr = [_x, _y, 0];

    _pointsArray pushBack [MPD_POSMODE_SCREEN, _uiCtr, "", POINT_TYPE_FCR, _forEachIndex, _ident];
} forEach _displayTargets;

private _fcrState = _heli getVariable "fza_ah64_fcrState";
Private _fcrMode = _heli Getvariable "fza_ah64_fcrMode";
private _sight = [_heli] call fza_fnc_targetingGetSightSelect;
private _tsdFcrState = 0;
if (_sight == SIGHT_FCR) then {
    _tsdFcrState = _fcrMode;
};
if (_fcrState#0 == FCR_MODE_ON_SINGLE) then {
    _tsdFcrState = (_fcrMode + 2);
};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_FCR), _tsdFcrState];

//ASE Points
private _aseObjects = _heli getVariable "fza_ah64_ase_rlwrObjects";
private _rlwrPower = _heli getVariable "fza_mpd_tsdShowRlwr" select _phase;
{
    _x params ["_state", "_object", "_classification"];
    private _bearing = _heli getRelDir _object;
    if !_rlwrPower exitWith {};
    _ident = [_state, _classification] call fza_ase_fnc_rlwrGetIdent;
    if (([] call fza_mpd_fnc_iconBlink) && _state >= ASE_LNC) then {continue;};
    if (_ident == "") then {continue;};
    ([_ctrX, _ctrY, 0.23, 0.77, 0.23, 0.77, _bearing] call fza_mpd_fnc_bearingToScreen)
        params ["_screenX", "_screenY"];
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_screenX, _screenY, 0.0], "", POINT_TYPE_ASE, _forEachIndex, _ident];
} forEach _aseObjects;

[_heli, _mpdIndex, MFD_IND_TSD_ACQ_BOX, MFD_TEXT_IND_TSD_ACQ_SRC] call fza_mpd_fnc_acqDraw;


[_heli, _pointsArray, _mpdIndex, _tsdScale, [_ctrX, _ctrY]] call fza_mpd_fnc_drawIcons;