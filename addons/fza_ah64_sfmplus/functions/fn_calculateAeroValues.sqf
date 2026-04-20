/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_calculateAeroValues

Description:
    Calculates and returns _alpha (angle of attack) and _beta_g (sideslip) for the
    helicopter. 

    Reference: 
    https://www.mathworks.com/help/aeroblks/incidencesideslipairspeed.html
    https://trace.tennessee.edu/cgi/viewcontent.cgi?referer=&httpsredir=1&article=5851&context=utk_gradthes
    
Parameters:
    _heli - The apache helicopter to check.

Returns:
    _alpha (angle of attack) in degrees
    _beta_g (sideslip) in degrees
    _gamma (flight path angle) in degrees

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

#include "\fza_ah64_sfmplus\headers\core.hpp"

//Helicopter velocity in model space (no wind)
private _vx = (_heli getVariable "fza_sfmplus_velModelSpaceNoWind") # 0;
private _vy = (_heli getVariable "fza_sfmplus_velModelSpaceNoWind") # 1;
private _vz = (_heli getVariable "fza_sfmplus_velModelSpaceNoWind") # 2;

private _totSpeed   = vectorMagnitude [_vx, _vy, _vz];
private _horizSpeed = vectorMagnitude [_vx, _vy];

//Alpha: angle between forward (Y) and vertical (Z) velocity in the pitch plane.
//atan2 handles zero denominator and all quadrants correctly.
private _alpha_deg = _vz atan2 _vy;

//Beta: aerodynamic sideslip angle — angle between total horizontal velocity and body Y axis.
// asin(vx / horizSpeed) gives correct sign (solely determined by vx) and correct magnitude.
// Below ~1 m/s (~2 kts) the velocity is noise-dominated (hover drift ~0.02-0.05 m/s means
// 0.01 m/s noise → ~20° error), so fade to zero over 0-1 m/s to prevent ball oscillation.
private _betaRaw  = if (_horizSpeed < 0.001) then { 0.0 } else { asin ([_vx / _horizSpeed, -1.0, 1.0] call BIS_fnc_clamp); };
private _betaScale = [_horizSpeed, 0.0, 1.0] call BIS_fnc_clamp;
private _beta_deg  = _betaRaw * _betaScale;
// beta_g: lateral velocity in g's. Equivalent to V * sin(asin(vx/V)) / g which simplifies to vx/g.
private _beta_g     = _vx / GRAVITY;

//Gamma: flight path angle (velocity vector above/below horizontal).
private _gamma     = if (_totSpeed == 0.0) then { 0.0; } else { asin ([_vz / _totSpeed, -1.0, 1.0] call BIS_fnc_clamp); };

_heli setVariable ["fza_sfmplus_aero_alpha_deg", _alpha_deg, true];
_heli setVariable ["fza_sfmplus_aero_beta_deg",  _beta_deg,  true];
_heli setVariable ["fza_sfmplus_aero_beta_g",    _beta_g,    true];
_heli setVariable ["fza_sfmplus_aero_gamma",     _gamma,     true];
