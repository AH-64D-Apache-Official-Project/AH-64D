params ["_heli"];

private _selectedMissile = _heli getVariable "fza_ah64_selectedMissile";
private _launchTime = CBA_missionTime;
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

_heli setvariable ["fza_ah64_hellfireLaunch", "MSL LAUNCH"];

while {!_cannotFire} do {
    if (inputaction "defaultAction" < 0.5) exitWith {};
    if !(_heli getVariable "fza_ah64_armSafeArmed") exitWith {};

    if (_launchTime + 1 < CBA_missionTime) exitWith {
        [_heli, _selectedMissile] call BIS_fnc_fire;
    };
    sleep 0.01;
};

_heli setvariable ["fza_ah64_hellfireLaunch", ""];