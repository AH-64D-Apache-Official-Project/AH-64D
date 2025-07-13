#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _selectedRockets = _heli getVariable "fza_ah64_selectedRocket";
private _salvoSize = _heli getVariable "fza_ah64_rocketsalvo";
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
private _rocketsFired = 0;
private _deltaAccum = 0;

while {!_cannotFire} do {
    if (([_heli, "fza_ah64_was", player, false] call fza_fnc_getSeatVariable) != WAS_WEAPON_RKT) exitWith {};
    if (_heli getvariable "fza_ah64_rocketInhibit" != "") exitwith {};
    if (_rocketsFired >= _salvoSize && _salvoSize != -1) exitWith {};
    if !(_heli getVariable "fza_ah64_armSafeArmed") exitWith {};
    if (inputaction "defaultAction" < 0.5) exitWith {};

    private _deltaTime = ["wpn_testdelta"] call BIS_fnc_deltaTime;
    _deltaAccum = _deltaAccum + _deltaTime;
    if (_deltaAccum > 0.09) then {
        _heli fireAtTarget [Objnull, _selectedRockets];
        
        _rocketsFired = _rocketsFired + 1;
        _deltaAccum = 0;
    };
    sleep 0.001;
};