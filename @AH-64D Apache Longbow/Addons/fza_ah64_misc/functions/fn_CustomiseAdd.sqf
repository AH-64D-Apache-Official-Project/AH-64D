/* ----------------------------------------------------------------------------
Function: fza_misc_fnc_CustomiseAdd

Description:
	...

Parameters:
	...

Returns:
	...

Examples:
    ...

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_target","_player","_targetComp"];

if (_targetComp == "FCR") exitwith {
    [
        2,
        [_target, _player],
        {
			params ["_args"];
			_args params ["_target", "_player"];
            private _nearestObject = nearestObject [_player, "fza_ah64_FireControlRadar"];
            deleteVehicle _nearestObject;
            _target animateSource ["fcr_enable",1];
        },
        {},
        localize "STR_A3_MP_GroundSupport_ProgressBar_LoadingGroup",
        {
			params ["_args"];
			_args params ["_target", "_player"];
            _nearestObject = nearestObject [player, "fza_ah64_FireControlRadar"];
            if (_player distance _nearestObject > 10 ) exitWith {false};
            true;
        },
        ["isNotInside"]
    ] call ace_common_fnc_progressBar;
};
if (_targetComp == "IAFS") exitwith {
    [
        2,
        [_target, _player],
        {
			params ["_args"];
			_args params ["_target", "_player"];
            private _nearestObject = nearestObject [_player, "fza_ah64_IAFS"];
            _target Setvariable ["fza_ah64_IAFSInstalled", true];
            deleteVehicle _nearestObject;
            _target animateSource ["IAFS", 1];
        },
        {},
        localize "STR_A3_MP_GroundSupport_ProgressBar_LoadingGroup",
        {
			params ["_args"];
			_args params ["_target", "_player"];
            private _nearestObject = nearestObject [_player, "fza_ah64_IAFS"];
            if (_player distance _nearestObject > 10 ) exitWith {false};
            true;
        },
        ["isNotInside"]
    ] call ace_common_fnc_progressBar;
};
if (_targetComp == "MAG") exitwith {
    [
        2,
        [_target, _player],
        {
			params ["_args"];
			_args params ["_target", "_player"];
            private _nearestObject = nearestObject [_player, "fza_ah64_1200Magazine"];
            if (_target animationSourcePhase "IAFS" == 1) exitwith {};
            deleteVehicle _nearestObject;
            _target animateSource ["magazine_set_1200", 1];
        },
        {},
        localize "STR_A3_MP_GroundSupport_ProgressBar_LoadingGroup",
        {
			params ["_args"];
			_args params ["_target", "_player"];
            private _nearestObject = nearestObject [_player, "fza_ah64_1200Magazine"];
            if (_player distance _nearestObject > 10 ) exitWith {false};
            true;
        },
        ["isNotInside"]
    ] call ace_common_fnc_progressBar;
};