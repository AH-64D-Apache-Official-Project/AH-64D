params["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_ase\headers\ase.h"

private _phase          = BOOLTONUM(_persistState get "mode" == "atk");
private _rangesetting   = _persistState get "tsdScale";

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_PHASE), _phase];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SUBPAGE), _state get "subPageVarPage" select 0];

//Show options
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SCALE_BOXES), _rangesetting];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_HSI),  BOOLTONUM(_heli getVariable "fza_mpd_tsdShowHsi" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WIND), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowWind" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_ENDR), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowEndr" select _phase)];

// Wind Data
_heli call fza_sfmplus_fnc_getWindDirVel
    params ["_windDir", "_windVel"]; //067°/15
private _wind_text = format["%1° /%2", [_windDir, 3] call CBA_fnc_formatNumber, [_windVel, 2] call CBA_fnc_formatNumber];
if (_windvel < 5) then {_wind_text = "  CALM  ";};

//ASE footprint
private _rlwrPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_rlwrPwr" == ASE_RLWR_STATE_OFF);
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
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_ENDR), _totalEnduranceNumber];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WIND), _wind_text];
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
private _fcrTargets     = _heli getVariable "fza_ah64_fcrTargets";
private _lastScanInfo = _heli getVariable "fza_ah64_fcrLastScan";
private _SystemWas      = _heli getVariable "fza_ah64_was";
private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _fcrTargets findIf {_x # 3 == _nts};
private _antsIndex = 0;
if (count _fcrTargets > 0) then {
    _antsIndex = (_ntsIndex + 1) mod (count _fcrTargets);
};
{
    _x params ["_pos", "_type", "_moving", "_obj"];
    private _distance_m          = _lastScanInfo #1 distance2d _pos;
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
    _pointsArray pushBack [MPD_POSMODE_WORLD, _pos, "", POINT_TYPE_FCR, _forEachIndex, _ident];
} forEach _fcrTargets;

//ASE Points
private _ctrX       = 0.5;  
private _ctrY       = 0.75 - 0.25 * (_persistState get "ctr");
private _aseObjects = _heli getVariable "fza_ah64_ase_objects";
private _showRLWR = _heli getVariable "fza_mpd_tsdShowRlwr" select _phase;
{
    if !_showRLWR exitWith {};
    _x params ["_state", "_object","_iconClass"];
    private _bearing = _heli getRelDir _object;
    if (([] call fza_mpd_fnc_iconBlink) && _state >= ASE_LNC) then {continue;};
    ([_ctrX, _ctrY, 0.23, 0.77, 0.23, 0.77, _bearing] call fza_mpd_fnc_bearingToScreen)
        params ["_screenX", "_screenY"];
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_screenX, _screenY, 0.0], "", POINT_TYPE_ASE, _forEachIndex, _iconClass];
} forEach _aseObjects;

[_heli, _mpdIndex, MFD_IND_TSD_ACQ_BOX, MFD_TEXT_IND_TSD_ACQ_SRC] call fza_mpd_fnc_acqDraw;

private _tsdScale = 0.125 * 5 / (_persistState get "tsdScale");

[_heli, _pointsArray, _mpdIndex, _tsdScale, [_ctrX, _ctrY]] call fza_mpd_fnc_drawIcons;