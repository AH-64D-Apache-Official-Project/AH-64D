params ["_heli", "_mpdIndex"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#define SCALE_METERS_FEET 3.28084
#define SCALE_MPS_KNOTS 1.94
private _2dvectTo3D = {[_this # 0, _this # 1, 0]};

_padLeft = {
    params ["_str", "_len"];
    private _add = [];
    _add resize (_len - count _str);
    _add = _add apply {"0"};
    _add pushBack _str;
    _add joinString "";
};

/// Torque
private _torque = (_heli getVariable "fza_sfmplus_engPctTQ" select 0) max (_heli getVariable "fza_sfmplus_engPctTQ" select 1);
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_TORQUE), ( _torque * 100) toFixed 0];

//Altitude and speed

private _groundSpeed = vectorMagnitude (velocity _heli call _2dvectTo3D);
private _groundSpeedKnots = _groundSpeed * SCALE_MPS_KNOTS;
private _airspeed = vectorMagnitude (velocity _heli vectorDiff wind);
([_heli] call fza_sfmplus_fnc_getAltitude)
    params ["_barAlt", "_radAlt"];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_BALT),  _barAlt toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_GALT), [_radAlt toFixed 0, ""] select (_radAlt > 1428)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_AIRSPEED), (_airspeed * SCALE_MPS_KNOTS) toFixed 0];

// Waypoint status window
private _nextPoint = _currentDir;
private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
private _nextPointMSL = [_heli, _nextPoint, POINT_GET_ALT_MSL] call fza_dms_fnc_pointGetValue;
[_heli, true] call fza_mpd_fnc_tsdWaypointStatusText params ["_waypointId", "_groundspeed", "_waypointDist", "_waypointEta"];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_DISTANCETOGO), _waypointDist];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_DESTINATION), _waypointId];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_TIMETOGO),  _waypointEta];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_GROUNDSPEED), _groundSpeed];
if (isNil "_nextPointPos") then {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_COMMAND_HEADING), -360];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLY_TO_CUE_X), -100];
} else {
    private _waypointDirection = [(_heli getRelDir _nextPointPos)] call CBA_fnc_simplifyAngle180;
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_COMMAND_HEADING), _waypointDirection];

    // Navigation fly to cue
    private _pitch = (_heli call BIS_fnc_getPitchBank) # 0;
    private _flyToCueX = _waypointDirection;
    private _flyToCueY = (_nextPointMSL - getPosAsl _heli#2) atan2 (_nextPointPos distance2D getpos _heli) - (_pitch/6);
    
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLY_TO_CUE_X), _flyToCueX];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLY_TO_CUE_Y), _flyToCueY];
};

private _alternatesensorpan = (if (player == gunner _heli) then {(_heli animationPhase "pnvs")*120} else {-deg (_heli animationSourcePhase "tads_tur")});
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_ALTERNATE_SENSOR), _alternatesensorpan];

_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_pos", "_time","_lDir"]; 
private _fcrHeading = [(_dir - direction _heli) mod 360] call CBA_fnc_simplifyAngle180;
if !(_heli animationPhase "fcr_enable" == 1) then {
    _fcrHeading = -1000;
};
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FCR_CENTERLINE), _fcrHeading];

// Velocity Vector
private _velocityX = [[_heli, 0, 0, velocity _heli # 0, velocity _heli # 1] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180;
private _velocityY = (velocity _heli # 2) atan2 ([0,0,0] distance2D velocity _heli);

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLIGHT_PATH_X), _velocityX];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLIGHT_PATH_Y), _velocityY];

// Turn and slip indicator
private _bank = (_heli call BIS_fnc_getPitchBank) # 1;
private _bankForStandardTurn = (_airspeed * 1.944) / 10 + 7;
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_TURN), _bank / _bankForStandardTurn];

private _airspeedModelRelative = _heli vectorWorldToModel (velocity _heli);

private _beta_deg = fza_ah64_sideslip;

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_SLIP), _beta_deg];

[_heli, _mpdIndex, MFD_IND_FLT_ACQ_BOX, MFD_TEXT_IND_FLT_ACQ_SRC] call fza_mpd_fnc_acqDraw;
