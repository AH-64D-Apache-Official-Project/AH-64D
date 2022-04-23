/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_antiLift

Description:
	Applies a negative lift force if the player attempts to takeoff with the
    engines at idle.

Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];

private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
	params ["_heli", "_p1", "_p2", "_col"];
	drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

if (isEngineOn _heli) then {
    private _objCtr        = _heli selectionPosition ["modelCenter", "Memory"];
    private _forcePos      = _heli getVariable "fza_sfmplus_forcePos";
    private _forceVec      = [0.0, 0.0, 1.0];   //X, Z, Y
    private _forceVec_norm = vectorNormalized(_forcePos vectorAdd _forceVec);

    private _eng1Np        = _heli getVariable "fza_sfmplus_engPctNP" select 0;
    private _eng2Np        = _heli getVariable "fza_sfmplus_engPctNP" select 1;
    private _rtrRPM        = _eng1Np max _eng2Np;
    private _forceVal      = 0.15;
    private _forceMult     = linearConversion[0.0, 0.98, _rtrRPM, _forceVal, 0.0];
    _forceMult = [_forceMult, 0.0, _forceVal] call BIS_fnc_clamp;

    private _curMass       = getMass _heli;
    private _negLiftForce  = ((_curMass * -9.806) * _forceMult) * fza_sfmplus_collectiveOutput;
    _negLiftForce          = [_negLiftForce, 0.0, (1.0 / 15.0) * _deltaTime] call BIS_fnc_lerp;
    private _negLift       = _forceVec vectorMultiply _negLiftForce;

    _heli addForce[_heli vectorModelToWorld _negLift, _forcePos];

    #ifdef __A3_DEBUG__
    //Draw the force vector
    [_heli, _forcePos, _forcePos vectorAdd _forceVec, _colorGreen] call DRAW_LINE;

    #endif
};