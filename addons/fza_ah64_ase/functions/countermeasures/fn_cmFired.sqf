/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_cmFired

Description:
    HIDAS flares leave from their own side's dispenser, flare_1 left and Flare_2 right,
    spread at random by the weapon's dispersion as the engine's own aim would be (as the
    cannon does). Chaff leaves from the one countermeasure point as fired. Runs on every
    machine, each for its own copy.

Parameters:
    Schema of the "fired" event handler.

Returns:
    Nothing

Examples:
    _this call fza_ase_fnc_cmFired;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_weapon", "", "", "", "_magazine", "_projectile"];

private _side = ["fza_CMFlareLauncherL", "fza_CMFlareLauncherR"] find _weapon;
if (_side < 0 || {isNull _projectile}) exitWith {};

([["flare_1_beg", "flare_1_end"], ["Flare_2_beg", "flare_2_end"]] select _side) params ["_beginPoint", "_endPoint"];
private _begin = _heli selectionPosition [_beginPoint, "Memory"];
(_begin vectorFromTo (_heli selectionPosition [_endPoint, "Memory"])) call CBA_fnc_vect2Polar params ["", "_azimuth", "_elevation"];
private _dispersion = deg getNumber (configFile >> "CfgWeapons" >> _weapon >> "Single" >> "dispersion");
private _dir   = [1, _azimuth + random [-_dispersion, 0, _dispersion], _elevation + random [-_dispersion, 0, _dispersion]] call CBA_fnc_polar2vect;
private _speed = getNumber (configFile >> "CfgMagazines" >> _magazine >> "initSpeed");
_projectile setPosASL (_heli modelToWorldVisualWorld _begin);
_projectile setVelocity ((velocity _heli) vectorAdd ((_heli vectorModelToWorldVisual _dir) vectorMultiply _speed));
