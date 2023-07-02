/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_salShouldStartLobl

Description:
    Defines whether a SAL missile should start in LOBL
    (can see valid laser energy)

Parameters:
    _heli - The object who is seeking

Returns:
    startLobl

Examples:
    --- Code
    [_heli] call fza_hellfire_fnc_salShouldStartLobl
    ---

---------------------------------------------------------------------------- */
params ["_heli"];
private _lasePos = [_heli] call fza_hellfire_fnc_salLasePos;
!isNil "_laserPos";
