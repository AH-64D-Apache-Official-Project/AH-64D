/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusUpdate

Description:
	
Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:


Examples:


Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _deltaTime = ["sfmplusUpdate_deltaTime"] call BIS_fnc_deltaTime;

//Input
[_heli] call fza_fnc_sfmplusGetInput;

//Weight
private _emptyMass      = _heli getVariable "fza_ah64_emptyMass";
private _maxTotFuelMass = _heli getVariable "fza_ah64_maxTotFuelMass";
private _fwdFuelMass    = [_heli] call fza_fnc_sfmplusSetFuel select 0;
private _aftFuelMass    = [_heli] call fza_fnc_sfmplusSetFuel select 1;

//Engines
[_heli, _deltaTime] call fza_fnc_sfmplusEngineController;

//Fuel
private _apuFF  = 0;
private _eng1FF = _heli getVariable "fza_ah64_engFF" select 0;
private _eng2FF = _heli getVariable "fza_ah64_engFF" select 1;
private _curFuelFlow = 0;

if (_heli animationphase "plt_apu" > 0.5) then {
	_apuFF = 0.0220;	//175pph
};
_curFuelFlow    = (_apuFF + _eng1FF + _eng2FF) * _deltaTime;

private _totFuelMass  = _fwdFuelMass + _aftFuelMass;
_totFuelMass          = _totFuelMass - _curFuelFlow;
private _armaFuelFrac = _totFuelMass / _maxTotFuelMass;
_heli setFuel _armaFuelFrac;

//Pylons
private _pylonMass = 0;
{
	_x params ["_magName","", "_magAmmo"];
	private _magConfig    = configFile >> "cfgMagazines" >> _magName;
	private _magMaxWeight = getNumber (_magConfig >> "weight");
	private _magMaxAmmo   = getNumber (_magConfig >> "count");
	_pylonMass = _pylonMass + linearConversion [0, _magMaxAmmo, _magAmmo, 0, _magMaxWeight];
} foreach magazinesAllTurrets _heli;

private _curMass = _emptyMass + _totFuelMass + _pylonMass;
_heli setMass _curMass;

//Damage
[_heli, _deltaTime] call fza_fnc_sfmplusApplyDamage;

//Stabilator
if(fza_ah64_sfmPlusStabilatorEnabled) then {
	[_heli, _deltaTime] call fza_fnc_sfmplusStabilator;
};
/*
hintsilent format ["Engine 1 Ng = %1
					\nEngine 1 TQ = %2
					\nEngine 1 TGT = %3
					\n------------------
					\nEngine 2 Ng = %4
					\nEngine 2 TQ = %5
					\nEngine 2 TGT = %6
					\n------------------
					\nEng State = %7
					\nIs Single Engine? = %8
					\nPercent NP = %9
					\nEng Clutch State = %10
					\nEng Start Switch = %11
					\n-------------------
					\nColl Pos = %12
					\nEng FF = %13
					\nEngine Base NG = %14", 		
					_heli getVariable "fza_ah64_engPctNG" select 0, 
					_heli getVariable "fza_ah64_engPctTQ" select 0, 
					_heli getVariable "fza_ah64_engTGT" select 0,
					_heli getVariable "fza_ah64_engPctNG" select 1, 
					_heli getVariable "fza_ah64_engPctTQ" select 1, 
					_heli getVariable "fza_ah64_engTGT" select 1,
					_heli getVariable "fza_ah64_engState",
					_heli getVariable "fza_ah64_isSingEng",
					_heli getVariable "fza_ah64_engPctNP",
					_heli getVariable "fza_ah64_engClutchState",
					_heli getVariable "fza_ah64_engStartSwitchState",
					fza_ah64_collectiveOutput,
					_heli getVariable "fza_ah64_engFF",
					_heli getVariable "fza_ah64_engBaseNG"];
*/

/* Old engine...
private _engState  = _heli getVariable "fza_ah64_engState";
private _eng1State = _engState select 0;
private _eng2State = _engState select 1;
if (_eng1State == "STARTING" || _eng2State == "STARTING") then {
	_heli engineOn true;
};

private _isSingleEng     = _heli getVariable "fza_ah64_isSingleEng";
private _engPwrLvrState  = _heli getVariable "fza_ah64_engPowerLeverState";
private _eng1PwrLvrState = _engPwrLvrState select 0;
private _eng2PwrLvrState = _engPwrLvrState select 1;

private _eng1TqMult = 1;
private _eng2TqMult = 1;
if (((_eng1State == "ON" && _eng1PwrLvrState == "IDLE") || _eng1State in ["OFF","DEST"]) && _eng2PwrLvrState == "FLY") then {
	_eng1TqMult = 0;
	_eng2TqMult = 2;
	_isSingleEng = true;
} else {
	_isSingleEng = false;
};

if (((_eng2State == "ON" && _eng2PwrLvrState == "IDLE") || _eng2State in ["OFF","DEST"]) && _eng1PwrLvrState == "FLY") then {
	_eng1TqMult = 2;
	_eng2TqMult = 0;
	_isSingleEng = true;
} else {
	_isSingleEng = false;
};
_heli setVariable ["fza_ah64_isSingleEng", _isSingleEng];

[_heli, 0, _deltaTime, _eng1TqMult] call fza_fnc_sfmplusEngine;
[_heli, 1, _deltaTime, _eng2TqMult] call fza_fnc_sfmplusEngine;
*/


//Start Simplified Rotor Test
/*
private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
	params ["_heli", "_p1", "_p2", "_col"];
	drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _bladeRadius = 7.315;
private _rotorRPM    = 292;
private _tipSpeed    = (2 * PI * _rotorRPM / 60) * _bladeRadius;
private _V_mps       = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
private _advRatio    = _V_mps / _tipSpeed;

private _minCycPitch = -10.0;
private _maxCycPitch =  20.0;
private _minCycRoll  = -10.5;
private _maxCycRoll  =   7.0;

//Cyclic roll
private _discRollAngle  = 0;
if (fza_ah64_cyclicRollOut < 0) then
{
	_discRollAngle = _minCycRoll;
};
if (fza_ah64_cyclicRollOut > 0) then {
	_discRollAngle = -_maxCycRoll;
};
_discRollAngle = _discRollAngle * fza_ah64_cyclicRollOut;

//Cyclic pitch
private _discPitchAngle = 0;
if (fza_ah64_cyclicPitchOut < 0) then
{
	_discPitchAngle = _minCycPitch;
};
if (fza_ah64_cyclicPitchOut > 0) then {
	_discPitchAngle = -_maxCycPitch;
};
_discPitchAngle = _discPitchAngle * fza_ah64_cyclicPitchOut;

private _thrustMod = 1.3643;
private _hvrThrust = 97410;	//N
private _minThrust = 0.15 * _hvrThrust;
private _maxThrust = _hvrThrust * _thrustMod;
private _curThrust = _minThrust + ((_maxThrust - _minThrust) * fza_ah64_collectiveOutput);
_curThrust = _curThrust * (1 + _advRatio);

private _rotorPos    = [0.00, 1.33, 2.08];
private _refDatum    = [0.00, 0.00, 0.00];
private _modelCenter = _heli selectionPosition "modelCenter";
private _pos = _rotorPos vectorAdd _refDatum vectorAdd _modelCenter;

private _a = [0,0,0]; private _b = [0,0,0]; private _c = [0,0,0]; private _d = [0,0,0]; private _e = [0,0,0]; private _thrustVector = [0,0,0];
private _xAxisTQ = 0.0; private _yAxisTQ = 0.0; private _zAxisTQ = 0.0;

_a = _pos vectorAdd [0.0, cos _discPitchAngle * _bladeRadius, sin _discPitchAngle * _bladeRadius];
_b = _pos vectorAdd [cos _discRollAngle * _bladeRadius, 0.0, sin _discRollAngle * _bladeRadius];
_c = _pos vectorAdd [0.0, cos _discPitchAngle * (-_bladeRadius), sin _discPitchAngle * (-_bladeRadius)];
_d = _pos vectorAdd [cos _discRollAngle * (-_bladeRadius), 0.0, sin _discRollAngle * (-_bladeRadius)];
_e = (_a vectorAdd _c) vectorMultiply 0.5;
_thrustVector = vectorNormalized ((_b vectorDiff _d) vectorCrossProduct (_a vectorDiff _c));

private _thrust = _thrustVector vectorMultiply (_curThrust * _deltaTime);
_heli addForce[_heli vectorModelToWorld _thrust, _e];

private _yAxisThrust = _curThrust * sin _discPitchAngle;
private _xAxisThrust = _curThrust * sin _discRollAngle;
_xAxisTQ = _yAxisThrust * _deltaTime;
_yAxisTQ = _xAxisThrust * _deltaTime;
//_zAxisTQ = _totalTorque * _deltaTime;

_heli addTorque (_heli vectorModelToWorld [_xAxisTQ, _yAxisTQ, 0.0]);

hintSilent format ["GWT = %1
                    \nThrust = %2
					\nColl Pos = %3", getMass _heli, _curThrust, fza_ah64_collectiveOutput];

[_heli, _a, _c, _colorWhite] call DRAW_LINE;
[_heli, _b, _d, _colorWhite] call DRAW_LINE;
[_heli, _e, _e vectorAdd _thrustVector, _colorBlue] call DRAW_LINE;
*/
//End Simplified Rotor Test