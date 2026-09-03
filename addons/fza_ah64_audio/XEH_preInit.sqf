//- Sound Controller Handlers
["fza_audio_updateArrayVariable", fza_audio_fnc_updateEngineSoundController] call CBA_fnc_addEventHandler;

//- Play APU Sound
// #LINK - fn_interactAPUButton.sqf
["fza_audio_updateAPU_State", {
    params ["_heli", "_state"];
    [_heli,"apu",_state] spawn fza_fnc_fxLoops;
}] call CBA_fnc_addEventHandler;

//- Play Battery Sound
// #LINK - fn_interactBattSwitch.sqf
["fza_audio_updateBatt_State", {
    params ["_heli", "_state"];
    [_heli,"batt",_state] spawn fza_fnc_fxLoops;
}] call CBA_fnc_addEventHandler;
