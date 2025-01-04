/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_probes

Description:
    Simulation of the Air probes attached to the enging covers

Parameters:
    _heli = The apache

Returns:
    Nothing

Examples:
    [_heli] call fza_fnc_SimulateProbes;

Author:
	Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

if !(player == currentPilot _heli) exitwith {};

private _realRPM      = [_heli] call fza_sfmplus_fnc_getRtrRPM;
private _inducedFlow  = [0.0, 0.0, _realRPM * (8.0 + ((_heli getVariable "fza_sfmplus_collectiveOutput") * 5.0))];
private _gravity      = _heli worldtomodelVisual (getPosVisual _heli vectoradd [0,0,9.806]);
private _outputvector = (_heli getVariable "fza_sfmplus_velModelSpaceWind") vectoradd _inducedFlow vectoradd _gravity;
private _outputvectorNormalized = vectorNormalized _outputvector;
private _pitch = asin ([0,-1,0] vectorDotProduct _outputvectorNormalized);
private _bank  = asin ([-1,0,0] vectorDotProduct _outputvectorNormalized);

_heli animateSource["l_ads_p", _pitch];
_heli animateSource["l_ads_b", _bank];
_heli animateSource["r_ads_p", _pitch];
_heli animateSource["r_ads_b", _bank];