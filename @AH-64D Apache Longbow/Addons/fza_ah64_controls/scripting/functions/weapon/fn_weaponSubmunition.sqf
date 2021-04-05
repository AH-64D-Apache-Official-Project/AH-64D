/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponSubmunition

Description:
    Deploys submunitions

Parameters:
    _heli - The helicopter that fired it
    _unused - Unused
    _unused - Unused
    _unused - Unused
    _unused - Unused
    _missobj - The missile unit that fired it

Returns:
	Nothing

Examples:

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","","","","","","_missobj"];

if !(typeOf _missobj == "fza_275_m255" || typeOf _missobj == "fza_275_m261") exitwith {};

_Tgpos = screentoworld[0.5, 0.5];

if !(isNull laserTarget _heli) then {
    _TGpos = getPosATL laserTarget _heli;
};

if (typeOf _missobj == "fza_275_m255") then {
    _burstdist = 200;
} else {
    _burstdist = 500;
};

waituntil{(_missobj distance _Tgpos < _burstdist && _missobj distance _heli > 450)};


if (typeOf _missobj == "fza_275_m255" || typeOf _missobj == "fza_275_m261") then {
    triggerAmmo _missobj;
};


//flechett red smoke 
if (typeOf _missobj == "fza_275_m255") then {
    drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 0.5, 7, [0,0,0], [0,0,0], 0, 0.7, 0.5, 0, [8,16,24,32,36,36,36], [[0.4,0,0,0.8],[0.4,0,0,0.7],[0.4,0,0,0.6],[0.4,0,0,0.5],[0,0,0,0]], [0], 0.1, 0.2, "", "", _missobj];
    drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 0.5, 7, [0,0,0], [0,0,0], 0, 0.7, 0.5, 0, [8,16,24,32,36,36,36], [[0.4,0,0,0.8],[0.4,0,0,0.7],[0.4,0,0,0.6],[0.4,0,0,0.5],[0,0,0,0]], [0], 0.1, 0.2, "", "", _missobj];
    drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 0.5, 7, [0,0,0], [0,0,0], 0, 0.7, 0.5, 0, [8,16,24,32,36,36,36], [[0.4,0,0,0.8],[0.4,0,0,0.7],[0.4,0,0,0.6],[0.4,0,0,0.5],[0,0,0,0]], [0], 0.1, 0.2, "", "", _missobj];
    drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 0.5, 7, [0,0,0], [0,0,0], 0, 0.7, 0.5, 0, [8,16,24,32,36,36,36], [[0.4,0,0,0.8],[0.4,0,0,0.7],[0.4,0,0,0.6],[0.4,0,0,0.5],[0,0,0,0]], [0], 0.1, 0.2, "", "", _missobj];
};

