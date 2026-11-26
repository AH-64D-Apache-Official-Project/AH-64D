/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_cmCounts

Description:
    Countermeasure cartridges left, for the US and UK mission equipment

Parameters:
    _heli - The helicopter

Returns:
    [left flares, right flares, chaff]

Examples:
    [_heli] call fza_ase_fnc_cmCounts params ["_flareL", "_flareR", "_chaff"];

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _flareL = 0;
private _flareR = 0;
private _chaff  = 0;
{
    _x params ["_className", "_turretPath", "_ammoCount"];
    if (_turretPath isNotEqualTo [-1]) then {continue;};
    switch (_className) do {
        case "fza_flare_32L_mag": {_flareL = _flareL + _ammoCount;};
        case "fza_flare_32R_mag": {_flareR = _flareR + _ammoCount;};
        case "fza_chaff_64_mag":  {_chaff  = _chaff + _ammoCount;};
        // Two rounds a cartridge
        case "fza_chaff_30_mag":  {_chaff  = _chaff + floor (_ammoCount / 2);};
    };
} forEach magazinesAllTurrets _heli;

[_flareL, _flareR, _chaff]
