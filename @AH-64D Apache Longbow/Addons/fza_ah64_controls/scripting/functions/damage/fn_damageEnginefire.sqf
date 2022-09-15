/* ----------------------------------------------------------------------------
Function: fza_fnc_damageEngineFire

Description:
    damageEngineFire

Parameters:
    _heli - The helicopter to modify
    _eng - the engine that has been assigned to burn

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "right"] call fza_fnc_damageEngineFire
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params ["_heli","_eng"];

_rand = random 10;

if (_rand > 5) exitwith {};

private _usesound = false;

if (player == driver _heli || player == gunner _heli) then {
    _usesound = true;
};


_helidamage = 0;
_firepstate = !(_heli getVariable "fza_ah64_firepdisch");
_firerstate = !(_heli getVariable "fza_ah64_firerdisch");

private _side = [];
private _sidef = [];
private _mag = "";
private _audio1 = "";
switch _eng do {
    case "right": {
        _side = [1.2, -0.8, -1.25];
        _sidef = [1.2, -0.6, -1.25];
        _mag = "fza_ah64_e2_fire";
        _audio1 = "fza_ah64_bt_engine2";
    };
    case "left": {
        _side = [-1, -0.8, -1.25];
        _sidef = [-1, -0.6, -1.25];
        _mag = "fza_ah64_e1_fire";
        _audio1 = "fza_ah64_bt_engine1";
    };
    case "apu": {
        _side = [0, -0.8, -1.25];
        _sidef = [0, 0.2, -1.25];
        _mag = "fza_ah64_apu_fire";
        _audio1 = "fza_ah64_bt_apu";
    };
};

if (_heli getVariable _mag) exitwith {};

_heli setVariable[_mag, true, true];
["fza_engineFire", [_heli, _eng]] call CBA_fnc_globalEvent;

if (_usesound) then {
    [_audio1, 1.25, "fza_ah64_bt_fire", 0.65] spawn fza_fnc_playAudio;
};

private _apuState = _heli getVariable "fza_sfmplus_apuState";

while {
    (alive _heli)
}
do {
    _rand = random 10;
    _firepon = _heli getVariable "fza_ah64_firepdisch";
    _fireron = _heli getVariable "fza_ah64_firerdisch";
    if (_eng == "left" && _heli getVariable "fza_ah64_fire1arm" && ((_firepon && _firepstate) || (_fireron && _firerstate))) exitwith {};
    if (_eng == "right" && _heli getVariable "fza_ah64_fire2arm" && ((_firepon && _firepstate) || (_fireron && _firerstate))) exitwith {};
    if (_eng == "apu" && _heli getVariable "fza_ah64_fireapuarm" && ((_firepon && _firepstate) || (_fireron && _firerstate))) exitwith {};
    if (_eng == "left" && (_heli getVariable "fza_sfmplus_engPowerLeverState" select 0 == "off") && _rand > 9.9) exitwith {};
    if (_eng == "right" && (_heli getVariable "fza_sfmplus_engPowerLeverState" select 1 == "off") && _rand > 9.9) exitwith {};
    if (_eng == "apu" && !(_apuState == "ON") && _rand > 9.9) exitwith {};
    _helidamage = _helidamage + 0.0005;
    if (_helidamage > 0.5) then {
        _heli setHit["trans", 1];
    };
    if (_helidamage > 1) then {
        _heli setdamage 1;
    };
    sleep 0.1;
};

["fza_engineFireOut", [_heli, _eng]] call CBA_fnc_globalEvent;
_heli setVariable[_mag, false, true];