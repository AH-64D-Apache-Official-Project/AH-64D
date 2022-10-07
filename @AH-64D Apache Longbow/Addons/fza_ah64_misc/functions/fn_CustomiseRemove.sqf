/* ----------------------------------------------------------------------------
Function: fza_misc_fnc_Customiseremove

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
            _target animateSource ["fcr_enable", 0];
            private _object = "fza_ah64_FireControlRadar" createVehicle [0,0,0];
            [_player, _object] call ace_dragging_fnc_carryObject;
        },
        {},
        localize "STR_A3_MP_GroundSupport_ProgressBar_LoadingGroup",
        {
			params ["_args"];
			_args params ["_target", "_player"];
            if (_player distance _target > 10 ) exitWith {false};
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
            _target Setvariable ["fza_ah64_IAFSInstalled", false];
            private _object = "fza_ah64_IAFS" createVehicle [0,0,0];
            [_player, _object] call ace_dragging_fnc_carryObject;
        },
        {},
        localize "STR_A3_MP_GroundSupport_ProgressBar_LoadingGroup",
        {
			params ["_args"];
			_args params ["_target", "_player"];
            if (_player distance _target > 10 ) exitWith {false};
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
            _target animateSource ["magazine_set_1200", 1];
            private _object = "fza_ah64_1200Magazine" createVehicle [0,0,0];
            [_player, _object] call ace_dragging_fnc_carryObject;
            //remove IAFS
            _target Setvariable ["fza_ah64_IAFSInstalled", false];
        },
        {},
        localize "STR_A3_MP_GroundSupport_ProgressBar_LoadingGroup",
        {
			params ["_args"];
			_args params ["_target", "_player"];
            if (_player distance _target > 10 ) exitWith {false};
            true;
        },
        ["isNotInside"]
    ] call ace_common_fnc_progressBar;
};