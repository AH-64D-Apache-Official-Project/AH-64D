/* ----------------------------------------------------------------------------
Function: fza_anim_fnc_probesAnim

Description:
    Drives the left and right air data sensor (ADS) probe vane animations
    (l_ads_p, l_ads_b, r_ads_p, r_ads_b).

    The probes measure the local angle of the combined airflow vector, which
    is the sum of:
      • Aircraft velocity relative to airmass (fza_sfmplus_velModelSpace)
      • Rotor-induced downwash (proportional to RPM and collective)
      • Gravity-induced apparent flow (worldToModelVisual gravity vector)

    Both probes are symmetric so they receive identical pitch and bank values.

Parameters:
    _heli - The helicopter object [Object]

Returns:
    Nothing

Author:
    FZA AH-64D Project
---------------------------------------------------------------------------- */
params ["_heli"];

// Only the pilot drives the probes (avoids duplicate network traffic)
if (player != currentPilot _heli) exitWith {};

private _realRPM    = [_heli] call fza_sfmplus_fnc_getRtrRPM;
private _collective = _heli getVariable ["fza_sfmplus_collectiveOutput", 0.0];

// Rotor induced downwash in model space (positive Z = down in Arma model coords)
// Scale: 8 m/s baseline at 100% RPM, up to 13 m/s at full collective
private _inducedFlow = [0.0, 0.0, _realRPM * (8.0 + (_collective * 5.0))];

// Gravity as apparent upward flow in model space (9.806 m/s² upward in world → model local)
private _gravity = _heli worldToModelVisual (getPosVisual _heli vectorAdd [0, 0, 9.806]);

// Total local airflow vector
private _velAirmass  = _heli getVariable ["fza_sfmplus_velModelSpace", [0.0, 0.0, 0.0]];
private _totalFlow   = _velAirmass vectorAdd _inducedFlow vectorAdd _gravity;
private _normalized  = vectorNormalized _totalFlow;

// Pitch: Y axis ([0,-1,0] = forward in Arma model) → angle of attack
// Bank:  X axis ([-1,0,0] = right in Arma model)   → sideslip
private _pitch = asin ([0, -1, 0] vectorDotProduct _normalized);
private _bank  = asin ([-1, 0, 0] vectorDotProduct _normalized);

_heli animateSource ["l_ads_p", _pitch];
_heli animateSource ["l_ads_b", _bank];
_heli animateSource ["r_ads_p", _pitch];
_heli animateSource ["r_ads_b", _bank];
