/* ----------------------------------------------------------------------------
Function: fza_aifunction_fnc_engineStart


Description:
    Engine event handler, stops the engines from being turned on using the action menu if they shouldn't be on according to the simulated startup sequence.

Parameters:
	(format of the engine event <https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Engine>)
    _heli - The helicopter to modify
    _engineState - True when the engine is turned on, false when turned off

Returns:
	Nothing

Examples:
	--- Code
    [_heli, true] call fza_aifunction_fnc_Enginestarts
	---

Author:
	Unknown, Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_engineState"];

if(local _heli && !(_heli getVariable "fza_ah64_estarted") && _engineState) then {
	_heli engineOn false;
};


if ((isplayer driver _heli == false) && isengineon _heli == false) then {
	_this remoteExec ["fza_aifunction_fnc_engineStartSequence", _heli turretUnit [0]];
	_this remoteExec ["fza_aifunction_fnc_engineStartSequence", _heli turretUnit [-1]];
};
