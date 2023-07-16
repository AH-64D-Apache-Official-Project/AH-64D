/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_update

Description:
    handles the perframe fire panel Logic

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _battBusOn          = _heli getVariable "fza_systems_battBusOn";
Private _engineOneArm       = _heli getVariable "fza_ah64_fireArmed1";
Private _engineTwoArm       = _heli getVariable "fza_ah64_fireArmed2";
Private _engineApuArm       = _heli getVariable "fza_ah64_fireArmedApu";
Private _PrimaryFBDispensed = _heli getVariable "fza_ah64_firepdisch";
Private _ReserveFBDispensed = _heli getVariable "fza_ah64_firerdisch";
Private _engineOneFire      = _heli getVariable "fza_ah64_e1_fire";
Private _engineTwoFire      = _heli getVariable "fza_ah64_e2_fire";
Private _engineApuFire      = _heli getVariable "fza_ah64_apu_fire";

if !_battBusOn exitwith {
    _heli setVariable ["fza_ah64_fireArmed1", [false, 0, CBA_missionTime], true];
    _heli setVariable ["fza_ah64_fireArmed2", [false, 0, CBA_missionTime], true];
    _heli setVariable ["fza_ah64_fireArmedApu", [false, 0, CBA_missionTime], true];
    //FIRE Arm
    _heli setObjectTexture ["in_lt_fire1rdy", ""];
    _heli setObjectTexture ["in_lt_fire2rdy", ""];
    _heli setObjectTexture ["in_lt_fireapurdy", ""];
    //FIRE Detected
    _heli setObjectTexture ["in_lt_fire1", ""];
    _heli setObjectTexture ["in_lt_fire2", ""];
    _heli setObjectTexture ["in_lt_fireapu", ""];
    //Fire bottle Dispensed
    _heli setObjectTexture ["in_lt_firepdis", ""];
    _heli setObjectTexture ["in_lt_firerdis", ""];
};

if (_engineOneArm #0 && _engineOneArm #2 <= CBA_missionTime - 2) then {
    [_heli, "fza_sfmplus_engState", 0, "OFF", true] call fza_fnc_setArrayVariable;
};
if (_engineTwoArm #0 && _engineTwoArm #2 <= CBA_missionTime - 2) then {
    [_heli, "fza_sfmplus_engState", 1, "OFF", true] call fza_fnc_setArrayVariable;
};
if (_engineApuArm #0 && _engineApuArm #2 <= CBA_missionTime - 2) then {
    _heli setVariable ["fza_systems_apuBtnOn", false];
};

//Fire test switch
if (fza_ah64_firetest == 1) exitwith {
    _heli setobjecttexture ["in_lt_fire1", "\fza_ah64_us\tex\in\pushbut.paa"];
    _heli setobjecttexture ["in_lt_fire2", "\fza_ah64_us\tex\in\pushbut.paa"];
    _heli setobjecttexture ["in_lt_fireapu", "\fza_ah64_us\tex\in\pushbut.paa"];
};
if (fza_ah64_firetest == 2) exitwith {
    _heli setobjecttexture ["in_lt_fire1", "\fza_ah64_us\tex\in\pushbut.paa"];
    _heli setobjecttexture ["in_lt_fire2", "\fza_ah64_us\tex\in\pushbut.paa"];
    _heli setobjecttexture ["in_lt_fireapu", "\fza_ah64_us\tex\in\pushbut.paa"];
    _heli setobjecttexture ["in_lt_firepdis", "\fza_ah64_us\tex\in\pushbut.paa"];
    _heli setobjecttexture ["in_lt_firerdis", "\fza_ah64_us\tex\in\pushbut.paa"];
};

//FIRE Arm
_heli setObjectTexture ["in_lt_fire1rdy", ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _engineOneArm #0];
_heli setObjectTexture ["in_lt_fire2rdy", ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _engineTwoArm #0];
_heli setObjectTexture ["in_lt_fireapurdy", ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _engineApuArm #0];
//FIRE Detected
_heli setObjectTexture ["in_lt_fire1", ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _engineOneFire];
_heli setObjectTexture ["in_lt_fire2", ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _engineTwoFire];
_heli setObjectTexture ["in_lt_fireapu", ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _engineOneFire];
//Fire bottle Dispensed
_heli setObjectTexture ["in_lt_firepdis", ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _PrimaryFBDispensed];
_heli setObjectTexture ["in_lt_firerdis", ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _ReserveFBDispensed];