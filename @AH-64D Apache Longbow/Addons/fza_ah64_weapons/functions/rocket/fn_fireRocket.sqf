params ["_heli"];

private _selectedRockets = _heli getVariable "fza_ah64_selectedRocket";
private _rocketsFired = 0;
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
    waitUntil {(weaponstate [_heli, [0], _selectedRockets])#5 == 0 };
    if (_rocketsFired >= (_heli getVariable "fza_ah64_rocketsalvo")) exitWith {};
    if !(_heli getVariable "fza_ah64_armSafeArmed") exitWith {};
    if (_heli getvariable "fza_ah64_rocketInhibit" != "") exitwith {};
    [_heli, _selectedRockets] call BIS_fnc_fire;
    _rocketsFired = _rocketsFired + 1;
    sleep 0.01;
};