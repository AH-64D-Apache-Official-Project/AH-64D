/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_pointAltitudeBase

Description:
    HeliSim's environment base altitude, in feet: its barometric altitude is the
    terrain's sea level height plus this. Point altitudes are kept as sea level
    height and shown and entered with this added, so they read like the
    aircraft's own altitude.

    Taken from the aircraft's barometric altitude and height, rounded to 100 ft
    as every environment's base altitude is.

Parameters:
    _heli - The helicopter

Returns:
    Base altitude (ft)

Examples:
    --- Code
    private _altFt = _altMslMetres * 3.28084 + ([_heli] call fza_dms_fnc_pointAltitudeBase);
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _barAlt = _heli getVariable ["bmkhs_barAlt", 0];
round ((_barAlt - (getPosASL _heli # 2) * 3.28084) / 100) * 100
