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
private _torque = ([_heli] call fza_fnc_sfmplusGetData select 0) * 100;
//Altitude and speed

private _groundSpeed = vectorMagnitude (velocity _heli call _2dvectTo3D);
private _groundSpeedKnots = _groundSpeed * SCALE_MPS_KNOTS;
private _airspeed = vectorMagnitude (velocity _heli vectorDiff wind);
private _baroAlt  = getPosASL _heli # 2 * SCALE_METERS_FEET;
private _radarAlt = getPos _heli # 2 * SCALE_METERS_FEET;
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_BALT), (round (_baroAlt / 10) * 10) toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_GALT), [_radarAlt toFixed 0, ""] select (_radarAlt > 1428)];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_AIRSPEED), (_airspeed * SCALE_MPS_KNOTS) toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_GROUNDSPEED), _groundSpeedKnots toFixed 0];

// Waypoint status window
private _waypointIndex = _heli getVariable "fza_dms_routeNext";
private _waypoint = [_heli, _waypointIndex, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
private _waypointMSL = [_heli, _waypointIndex, POINT_GET_ALT_MSL] call fza_dms_fnc_pointGetValue;
if (isNil "_waypoint") then {
	_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_COMMAND_HEADING), -360];
	_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_DESTINATION), "?01"];
	_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_DISTANCETOGO), ""];
	_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLY_TO_CUE_X), -100];
	_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_SHOW_WAYPOINT_BOX), 0];
	_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_TIMETOGO),  ""];
}
else {
	_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_SHOW_WAYPOINT_BOX), 1];
	private _waypointDistance = (_waypoint distance2D getpos _heli);
	_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_DESTINATION),  _waypointIndex call fza_dms_fnc_pointToString];
	_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_DISTANCETOGO),  format["%1km", (_waypointDistance/1000) toFixed 1]];

	private _waypointDirection = [[_heli, (getposatl _heli # 0), (getposatl _heli # 1), (_waypoint # 0), (_waypoint # 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180;
	_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_COMMAND_HEADING), _waypointDirection];

	private _waypointEta = call ([{60000}, {_waypointDistance / _groundSpeed}] select (_groundSpeedKnots >= 15));

	if (_waypointEta > 36000) then { //10 hours
		_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_TIMETOGO),  ""];
	} else {
		if (_waypointEta < 300) then { //5 min
			private _seconds = floor (_waypointEta % 60);
			private _minutes = floor (_waypointEta / 60 % 10);
			_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_TIMETOGO), format["%1:%2", _minutes, [str _seconds, 2] call _padLeft]];
		} else {
			private _minutes = floor (_waypointEta / 60 % 60);
			private _hours = floor (_waypointEta / 3600 % 10);
			_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FLT_TIMETOGO), format["%1:%2", _hours, [str _minutes, 2] call _padLeft]];
		};
	};

	// Navigation fly to cue
	private _flyToCueX = _waypointDirection;
	private _flyToCueY = (_waypointMsl - getPosAsl _heli # 2) atan2 (_waypoint distance2D getpos _heli);

	_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLY_TO_CUE_X), _flyToCueX];
	_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_FLY_TO_CUE_Y), _flyToCueY];
};


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

//This is good when < 24 kts
private _slipHvrFlt = _bank;
//This is good when > 24 kts
private _slipFwdFlt = _airspeedModelRelative # 0 atan2 _airspeedModelRelative # 1;
private _slip = linearConversion [0, 24, _groundSpeedKnots, _slipHvrFlt, _slipFwdFlt, true];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FLT_SLIP), _slip];