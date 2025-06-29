params ["_heli"];

private _cannonFired = 0;
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

while {!_cannotFire && (inputaction "defaultAction" > 0.5)} do {
    waitUntil {(weaponstate [_heli, [0], "fza_m230"])#5 == 0};
    if (_cannonFired >= (_heli getVariable "fza_ah64_burst_limit") && (_heli getVariable "fza_ah64_burst_limit") != -1) exitWith {};
    if !(_heli getVariable "fza_ah64_armSafeArmed") exitWith {};
    [_heli, "fza_m230"] call BIS_fnc_fire;
    _cannonFired = _cannonFired + 1;
    sleep 0.01;
    
    //ACE3 OVERHEATING
    //Author: Commy2 and esteldunedain
    [_heli, "fza_m230", 3500] call ace_overheating_fnc_updateTemperature;
    [_heli] call fza_cannon_fnc_update;
};