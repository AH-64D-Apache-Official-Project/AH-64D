params ["_heli", "_mpdIndex"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\bmkhs_helisim\functions\core\core.hpp"
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
private _torque = (_heli getVariable "bmkhs_engPctTq" select 0) max (_heli getVariable "bmkhs_engPctTq" select 1);
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_TORQUE), ( _torque * 100) toFixed 0];

//Altitude and speed
//HeliSim publishes speeds in m/s
private _groundSpeed = ((_heli getVariable "bmkhs_gndSpeed") * MPS_TO_KNOTS) toFixed 0;
private _airspeed    = _heli getVariable "bmkhs_vel2D";
//HeliSim publishes exact altitudes - barometric in feet, radar in METRES. The altimeters'
//steps and range are ours: baro in 10 ft, 0-20000; radar in 10 ft above 50 ft, to 1420.
private _barAlt = ((round ((_heli getVariable ["bmkhs_barAlt", 0.0]) / 10) * 10) max 0) min 20000;
private _radAlt = (_heli getVariable ["bmkhs_radAlt", 0.0]) * METERS_TO_FEET;
if (_radAlt > 50) then { _radAlt = round (_radAlt / 10) * 10 };
_radAlt = (_radAlt max 0) min 1420;
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_BALT),  _barAlt toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_GALT), [_radAlt toFixed 0, ""] select (_radAlt >= 1419.5)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_AIRSPEED), (_airspeed * MPS_TO_KNOTS) toFixed 0];


// Waypoint status window
private _currentDir = (_heli getVariable "fza_dms_routeNext")#0;
private _nextPoint = _currentDir;
private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
private _nextPointMSL = ([_heli, _nextPoint, POINT_GET_ALT_MSL] call fza_dms_fnc_pointGetValue) * METERS_TO_FEET;
[_heli, true] call fza_mpd_fnc_tsdWaypointStatusText params ["_waypointId", "_groundspeed", "_waypointDist", "_waypointEta"];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_DISTANCETOGO), _waypointDist];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_DESTINATION), _waypointId];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_TIMETOGO),  _waypointEta];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_GROUNDSPEED), _groundSpeed];
if (isNil "_nextPointPos") then {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_COMMAND_HEADING), -360];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLY_TO_CUE_X), -100];
} else {
    private _waypointDirection = [(_heli getRelDir _nextPointPos)] call CBA_fnc_simplifyAngle180;
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_COMMAND_HEADING), _waypointDirection];

    // Navigation fly to cue
    private _pitch = (_heli call BIS_fnc_getPitchBank) # 0;
    private _flyToCueX = _waypointDirection;
    private _flyToCueY = (_nextPointMSL - getPosASL _heli#2) atan2 (_nextPointPos distance2D getPos _heli) - (_pitch/6);

    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLY_TO_CUE_X), _flyToCueX];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLY_TO_CUE_Y), _flyToCueY];
};

private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
private _alternatesensorpan = (if (player == gunner _heli) then {deg(_heli animationPhase "pnvs")} else {_tadsAzimuth});
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_ALTERNATE_SENSOR), _alternatesensorpan];

_heli getVariable "fza_ah64_fcrLastScan" params ["_dir"];
private _fcrHeading = [(_dir - direction _heli) mod 360] call CBA_fnc_simplifyAngle180;
if (_heli animationPhase "fcr_enable" != 1) then {
    _fcrHeading = -1000;
};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FCR_CENTERLINE), _fcrHeading];

// Velocity Vector
// Lateral drift comes from the SHARED sideslip calc (bmkhs_aero_beta_deg,
// + = velocity to the RIGHT of the nose), so the HMD and MPD read one consistent
// source. Vertical (flight-path angle) from world vertical velocity as before.
private _velocity  = _heli getVariable "bmkhs_velWorldSpace";
private _velocityX = _heli getVariable ["bmkhs_aero_beta_deg", 0.0];
private _velocityY = (_velocity # 2) atan2 ([0,0,0] distance2D _velocity);

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLIGHT_PATH_X), _velocityX];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLIGHT_PATH_Y), _velocityY];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_VERT_SPEED),    _velocity#2];

// Turn and slip indicator
private _bank = (_heli call BIS_fnc_getPitchBank) # 1;
private _bankForStandardTurn = (_airspeed * MPS_TO_KNOTS) / 10 + 7;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_TURN), _bank / _bankForStandardTurn];

private _airspeedModelRelative = _heli vectorWorldToModel (_velocity);

private _beta_deg = fza_ah64_sideslip;

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FLT_SLIP), _beta_deg];

[_heli, _mpdIndex, MFD_IND_FLT_ACQ_BOX, MFD_TEXT_IND_FLT_ACQ_SRC] call fza_mpd_fnc_acqDraw;
