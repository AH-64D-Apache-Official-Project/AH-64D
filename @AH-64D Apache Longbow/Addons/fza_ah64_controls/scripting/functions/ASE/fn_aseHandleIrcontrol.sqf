/* ----------------------------------------------------------------------------
Function: fza_fnc_aseHandleIrControl

Description:
    Enables IR jammer, can be disabled by setting fza_ah64_irJamOn to false.

Parameters:
    _heli - The helicopter to enable the jammer on

Returns:
	nothing

Examples:
	_this spawn fza_fnc_aseHandleIrcontrol;
    
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (_heli getVariable "fza_ah64_irJamOn") exitWith {};

if !local _heli exitWith {
    _this remoteExec ["fza_fnc_aseHandleIrControl", _heli]
};

_heli setammo ["fza_AseIRjammer",999999999];

(_heli getVariable "fza_ah64_irJamCooldown") params ["_originalJamTime", "_timeSinceLastMeasurement"];

//Calculate how much the jammer has cooled down since the last deployment.
private _jamTemp = (_originalJamTime - (time - _timeSinceLastMeasurement)) max 0;
_heli setVariable ["fza_ah64_irJamOn", true, true];

_heli setVariable ["fza_ah64_irJamCooldown", [_jamTemp, time], true];
while {_heli getHitPointDamage "HitLfab" < 0.8 &&
    alive _heli &&
    _heli getVariable "fza_ah64_irJamOn" &&
    _jamTemp < 60 
} do {
    [_heli, "fza_AseIRjammer", [-1]] call BIS_fnc_fire;
    _jamTemp = _jamTemp + 0.5;
    sleep 1;
};

_heli setVariable ["fza_ah64_irJamOn", false, true];
_heli setVariable ["fza_ah64_irJamCooldown", [_jamTemp, time], true];