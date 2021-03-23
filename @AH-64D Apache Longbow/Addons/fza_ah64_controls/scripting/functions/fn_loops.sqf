/* ----------------------------------------------------------------------------
Function: fza_fnc_loops

Description:
    loops battery or apu audio

Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_loops;

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli"];

private _apu = "Land_ClutterCutter_small_F"
createVehicle position _heli;
private _bat = "Land_ClutterCutter_small_F"
createVehicle[0, 0, 0];
private _timed_apu = time + 24;
private _timed_bat = time + 0;

if (_heli animationphase "plt_apu" == 1) then {
    _apu attachTo[_heli, [0, 0, 0]];
    hideObjectGlobal _apu;
    
    while {
        _heli animationphase "plt_apu" == 1
    }
    do {
        if (time > _timed_apu) then {
            _timed_apu = time + 60;
            [_apu, ["fza_ah64_apu_loop_3D", 100]] remoteExec["say3d"];
        };
    };