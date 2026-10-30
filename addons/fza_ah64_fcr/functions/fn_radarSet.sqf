/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_radarSet

Description:
    Turns the vanilla radar on or off with the player's action. Only when it is in
    the other state, and not again for the same state within half a second: the
    change shows a frame later, and the action given again in the meantime is
    rejected ("Unknown action" in the RPT).

Parameters:
    _heli - The helicopter
    _on   - true to turn it on, false to turn it off

Returns:
    Nothing

Examples:
    [_heli, false] call fza_fcr_fnc_radarSet

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_on"];

if (isVehicleRadarOn _heli isEqualTo _on) exitWith {};
(_heli getVariable ["fza_fcr_radarRequest", [-1, !_on]]) params ["_requestedAt", "_requested"];
if (_requested isEqualTo _on && {CBA_missionTime - _requestedAt < 0.5}) exitWith {};

_heli setVariable ["fza_fcr_radarRequest", [CBA_missionTime, _on]];
player action [["ActiveSensorsOff", "ActiveSensorsOn"] select _on, _heli];
