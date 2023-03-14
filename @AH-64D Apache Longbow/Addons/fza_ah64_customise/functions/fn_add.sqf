/* ----------------------------------------------------------------------------
Function: fza_customise_fnc_add

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
        300,
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
        300,
        [_target, _player],
        {
            params ["_args"];
            _args params ["_target", "_player"];
            //delete IAFS
            private _nearestObject = nearestObject [_player, "fza_ah64_IAFS"];
            deleteVehicle _nearestObject;
            _target animateSource ["magazine_set_1200", 0];
            [_target, 0] remoteExec ["fza_fnc_weaponSwapM230Mag", _target];
            //Spawn 1200rnd Mag
            private _object = "fza_ah64_1200Magazine" createVehicle [0,0,0];
            [_player, _object] call ace_dragging_fnc_carryObject;
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
        300,
        [_target, _player],
        {
            params ["_args"];
            _args params ["_target", "_player"];
            //delete 1200rnd Mag
            private _nearestObject = nearestObject [_player, "fza_ah64_1200Magazine"];
            deleteVehicle _nearestObject;
            _target animateSource ["magazine_set_1200", 1];
            [_target, 1] remoteExec ["fza_fnc_weaponSwapM230Mag", _target];
            //spawn IAFS
            private _object = "fza_ah64_IAFS" createVehicle [0,0,0];
            [_player, _object] call ace_dragging_fnc_carryObject;
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