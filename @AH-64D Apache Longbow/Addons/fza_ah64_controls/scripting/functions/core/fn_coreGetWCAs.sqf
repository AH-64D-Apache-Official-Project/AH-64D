/* ----------------------------------------------------------------------------
Function: fza_fnc_coreGetWCAs

Description:
    Retrieves a list of the warnings, cautions and advisories for the helicopter returned

Parameters:
    _heli - The apache helicopter to get information from [Unit].

Returns:
    2d array, an array for each active WCA entry in thee format
        [_type, _mpd, _ufd]
    
    * _type - either WCA_CAUTION, WCA_WARNING or WCA_ADVISORY
    * _mpd - the texture to be used by the MPD
    * _ufd - the texture to be used by the UFD

Examples:
    --- Code
    // Helicopter without any issues
    _data = [_heli] call fza_fnc_coreGetWCAs
    // _data = []

    // Helicoper with an engine fire and the rotor brake on
    _data = [_heli] call fza_fnc_coreGetWCAs
    // _data = [[WCA_WARNING, "\fza_ah64_us\tex\MPD\E1Fire.paa"], 
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"

params ["_heli"];

private _configVehicles = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel    = getText (_configVehicles >> "fza_flightModel");

private _mags = _heli weaponsTurret [-1];

private _wcas = [];

///////////////////////////////////////////////////////////////////////////////////////////// 
// System States    /////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// 
//--APU
private _apuBtnOn = _heli getVariable "fza_systems_apuBtnOn";
private _apuOn    = _heli getVariable "fza_systems_apuOn";
private _apuRPM_pct  = _heli getVariable "fza_systems_apuRPM_pct";
private _apuDamage   = _heli getHitPointDamage "hit_apu";
//--FCR
private _fcrDamage   = _heli getHitPointDamage "hit_msnequip_fcr";
//--Generators
private _gen1Damage  = _heli getHitPointDamage "hit_elec_generator1";
private _gen2Damage  = _heli getHitPointDamage "hit_elec_generator2";
//--Rectifiers
private _rect1Damage = _heli getHitPointDamage "hit_elec_rectifier1";
private _rect2Damage = _heli getHitPointDamage "hit_elec_rectifier2";
//--Engine 1
private _eng1PwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select 0;
private _eng1Ng          = _heli getVariable "fza_sfmplus_engPctNG" select 0;
private _eng1State       = _heli getVariable "fza_sfmplus_engState" select 0;
//--Engine 2
private _eng2PwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select 1;
private _eng2Ng          = _heli getVariable "fza_sfmplus_engPctNG" select 1;
private _eng2State       = _heli getVariable "fza_sfmplus_engState" select 1;
//--Rotor RPM
private _pwrLvrAtfly     = false;
private _onGnd           = true;
if (_eng1PwrLvrState == "FLY" || _eng2PwrLvrState == "FLY") then {
    _pwrLvrAtFly = true; 
};
if (getpos _heli # 2 >= 3) then {
    _onGnd = false;
};
private _rtrRPM     = [_heli] call fza_sfmplus_fnc_getRtrRPM;
//--Transmission
private _xmsnDamage = _heli getHitPointDamage "hit_drives_transmission";
//--Tail rotor & Intermediate gearboxes
private _IGBDamage  = _heli getHitPointDamage "hit_drives_intermediategearbox";
private _TGBDamage  = _heli getHitPointDamage "hit_drives_tailrotorgearbox";
//--Nose gearboxes
private _NGB1Damage = _heli getHitPointDamage "hit_drives_nosegearbox1";
private _NGB2Damage = _heli getHitPointDamage "hit_drives_nosegearbox2";
//--Battery
private _battDamage = _heli getHitPointDamage "hit_elec_battery";
//--Stabilator
private _stabDamage = _heli getHitPointDamage "hit_stabilator";
//-Hydraulics
private _priHydPumpDamage    = _heli getHitPointDamage "hit_hyd_pripump";
private _priHydPSI           = _heli getVariable "fza_systems_priHydPsi";
private _priLevel_pct        = _heli getVariable "fza_systems_priLevel_pct";

private _utilHydPumpDamage   = _heli getHitPointDamage "hit_hyd_utilpump";
private _utilHydPSI          = _heli getVariable "fza_systems_utilHydPsi";
private _utilLevel_pct       = _heli getVariable "fza_systems_utilLevel_pct";
///////////////////////////////////////////////////////////////////////////////////////////// 
// WARNINGS         /////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// 
//--APU Warnings
if (_heli getVariable "fza_ah64_apu_fire") then {
    _wcas pushBack [WCA_WARNING, "APU FIRE", ""];
};
//--Engine 1 Out
if (_eng1Ng < 0.63 && !_onGnd) then {
    _wcas pushBack [WCA_WARNING, "ENGINE 1 OUT", "ENG1 OUT  "];
};
//--Engine 1 Fire
if (_heli getVariable "fza_ah64_e1_fire") then {
    _wcas pushBack [WCA_WARNING, "ENGINE 1 FIRE", ""];
};
//--Engine 2 Fire
if (_heli getVariable "fza_ah64_e2_fire") then {
    _wcas pushBack [WCA_WARNING, "ENGINE 2 FIRE", ""];
};
//--Engine 2 Out
if (_eng2Ng < 0.63 && !_onGnd) then {
    _wcas pushBack [WCA_WARNING, "ENGINE 2 OUT", "ENG2 OUT  "];
};
//--Rotor RPM Low
if (!_onGnd && _pwrLvrAtFly && (_rtrRPM < 0.95)) then {
    _wcas pushBack [WCA_WARNING, "LOW ROTOR RPM", "LOW RTR   "];
};
//--Hydraulics
if (_priHydPumpDamage >= SYS_HYD_DMG_THRESH && _utilHydPumpDamage >= SYS_HYD_DMG_THRESH) then {
    _wcas pushBack [WCA_WARNING, "HYD FAILURE", "HYD FAIL  "];
};
if (_priHydPSI < SYS_MIN_HYD_PSI && _utilLevel_pct < SYS_HYD_MIN_LVL) then {
    _wcas pushBack [WCA_WARNING, "TAIL ROTOR HYD", "TAIL RTR  "];
};
///////////////////////////////////////////////////////////////////////////////////////////// 
// CAUTIONS         /////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// 
//--Generator 1 Fail
if (_gen1Damage >= SYS_GEN_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "GENERATOR 1 FAIL", "GEN1 FAIL    "];
};
//--Generator 2 Fail
if (_gen2Damage >= SYS_GEN_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "GENERATOR 2 FAIL", "GEN2 FAIL    "];
};
//--Rectifier 1 Fail
if (_rect1Damage >= SYS_RECT_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "RECTIFIER 1 FAIL", "RECT1 FAIL   "];
};
//--Rectifier 2 Fail
if (_rect2Damage >= SYS_RECT_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "RECTIFIER 2 FAIL", "RECT2 FAIL   "];
};
//--Intermediate and Tail Rotor Gearboxes
if (_IGBDamage >= SYS_IGB_DMG_THRESH || _TGBDamage >= SYS_TGB_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "GEARBOX VIBRATION", "GRBX VIB     "];
};
//--Nose gearbox 1
if (_NGB1Damage >= SYS_NGB_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "GEARBOX 1 CHIPS", "GRBX1 CHIPS  "];
};
//--Nose Gearbox 2
if (_NGB2Damage >= SYS_NGB_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "GEARBOX 2 CHIPS", "GRBX2 CHIPS  "];
};
//--Transmission
if (_xmsnDamage >= SYS_XMSN_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "MAIN XMSN CHIPS", "XMSN CHIPS   "];
};
//--Fuel
if (fuel _heli < 0.05) then {
    _wcas pushBack [WCA_CAUTION, "FORWARD FUEL LOW", "FWD FUEL LO  "];
};
if (fuel _heli >= 0.05 && fuel _heli < 0.1) then {
    _wcas pushBack [WCA_CAUTION, "AFT FUEL LOW", "AFT FUEL LO  "];
};
//--APU
if (_apuOn && getpos _heli # 2 >= 3 && _apuBtnOn) then {
    _wcas pushBack [WCA_CAUTION, "APU ON", "APU ON       "];
};
//--Mission Equipment
if (_heli getHitPointDamage "IrJammer" >= 0.8) then {
    _wcas pushBack [WCA_CAUTION, "IRJAM FAIL", "IRJAM FAIL   "];
};
//--Stabilator
if (_stabDamage >= SYS_STAB_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "AUTO/MAN STAB FAIL", "STAB FAIL    "];
};
//--Hydraulics
if (_priHydPSI < SYS_MIN_HYD_PSI) then {
    _wcas pushBack [WCA_CAUTION, "PRI HYD PSI LOW", "PRI HYD PSI  "];
};
if (_priLevel_pct < SYS_HYD_MIN_LVL) then {
    _wcas pushBack [WCA_CAUTION, "PRI HYD LEVEL LOW", "PRI HYD LVL  "];
};
if (_utilHydPSI < SYS_MIN_HYD_PSI) then {
    _wcas pushBack [WCA_CAUTION, "UTIL HYD PSI LOW", "UTIL HYD PSI "];
};
if (_utilLevel_pct < SYS_HYD_MIN_LVL) then {
    _wcas pushBack [WCA_CAUTION, "UTIL HYD LEVEL LOW", "UTIL HYD LVL "];
};

//--Flight Controls
if (_priHydPumpDamage >= SYS_HYD_DMG_THRESH) then {
    _wcas pushBack [WCA_CAUTION, "BUCS FAIL", "BUCS FAIL    "];
};
if (_priHydPumpDamage >= SYS_HYD_DMG_THRESH) then {
        _wcas pushBack [WCA_CAUTION, "FMC DISENGAGED", "FMC DISENG   "];
};
///////////////////////////////////////////////////////////////////////////////////////////// 
// ADVISORIES       /////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// 
if (_heli animationphase "gdoor" > 0 || _heli animationphase "pdoor" > 0) then {
    _wcas pushBack [WCA_ADVISORY, "CANOPY OPEN", "CANOPY    "];
};
//--Battery
if (_battDamage >= SYS_BATT_DMG_THRESH) then {
    _wcas pushBack [WCA_ADVISORY, "BATTERY", "BATTERY   "];
};
//--APU
if (_apuRPM_pct >= 0.02 && !_apuOn && _apuBtnOn) then {
    _wcas pushBack [WCA_ADVISORY, "APU START", "APU START "];
};
if (_apuRPM_pct >= 0.04 && !_apuOn && _apuBtnOn) then {
    _wcas pushBack [WCA_ADVISORY, "APU POWER ON", "APU PWR ON"];
};
if (_apuOn && getpos _heli # 2 < 3 && _apuBtnOn) then {
    _wcas pushBack [WCA_ADVISORY, "APU ON", "APU ON    "];
};
if (_apuRPM_pct >= 0.5 && !_apuBtnOn) then {
    _wcas pushBack [WCA_ADVISORY, "APU STOP", "APU STOP  "];
};
//--Engine 1
if (_eng1State == "STARTING") then {
    _wcas pushBack [WCA_ADVISORY, "ENGINE 1 START", "ENG1 START"];
};
//--Engine 2
if (_eng2State == "STARTING") then {
    _wcas pushBack [WCA_ADVISORY, "ENGINE 2 START", "ENG2 START"];
};
if (_heli getVariable "fza_ah64_attHoldActive") then {
    _wcas pushBack [WCA_ADVISORY, "ATTITUDE HOLD", "ATT HOLD  "];
};
private _desiredPos = 0.0;
private _curPos     = getPos _heli;
if ( !(_heli getVariable "fza_ah64_attHoldActive") || _heli getVariable "fza_ah64_forceTrimInterupted") then {
    _desiredPos = _curPos;
} else {
    _desiredPos = _heli getVariable "fza_ah64_attHoldDesiredPos";
};
private _dist       = _heli distance2D _desiredPos;
if (_dist >= 14.630) then {
    _wcas pushBack [WCA_ADVISORY, "HOVER DRIFT", "HOVER DRIFT"];
};
if (_heli getVariable "fza_ah64_altHoldActive") then {
    if (_heli getVariable "fza_ah64_altHoldSubMode" == "rad") then {
        _wcas pushBack [WCA_ADVISORY, "RAD ALT HOLD", "RAD HOLD  "];
    } else {
        _wcas pushBack [WCA_ADVISORY, "BAR ALT HOLD", "BAR HOLD  "];
    };
};
if (_heli getVariable "fza_ah64_rtrbrake") then {
    _wcas pushBack [WCA_ADVISORY, "ROTOR BRAKE ON", "RTR BRK ON"];
};
//--FCR 
if (_fcrDamage >= SYS_FCR_DMG_THRESH) then {
    _wcas pushBack [WCA_ADVISORY, "FCR FAULT", "FCR FAULT "];
};

_wcas;