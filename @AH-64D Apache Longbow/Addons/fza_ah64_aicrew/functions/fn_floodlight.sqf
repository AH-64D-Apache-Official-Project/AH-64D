/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_floodlight
Description:
    handles the floodlighting control for ai
Parameters:
    Heli: Object - The helicopter to modify
Returns:
    Nothing
Examples:
    [_this] call fza_AICrew_fnc_floodlight;
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if !fza_ah64_aiFloodlight exitWith {};
if (isplayer driver _heli && isplayer gunner _heli) exitWith {};
if !(_heli getVariable "fza_ah64_battery") exitWith {};

private _driver = driver vehicle _heli;
private _gunner = gunner vehicle _heli;
private _isNightTime = daytime < 20.0 && daytime > 4.20;

if ((alive _driver && !isPlayer _driver) || (alive _gunner && !isPlayer _gunner)) then {
    if (_isNightTime == isLightOn [_heli,[0]]) then {
        [_heli, "light", "floodlight"] call fza_fnc_lightHandleControl;
    };
};