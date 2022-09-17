/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsElectricalGenController
Description:
	Updates all of the modules core functions.
	
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
#include "\fza_ah64_sfmplus\headers\systems.hpp"

//APU
private _apuState    = _heli getVariable "fza_sfmplus_apuState";

//Engine 1
private _eng1State   = _heli getVariable "fza_sfmplus_engState" select 0;
private _eng1PctNP   = _heli getVariable "fza_sfmplus_engPctNP" select 0;
//Engine 2
private _eng2State   = _heli getVariable "fza_sfmplus_engState" select 1;
private _eng2PctNP   = _heli getVariable "fza_sfmplus_engPctNP" select 1;

//Generator & RTRU 1
private _gen1State   = _heli getVariable "fza_sfmplus_gen1State";
private _gen1Damage  = _heli getHitPointDamage "hit_elec_generator1";
private _rect1State  = _heli getVariable "fza_sfmplus_rect1State";
private _rect1Damage = _heli getHitPointDamage "hit_elec_rectifier1";

//Generator & RTRU 2
private _gen2State   = _heli getVariable "fza_sfmplus_gen2State";
private _gen2Damage  = _heli getHitPointDamage "hit_elec_generator2";
private _rect2State  = _heli getVariable "fza_sfmplus_rect2State";
private _rect2Damage = _heli getHitPointDamage "hit_elec_rectifier2";

//Set generator states <-- NP needs to eventually be replaced with NR
if (_apuState == "ON" || (_eng1State == "ON" && _eng1PctNP > SYS_MIN_RPM) || (_eng2State == "ON" && _eng2PctNP > SYS_MIN_RPM)) then {
    //Generator 1
    if (_gen1Damage <= SYS_GEN_DMG_VAL) then {
        _gen1State = "ON";
    } else {
        _gen1State = "OFF";
    };
    //Generator 2
    if (_gen2Damage <= SYS_GEN_DMG_VAL) then {
        _gen2State = "ON";
    } else {
        _gen2State = "OFF";
    };
} else {
    _gen1State = "OFF";
    _gen2State = "OFF";
};
_heli setVariable ["fza_sfmplus_gen1State", _gen1State];
_heli setVariable ["fza_sfmplus_gen2State", _gen2State];

//Set RTRU 1 state
if (_gen1State == "ON" && _rect1Damage <= SYS_RECT_DMG_VAL) then {
    _rect1State = "ON";
} else {
    _rect1State = "OFF";
};
_heli setVariable ["fza_sfmplus_rect1State", _rect1State];

//Set RTRU 2 state
if (_gen2State == "ON" && _rect2Damage <= SYS_RECT_DMG_VAL) then {
    _rect2State = "ON";
} else {
    _rect2State = "OFF";
};
_heli setVariable ["fza_sfmplus_rect2State", _rect2State];

//AC Bus
private _ACBusState = _heli getVariable "fza_sfmplus_ACBusState";
if (_gen1State == "ON" || _gen2State == "ON") then {
    _ACBusState = "ON";
} else {
    _ACBusState = "OFF";
};
_heli setVariable ["fza_sfmplus_ACBusState", _ACBusState];
//AC Bus powers the following
//--(1) FCR
//--(5) 30mm motor
//--(5) Anti-collision/formation lights
//--(5) Laser electronics unit
//--(5) PLT left hand MPD
//--(5) IHADSS SEU
//--(5) CPG right hand MPD
//--(5) TADS power supply
//--(6) IHADSS DEU
//--(6) ORT
//--(6) CPG left hand MPD
//--(6) PLT right hand MPD
//--(6) Battery charger

//DC Bus
private _DCBusState = _heli getVariable "fza_sfmplus_DCBusState";
if (_rect1State == "ON" || _rect2State == "ON") then {
    _DCBusState = "ON";
} else {
    _DCBusState = "OFF";
};
_heli setVariable ["fza_sfmplus_DCBusState", _DCBusState];
//DC Bus powers the following
//--(1) PSP/LPRF (FCR)
//--(3) Radar warning receiver
//--(3) CHAFF arm
//--(5) CPG primary lighting
//--(5) PLT primary lighting
//--(4) IHADSS DEU power
//--(4) IHADSS SEU power
//--(4) Radar altimeter power
//--(4) 30mm arm (power)
//--(6) Navigation lights/anti-collision
//--(6) Stabilator control