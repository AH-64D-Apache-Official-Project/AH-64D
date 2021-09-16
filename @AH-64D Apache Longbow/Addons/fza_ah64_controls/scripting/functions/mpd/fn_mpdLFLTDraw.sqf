params ["_heli"];
#include "\fza_ah64_controls\headers\selections.h"

private _2dvectTo3D = {[_this # 0, _this # 1, 0]};


//[_heli,  (getposasl _heli select 2) * 3.28084 / 10, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_BALT] call fza_fnc_drawNumberSelections;
[_heli,  (getposasl _heli select 2) * 3.28084, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_BALT] call fza_fnc_drawNumberSelections;
[_heli,  (getpos _heli select 2) * 3.28084, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_RALT] call fza_fnc_drawNumberSelections;


private _airSpeedKnots = vectorMagnitude (velocity _heli vectorDiff wind) * 1.94;
[_heli, _airSpeedKnots, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_SPD] call fza_fnc_drawNumberSelections;

private _groundSpeed = vectorMagnitude (velocity _heli call _2dvectTo3D);
private _groundSpeedKnots = _groundSpeed * 1.94;
[_heli, _groundSpeedKnots, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_GSPD] call fza_fnc_drawNumberSelections;

private _torque = ([_heli] call fza_fnc_sfmplusGetData select 0) * 100;
[_heli, _torque, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_TRQ] call fza_fnc_drawNumberSelections;

_waypoint = (_heli getVariable "fza_ah64_waypointdata") select (_heli getVariable "fza_ah64_curwpnum");

_waypointDistance = (_waypoint distance2D getpos _heli);
[_heli, _waypointDistance / 100, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_WR] call fza_fnc_drawNumberSelections;

[_heli, direction _heli, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_DIR] call fza_fnc_drawNumberSelections;



private _waypointDirection = [[_heli, (getposatl _heli # 0), (getposatl _heli # 1), (_waypoint # 0), (_waypoint # 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180;

_vvect = [_heli] call fza_fnc_velocityVector;
_vertvect = (_vvect select 0) + 0.5;
_horvect = (_vvect select 1) + 0.6;


private _waypointEta = call ([{60000}, {_waypointDistance / _groundSpeed}] select (_groundSpeedKnots >= 15));

if (_waypointEta > 36000) then { //10 hours
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_TTG);
} else {
	if (_waypointEta > 300) then { //5 min
		private _seconds = floor (_waypointEta % 60);
		private _minutes = floor (_waypointEta / 60 % 10);
		[_heli, _minutes * 100 + _seconds, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_TTG] call fza_fnc_drawNumberSelections;
	} else {
		private _minutes = floor (_waypointEta / 60 % 60);
		private _hours = floor (_waypointEta / 3600 % 10);
		[_heli, _hours * 100 + _minutes, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLT_TTG] call fza_fnc_drawNumberSelections;
	}
};

_turn = (fza_ah64_dps * -0.052083) + 0.5;

if (_turn > 0.75) then {
	_turn = 0.75;
};
if (_turn < 0.25) then {
	_turn = 0.25;
};

_slip = (fza_ah64_slip * 1.2) + 0.5;

if (_slip > 0.7) then {
	_slip = 0.7;
};
if (_slip < 0.3) then {
	_slip = 0.3;
};
//TODO: Make sure this is being constantly run by person who heli is local to
if (local _heli) then {
	_heli animateSource["mpd_pl_flt_wbear", (_waypointDirection * 0.00476) + 0.5];
	_heli animateSource["mpd_pl_flt_wp_h", (_waypointDirection * 0.00476) + 0.625];
	_heli animateSource["mpd_pl_flt_wp_v", _vertvect];
	_heli animateSource["mpd_pl_flt_vvi_v", _vertvect];
	_heli animateSource["mpd_pl_flt_vvi_h", _horvect];
	_heli animateSource["mpd_pl_flt_rdr", ((_heli animationphase "longbow") * 2) + 0.5];
	_heli animateSource["mpd_pl_flt_turn", _turn];
	_heli animateSource["mpd_pl_flt_slip", _slip];
};

_heli setobjecttexture [SEL_MPD_PL_FLT_HI, ["", "\fza_ah64_us\tex\mpd\hi.paa"] select (getpos _heli select 2 > 304.8)];
_heli setobjecttexture [SEL_MPD_PL_FLT_LO, ["", "\fza_ah64_us\tex\mpd\lo.paa"] select (getpos _heli select 2 < 6.1)];

_heli setobjecttexture [SEL_MPD_PL_FLT_N20C, ["\fza_ah64_us\tex\mpd\flt_ca.paa", ""] select (_heli animationphase "mpd_pr_flt_bank" < -0.6)];
_heli setobjecttexture [SEL_MPD_PL_FLT_P20C, ["\fza_ah64_us\tex\mpd\flt_ca.paa", ""] select (_heli animationphase "mpd_pr_flt_bank" > 0.6)];
if (speed _heli > 5) then {
	_heli setobjecttexture [SEL_MPD_PL_FLT_VVI, "\fza_ah64_us\tex\mpd\cue_ca.paa"];
	_heli setobjecttexture [SEL_MPD_PL_FLT_WP, "\fza_ah64_us\tex\mpd\wp_ca.paa"];
} else {
	_heli setobjecttexture [SEL_MPD_PL_FLT_VVI, ""];
	_heli setobjecttexture [SEL_MPD_PL_FLT_WP, ""];
}; 