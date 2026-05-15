/* ----------------------------------------------------------------------------
Function: fza_anim_fnc_animationUpdate

Description:
    Per-frame dispatcher for all 3D model animations driven by HeliSim data.
    Called from fza_ah64_animationEFHandler (EachFrame).

    Sub-functions are guarded by individual CBA settings so each animation
    category can be disabled independently:
      • fza_ah64_animControls – pilot/CPG stick and collective lever
      • fza_ah64_animProbes   – air data (ADS) probe vanes
      • fza_ah64_animRotor    – main/tail rotor swashplate, blade pitch

Parameters:
    _heli - The helicopter object [Object]

Returns:
    Nothing

Author:
    FZA AH-64D Project
---------------------------------------------------------------------------- */
params ["_heli"];

if (fza_ah64_animControls) then { [_heli] call fza_anim_fnc_controlsAnim };
if (fza_ah64_animProbes)   then { [_heli] call fza_anim_fnc_probesAnim   };
if (fza_ah64_animRotor)    then { [_heli] call fza_anim_fnc_rotorAnim    };
