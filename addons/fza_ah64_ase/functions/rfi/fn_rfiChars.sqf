/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rfiChars

Description:
    The two type modifier characters of an emitter type, the same as its RLWR icon's. A type with no icon is an
    unknown ADU, "U".

Parameters:
    _code - fza_aseIcon of the emitter

Returns:
    [left, right]

Examples:
    ["SA6"] call fza_ase_fnc_rfiChars // ["", "6"]

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_code"];

if (isNil "fza_ase_rfiCharCache") then {fza_ase_rfiCharCache = createHashMap;};
fza_ase_rfiCharCache getOrDefaultCall [_code, {
    private _cfg = configFile >> "FzaIconTypes" >> format ["RLWR_%1_SRH", _code];
    [["", "U"], [getText (_cfg >> "textA"), getText (_cfg >> "textB")]] select isClass _cfg
}, true]
