/* ----------------------------------------------------------------------------
Function: fza_fnc_aseHandleRfControl

Description:
    Enables RF jammer, can be disabled by setting fza_ah64_rfJamOn to false.

Parameters:
    _heli - The helicopter to enable the jammer on

Returns:
	nothing

Examples:
	_this spawn fza_fnc_aseHandleRfcontrol;
    
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (_heli getVariable "fza_ah64_rfJamOn") exitWith {};

if !local _heli exitWith {
    _this remoteExec ["fza_fnc_aseHandleRfControl", _heli]
};

_heli setammo ["fza_AseRFjammer",999999999];

(_heli getVariable "fza_ah64_rfJamCooldown") params ["_originalJamTime", "_timeSinceLastDeployment"];

//Calculate how much the jammer has cooled down since the last deployment.
private _jamTemp = (_originalJamTime - (time - _timeSinceLastDeployment)) max 0;
_heli setVariable ["fza_ah64_rfJamOn", true, true];

_heli setVariable ["fza_ah64_rfJamCooldown", [_jamTemp, time], true];
while {_heli getHitPointDamage "RfJammer" < 0.8 &&
    alive _heli &&
    _heli getVariable "fza_ah64_rfJamOn" &&
    _jamTemp < 60 
} do {
    [_heli, "fza_AseRFjammer", [-1]] call BIS_fnc_fire;
    _jamTemp = _jamTemp + 0.5;
    sleep 1;
};

_heli setVariable ["fza_ah64_rfJamOn", false, true];
_heli setVariable ["fza_ah64_rfJamCooldown", [_jamTemp, time], true];