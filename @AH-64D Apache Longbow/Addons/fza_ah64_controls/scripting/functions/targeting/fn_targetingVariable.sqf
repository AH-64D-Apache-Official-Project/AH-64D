/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingVariable

Description:
	Handles repetitive Heavy Variable management. Should be run in the Slowscheduler.

Parameters:
	_heli - The helicopter to act on

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_targetingVariable
	---

Author:
	Ollieollieolllie
---------------------------------------------------------------------------- */
params ["_heli"];
if (!(player in _heli)) exitwith {};
private _visibleTargets = [];

//TSD ATK LIST
if (([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "tsd") && (_heli getVariable "fza_ah64_tsdmode" == "atk") && !(cameraView == "GUNNER")) then {
	fza_ah64_tsddisptargs = fza_ah64_targetlist select {
		_theta = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _x select 0), (getposatl _x select 1)] call fza_fnc_relativeDirection;

		! (((_heli getVariable "fza_ah64_agmode" == 1 && getposatl _x select 2 > 10) || (_theta > 90 && _theta < 270) || (_heli getVariable "fza_ah64_agmode" == 0 && getposatl _x select 2 > 10) || (((_heli distance _x) * (_heli getVariable "fza_ah64_rangesetting")) > 1) || !(alive _x)) ||
		((((_heli distance _x) * (_heli getVariable "fza_ah64_rangesetting") > 0.2) && (_theta > 90 && _theta < 270)) || ((_heli distance _x) * (_heli getVariable "fza_ah64_rangesetting") > 1) || !(alive _x)))
	};
};

//FCR LIST
if (([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "fcr") && !(cameraView == "GUNNER")) then {
	fza_ah64_dispfcrlist = fza_ah64_fcrlist select {
		_thetafcr = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _x select 0), (getposatl _x select 1)] call fza_fnc_relativeDirection;

		switch (_heli getVariable "fza_ah64_agmode") do {
			case 0: {
				!((getposatl _x select 2 > 10) || ((_heli distance2D _x) > 8000) || (_thetafcr > 70 && _thetafcr < 290) || !(alive _x))

			};
			case 1: {
				(((_x isKindOf "plane") || (_x isKindOf "helicopter")) && ((_heli distance2D _x) < 8000) && (alive _x))
			};
			default {
				true
			};
		};
	};
};

//ASE LIST
if (([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "ase") && !(cameraView == "GUNNER")) then {
	fza_ah64_asethreatsdraw = fza_ah64_targetlist select {alive _x && _x call fza_fnc_targetIsADA};
};

//RWR AUDIO
fza_ah64_asethreats = vehicles select {alive _x && _x call fza_fnc_targetIsADA};

//remove dead vehicles
fza_ah64_targetlist = fza_ah64_targetlist - alldead;
fza_ah64_fcrlist = fza_ah64_fcrlist - alldead;


//ofset it by 1 second so it alternated between mpd variable and cscope// ran every 2 second delay by 1
//CSCOPE LIST
[] spawn {
	sleep 1;
};
if (_heli getVariable "fza_ah64_fcrcscope") then {
	fza_ah64_Cscopelist = fza_ah64_targetlist select {
		_thetafcr = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _x select 0), (getposatl _x select 1)] call fza_fnc_relativeDirection;

		switch (_heli getVariable "fza_ah64_agmode") do {
			case 0: {
				!((getposatl _x select 2 > 10) || (_thetafcr > 70 && _thetafcr < 290) || !(alive _x) || ((_heli distance2D _x) > 8000))
			};
			case 1: {
				(((_x isKindOf "plane") || (_x isKindOf "helicopter")) && ((_heli distance2D _x) < 8000) && (alive _x))
			};
			default {
				true
			};
		};
	};
};