#include "\fza_ah64_sfmplus\functions\rotor\rotor.hpp"

params ["_heli", "_type", "_pitchMin", "_pitchMid", "_pitchMax", "_rollMin", "_rollMid", "_rollMax", "_collMin", "_collMid", "_collMax", "_collCone"];

private _attHoldCycPitchOut     = _heli getVariable "fza_sfmplus_fmcAttHoldCycPitchOut";
private _collToPitchOut         = 0.0;//_heli getVariable "fza_sfmplus_fmcCollectiveToPitch";
private _yawToPitchOut          = 0.0;//_heli getVariable "fza_sfmplus_fmcYawToPitch";
private _sasPitchOut            = 0.0;//_heli getVariable "fza_sfmplus_fmcSasPitchOut";
private _cyclicFwdAft           = _heli getVariable "fza_sfmplus_cyclicFwdAft";
private _forceTrimPosPitch      = _heli getVariable "fza_ah64_forceTrimPosPitch";
private _pitchInput             = _attHoldCycPitchOut + _sasPitchOut + _collToPitchOut + _yawToPitchOut + _cyclicFwdAft + _forceTrimPosPitch;
private _pitchFeather			= 0.0;

private _attHoldCycRollOut      = _heli getVariable "fza_sfmplus_fmcAttHoldCycRollOut";
private _sasRollOut             = 0.0;//_heli getVariable "fza_sfmplus_fmcSasRollOut";
private _collToRollOut          = 0.0;//_heli getVariable "fza_sfmplus_fmcCollectiveToRoll";
private _yawToRollOut           = 0.0;//_heli getVariable "fza_sfmplus_fmcYawToRoll";
private _cyclicLeftRight        = _heli getVariable "fza_sfmplus_cyclicLeftRight";
private _forceTrimPosRoll       = _heli getVariable "fza_ah64_forceTrimPosRoll";
private _rollInput              = _attHoldCycRollOut + _sasRollOut + _collToRollOut + _yawToRollOut + _cyclicLeftRight + _forceTrimPosRoll;
private _rollFeather			= 0.0;

private _hdgHoldPedalYawOut     = _heli getVariable "fza_sfmplus_fmcHdgHoldPedalYawOut";
private _sasYawOut              = 0.0;//_heli getVariable "fza_sfmplus_fmcSasYawOut";
private _pedalLeftRight         = _heli getVariable "fza_sfmplus_pedalLeftRight";
private _forceTrimPosYaw        = _heli getVariable "fza_ah64_forceTrimPosYaw";
private _yawInput               = _hdgHoldPedalYawOut + _sasYawOut + _pedalLeftRight + _forceTrimPosYaw;

private _collectiveOut          = _heli getVariable "fza_sfmplus_collectiveOutput";
private _altHoldCollOut         = _heli getVariable "fza_sfmplus_fmcAltHoldCollOut";
private _collInput              = _collectiveOut + _altHoldCollOut;
private _collFeather            = 0.0;

switch (_type) do {
	case MAIN: {
		_pitchFeather  = [-1, 1, _pitchInput, _pitchMin, _pitchMid, _pitchMax] call fza_sfmplus_fnc_linearInterpFromCenter;
		_rollFeather   = [-1, 1, _rollInput,  _rollMin,  _rollMid, _rollMax]   call fza_sfmplus_fnc_linearInterpFromCenter;
		_collFeather   = linearConversion[ 0, 1, _collInput,  _collMin, _collMax, true];
	};
	case TAIL: {
		_collFeather   = [-1, 1, _yawInput,  _collMin, _collMid, _collMax] call fza_sfmplus_fnc_linearInterpFromCenter;
	};
};

[_pitchFeather, _rollFeather, _collFeather];