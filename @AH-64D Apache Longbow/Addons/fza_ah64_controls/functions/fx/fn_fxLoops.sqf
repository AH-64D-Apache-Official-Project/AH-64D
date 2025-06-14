/* ----------------------------------------------------------------------------
Function: fza_fnc_fxLoops

Description:
    loops battery or apu audio

Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_fxLoops;

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli"];

private _timed_apu = cba_missiontime + 24;
private _timed_bat = cba_missiontime;

private _apuOn     = _heli getVariable "fza_systems_apuOn";
private _battBusOn = _heli getVariable "fza_systems_battBusOn";

if (_apuOn) then {
    private _apu = "Land_ClutterCutter_small_F" createVehicle position _heli;
    _apu attachTo[_heli, [0, 0, 0]];
    hideObjectGlobal _apu;
    
    while {
        _apuOn && alive _heli;
    }
    do {
        if (cba_missiontime > _timed_apu) then {
            _timed_apu = cba_missiontime + 60;
            [_apu, ["fza_ah64_apu_loop_3D", 100]] remoteExec["say3d"];
        };
        sleep 1;
    };
    deleteVehicle _apu;
};

if (_battBusOn) then {
    private _bat = "Land_ClutterCutter_small_F" createVehicle[0, 0, 0];
    _bat attachTo[_heli, [0, 5, 0]];
    hideObjectGlobal _bat;

    while {
        _battBusOn && alive _heli;
    }
    do {
        if (cba_missiontime > _timed_bat) then {
            _timed_bat = cba_missiontime + 13;
            [_bat, ["fza_ah64_bat_loop_3D", 10]] remoteExec["say3d"];
        };
        sleep 1;
    };
    deleteVehicle _bat;
};