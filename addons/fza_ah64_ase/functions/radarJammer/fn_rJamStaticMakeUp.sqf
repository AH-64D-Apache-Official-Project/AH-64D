/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamStaticMakeUp

Description:
    The gain that puts back what a vehicle's sound attenuation takes off the radio jamming
    static, which is heard in the headset and shouldn't be muffled by the hull. The engine
    filters every outside sound with the vehicle's attenuationEffectType while the listener
    is inside it in first person: a turret can turn that off or swap it, and a cargo seat
    can be open. The static's loss is worked out from that effect's equalizers at points
    across its spectrum, weighted by how much of the static is near each, and cached.

Parameters:
    _unit - the unit being listened through

Returns:
    The gain, 1 when nothing attenuates

Examples:
    [call CBA_fnc_currentUnit] call fza_ase_fnc_rJamStaticMakeUp

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params [["_unit", objNull, [objNull]]];

private _vehicle = vehicle _unit;
if (isNull _unit
    || {_vehicle isEqualTo _unit}
    || {cameraView in ["EXTERNAL", "GROUP"]}
    || {!isNull curatorCamera}
    || {isTurnedOut _unit}) exitWith {1};

private _config = configOf _vehicle;
private _effect = getText (_config >> "attenuationEffectType");
private _turret = _vehicle unitTurret _unit;
if (_turret isNotEqualTo []) then {
    private _turretConfig = [_config, _turret] call CBA_fnc_getTurret;
    if (getNumber (_turretConfig >> "disableSoundAttenuation") == 1) then {
        _effect = "";
    } else {
        if (isText (_turretConfig >> "soundAttenuationTurret")) then {_effect = getText (_turretConfig >> "soundAttenuationTurret");};
    };
} else {
    private _cargo = _vehicle getCargoIndex _unit;
    private _open  = getArray (_config >> "soundAttenuationCargo");
    if (_cargo >= 0 && {_open isNotEqualTo []} && {(_open select (_cargo min (count _open - 1))) isEqualTo 0}) then {_effect = "";};
};
if (_effect == "") exitWith {1};

private _cached = fza_ase_commsMakeUp get _effect;
if (!isNil "_cached") exitWith {_cached};

// Peaking equalizer bands, [centre Hz, A, Q] from their gain and width in octaves
private _bands = [];
{
    private _eq = _x;
    private _widths = getArray (_eq >> "bandwidth");
    private _gains  = getArray (_eq >> "gain");
    {
        private _width = _widths param [_forEachIndex, 0];
        private _gain  = _gains param [_forEachIndex, 1];
        if (_x isEqualType 0 && {_width isEqualType 0} && {_gain isEqualType 0} && {_x > 0} && {_width > 0} && {_gain > 0}) then {
            _bands pushBack [_x, sqrt _gain, sqrt (2 ^ _width) / (2 ^ _width - 1)];
        };
    } forEach getArray (_eq >> "center");
} forEach ("configName _x find 'Equalizer' == 0" configClasses (configFile >> "CfgSoundEffects" >> "AttenuationsEffects" >> _effect));

// The static's spectrum, as the loops are made
private _power = 0;
{
    _x params ["_f", "_weight"];
    private _gain = 1;
    {
        _x params ["_f0", "_a", "_q"];
        private _d = (_f0 ^ 2 - _f ^ 2) ^ 2;
        _gain = _gain * (_d + (_f * _f0 * _a / _q) ^ 2) / (_d + (_f * _f0 / (_a * _q)) ^ 2);
    } forEach _bands;
    _power = _power + _weight * _gain;
} forEach [[300, 0.008], [450, 0.059], [650, 0.077], [900, 0.105], [1250, 0.138], [1700, 0.182], [2300, 0.244], [3100, 0.187]];

private _makeUp = if (_power > 0) then {((1 / sqrt _power) max 1) min ASE_RJAM_COMMS_MAKEUP_MAX} else {1};
fza_ase_commsMakeUp set [_effect, _makeUp];
_makeUp
