//Sound controllers are local to each machine, so every client drives its own
if (!hasInterface) exitWith {};

fza_audio_soundHelis = [];

fza_audio_ngRef = getNumber (configFile >> "CfgVehicles" >> "fza_ah64base" >> "BMKHS_HeliSim" >> "Engines" >> "Engine01" >> "Compressor" >> "ngLimitMax");
if (fza_audio_ngRef <= 0) then {fza_audio_ngRef = 1};

fza_audio_soundFrameHandler = addMissionEventHandler ["EachFrame", {
    if (isGamePaused) exitWith {};

    private _lost = false;
    {
        if (alive _x) then {
            [_x, diag_deltaTime] call fza_audio_fnc_soundControllerUpdate;
        } else {
            _lost = true;
            if (!isNull _x) then {
                setCustomSoundController [_x, "CustomSoundController1", 0];
                setCustomSoundController [_x, "CustomSoundController2", 0];
            };
        };
    } forEach fza_audio_soundHelis;

    if (_lost) then {
        fza_audio_soundHelis = fza_audio_soundHelis select {alive _x};
    };
}];
