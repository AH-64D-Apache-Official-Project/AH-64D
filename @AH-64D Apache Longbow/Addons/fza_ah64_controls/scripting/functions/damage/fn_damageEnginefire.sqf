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
    [_heli, "right"] spawn fza_fnc_damageEngineFire
    ---

Author:
    Snow(dryden), Mattysmith22
---------------------------------------------------------------------------- */
params ["_heli","_eng"];

_rand = random 10;
if (_rand > 5) exitwith {};
systemchat str _heli;

private _side = [];
private _sidef = [];
private _mag = "";
private _audio1 = "";
switch _eng do {
    case "right": {
        _side = [1.2, -0.8, -1.25];
        _sidef = [1.2, -0.6, -1.25];
        _mag = "fza_ah64_e2_fire";
    };
    case "left": {
        _side = [-1, -0.8, -1.25];
        _sidef = [-1, -0.6, -1.25];
        _mag = "fza_ah64_e1_fire";
    };
    case "apu": {
        _side = [0, -0.8, -1.25];
        _sidef = [0, 0.2, -1.25];
        _mag = "fza_ah64_apu_fire";
    };
};

if (_heli getVariable _mag) exitwith {};

_heli setVariable[_mag, true, true];
["fza_engineFire", [_heli, _eng]] call CBA_fnc_globalEvent;

Private _PrimaryFBAvailable = !(_heli getVariable "fza_ah64_firepdisch");
Private _ReserveFBAvailable = !(_heli getVariable "fza_ah64_firerdisch");
Private _PrimaryFBActioned  = false;
Private _ReserveFBActioned  = false;

while {
    (alive _heli)
}
do { 
	scopeName "fza_fireHandleScope";
    Private _rand = random 10;
    Private _PrimaryFBState = _heli getVariable "fza_ah64_firepdisch";
    Private _ReserveFBState = _heli getVariable "fza_ah64_firerdisch";
    Private _heliDamage = damage _heli;
    if (_PrimaryFBAvailable == _PrimaryFBState) then {
      _PrimaryFBActioned = true;  
    };
    if (_ReserveFBAvailable == _ReserveFBState) then {
      _ReserveFBActioned = true;  
    };
    switch (_eng) do {
        case "left": {
            private _Engine1Arm    = _heli getVariable "fza_ah64_fire1arm";
            private _PowerLevelPos = _heli getVariable "fza_sfmplus_engPowerLeverState" select 0;
            private _engineDamage  = _heli getHitPointDamage "hitengine1";
            if (_Engine1Arm && (_PrimaryFBActioned || _ReserveFBActioned)) then {breakOut  "fza_fireHandleScope"};
            if ((_PowerLevelPos == "off") && _rand >= 9.9) then {breakOut  "fza_fireHandleScope"};
            _heli setHit ["hitengine1", _engineDamage + 0.001];
            if (_engineDamage == 1) then {
                _heli setdamage _heliDamage + 0.001;
            };
        };
        case "right": {
            private _Engine2Arm    = _heli getVariable "fza_ah64_fire2arm";
            private _PowerLevelPos = _heli getVariable "fza_sfmplus_engPowerLeverState" select 1;
            private _engineDamage  = _heli getHitPointDamage "hitengine2";
            if (_Engine2Arm && (_PrimaryFBActioned || _ReserveFBActioned)) then {breakOut  "fza_fireHandleScope"};
            if ((_PowerLevelPos == "off") && _rand >= 9.9) then {breakOut  "fza_fireHandleScope"};
            systemchat "2";
            _heli setHit ["hitengine2", _engineDamage + 0.001];
            if (_engineDamage == 1) then {
                _heli setdamage _heliDamage + 0.001;
            };
        };
        case "apu": {
            private _apuArm    = _heli getVariable "fza_ah64_fireapuarm";
            private _apuOn     = _heli getVariable "fza_systems_apuOn";
            private _apuDamage = _heli getHitPointDamage "hit_apu";
            if (_apuArm && (_PrimaryFBActioned || _ReserveFBActioned)) then {breakOut  "fza_fireHandleScope"};
            if (!_apuOn && _rand >= 9.9) then {breakOut  "fza_fireHandleScope"};
            _heli setHit ["hit_apu", _apuDamage + 0.001];
            if (_apuDamage == 1) then {
                _heli setdamage _heliDamage + 0.001;
            };
        };
    };
    sleep 0.1;
};

["fza_engineFireOut", [_heli, _eng]] call CBA_fnc_globalEvent;
_heli setVariable[_mag, false, true];