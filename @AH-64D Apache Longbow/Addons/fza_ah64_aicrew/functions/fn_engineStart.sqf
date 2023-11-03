/* ----------------------------------------------------------------------------
Function: fza_aiCrew_fnc_engineStart


Description:
    Engine event handler, stops the engines from being turned on using the action menu if they shouldn't be on according to the simulated startup sequence.

Parameters:
    (format of the engine event <https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Engine>)
    heli: Object - The helicopter to modify
    engineState: Boolean - True when the engine is turned on, false when turned off

Returns:
    Nothing

Examples:
    --- Code
    [_heli, true] call fza_aiCrew_fnc_Enginestart;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_engineState"];

if ((isplayer driver _heli == false) && _engineState == false && (_heli getVariable ["fza_ah64_aiESStop", true] == true)) then {
    _heli setVariable ["fza_ah64_aiESStop", false];
    //Ai Start up sequence
    [_heli, "fza_ah64_rtrbrake", false] call fza_fnc_animSetValue;
    _heli setVariable ["fza_systems_battSwitchOn",  true, true];
    sleep 3;
    _heli setVariable ["fza_systems_apuBtnOn", true, true];

    sleep 10;
    if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};
	[_heli, "fza_sfmplus_engState", 0, "STARTING", true] call fza_fnc_setArrayVariable;

    sleep 4;
    if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};
    [_heli, 0, "IDLE"] spawn fza_sfmplus_fnc_interactPowerLever;

    sleep 6;
    if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};
	[_heli, "fza_sfmplus_engState", 1, "STARTING", true] call fza_fnc_setArrayVariable;

    sleep 4;
    if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};
    [_heli, 1, "IDLE"] call fza_sfmplus_fnc_interactPowerLever;

    sleep 12;
    if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};
    [_heli, 0, "FLY"] call fza_sfmplus_fnc_interactPowerLever;
    [_heli, 1, "FLY"] call fza_sfmplus_fnc_interactPowerLever;

    sleep 10;
    if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};
    _heli setVariable ["fza_systems_apuBtnOn", false, true];

    _heli setVariable ["fza_ah64_aiESStop", false];
};