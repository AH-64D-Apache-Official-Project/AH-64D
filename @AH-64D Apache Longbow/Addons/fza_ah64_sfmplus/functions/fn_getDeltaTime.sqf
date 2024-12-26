/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getFixedDeltaTime

Description:
    Custom time handler

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
if (isGamePaused) exitWith { fza_sfmplus_deltaTime = 0.0; };

fza_sfmplus_currentTime    = diag_tickTime;
fza_sfmplus_deltaTime      = (fza_sfmplus_currentTime - fza_sfmplus_previousTime);
fza_sfmplus_previousTime   = fza_sfmplus_currentTime;

if (fza_sfmplus_deltaTime > (1.0 / 5.0)) then { fza_sfmplus_deltaTime = (1.0 / 5.0)};
fza_sfmplus_deltaTime = fza_sfmplus_deltaTime * accTime;