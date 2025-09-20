#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _cannotFire = !(_heli isKindOf "fza_ah64base")
        || !(alive _heli) // Helicopter is dead
        || !(alive player) // Player is dead
        || !(isNull curatorCamera) // Curator camera
        || is3DEN // 3DEN editor
        || (isRemoteControlling player && !(getConnectedUAV player isKindOf "fza_ah64base")) // Remote controlling a UAV
        || dialog // Dialog display
        || visibleMap // Map display
        || !isNull findDisplay 602 // Inventory display
        || !isNull findDisplay 24; // Chatting display
private _cannonFired = 0;
private _deltaAccum = 0;

while {!_cannotFire} do {
    if (_cannonFired >= (_heli getVariable "fza_ah64_burst_limit") && (_heli getVariable "fza_ah64_burst_limit") != -1) exitWith {};
    if (([_heli, "fza_ah64_was", player, false] call fza_fnc_getSeatVariable) != WAS_WEAPON_GUN) exitWith {};
    if (_heli getvariable "fza_ah64_gunInhibited" != "") exitwith {};
    if !(_heli getVariable "fza_ah64_armSafeArmed") exitWith {};
    if (inputaction "defaultAction" < 0.5) exitWith {};

    private _deltaTime = ["wpn_testdelta"] call BIS_fnc_deltaTime;
    _deltaAccum = _deltaAccum + _deltaTime;
    if (_deltaAccum > 0.109) then {
        [_heli, "fza_m230"] call BIS_fnc_fire;

        _cannonFired = _cannonFired + 1;
        _deltaAccum = 0;
    
        //ACE3 OVERHEATING  //Author: Commy2 and esteldunedain
        [_heli, "fza_m230", 3500] call ace_overheating_fnc_updateTemperature;
        [_heli] call fza_cannon_fnc_update;
    };
    sleep 0.001;
};