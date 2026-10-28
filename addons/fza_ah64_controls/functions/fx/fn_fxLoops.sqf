/* ----------------------------------------------------------------------------
Function: fza_fnc_fxLoops

Description:
    loops battery or apu audio, for as long as either is on

Parameters:

Returns:
    Nothing

Examples:
    [_heli] spawn fza_fnc_fxLoops;

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli"];

if (_heli getVariable ["fza_ah64_fxLoopsRunning", false]) exitWith {};
_heli setVariable ["fza_ah64_fxLoopsRunning", true];

private _apu       = objNull;
private _bat       = objNull;
private _timed_apu = 0;
private _timed_bat = 0;

//The press is read before HeliSim has switched anything on
private _waitEnd = cba_missiontime + 2;
waitUntil {
    sleep 0.1;
    cba_missiontime > _waitEnd || {_heli getVariable ["bmkhs_apuOn", false] || {_heli getVariable ["bmkhs_battBusOn", false]}}
};

while {
    alive _heli && {_heli getVariable ["bmkhs_apuOn", false] || {_heli getVariable ["bmkhs_battBusOn", false]}}
}
do {
    if (_heli getVariable ["bmkhs_apuOn", false]) then {
        if (isNull _apu) then {
            _apu = "Land_ClutterCutter_small_F" createVehicle position _heli;
            _apu attachTo[_heli, [0, 0, 0]];
            hideObjectGlobal _apu;
            //After the start sound, played on the press
            _timed_apu = ((_heli getVariable ["fza_ah64_apuPressTime", -1e6]) + 24) max cba_missiontime;
        };
        if (cba_missiontime > _timed_apu) then {
            _timed_apu = cba_missiontime + 60;
            [_apu, ["fza_ah64_apu_loop_3D", 100]] remoteExec["say3D"];
        };
    } else {
        deleteVehicle _apu;
    };

    if (_heli getVariable ["bmkhs_battBusOn", false]) then {
        if (isNull _bat) then {
            _bat = "Land_ClutterCutter_small_F" createVehicle[0, 0, 0];
            _bat attachTo[_heli, [0, 5, 0]];
            hideObjectGlobal _bat;
            _timed_bat = cba_missiontime;
        };
        if (cba_missiontime > _timed_bat) then {
            //Avionics.ogg is 31 s
            _timed_bat = cba_missiontime + 30;
            [_bat, ["fza_ah64_bat_loop_3D", 10]] remoteExec["say3D"];
        };
    } else {
        deleteVehicle _bat;
    };
    sleep 1;
};

deleteVehicle _apu;
deleteVehicle _bat;
_heli setVariable ["fza_ah64_fxLoopsRunning", false];
