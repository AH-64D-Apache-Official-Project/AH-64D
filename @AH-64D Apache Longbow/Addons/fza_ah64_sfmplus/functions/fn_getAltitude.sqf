/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getAltitude

Description:
    Returns the current AGL and MSL altitude of the helicopter

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

#define SCALE_METERS_FEET 3.28084

private _barAlt  = _heli getVariable "fza_sfmplus_PA";
_barAlt = [_barAlt, 0.0, 20000] call bis_fnc_clamp;

private _radAlt = getPos _heli # 2 * SCALE_METERS_FEET;
if (_radAlt > 50) then {
    _radAlt = round (_radAlt / 10) * 10;
};
_radAlt     = [_radAlt, 0.0, 1420.0] call bis_fnc_clamp;

[_barAlt, _radAlt];