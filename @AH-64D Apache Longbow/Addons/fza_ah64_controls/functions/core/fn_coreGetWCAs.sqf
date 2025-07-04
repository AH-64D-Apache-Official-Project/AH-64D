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
    // _data = [[WCA_WARNING, "\fza_ah64_model\tex\MPD\E1Fire.paa"], 
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

#define HYD_FAIL_PRIORITY          1
#define OVRSPD_PRIORITY            1
#define RTR_RPM_PRIORITY           2
#define ENG_OUT_PRIORITY           3
#define FIRE_PRIORITY              4

private _configVehicles = configFile >> "CfgVehicles" >> typeof _heli;

private _mags = _heli weaponsTurret [-1];

private _wcas       = [];
private _activeCaut = _heli getVariable "fza_ah64_activeCaut";
private _activeWarn = _heli getVariable "fza_ah64_activeWarn";
private _acBusOn    = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn    = _heli getVariable "fza_systems_dcBusOn";
///////////////////////////////////////////////////////////////////////////////////////////// 
// System States    /////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// 
private _playCautAudio = false;
//--APU
private _apuBtnOn    = _heli getVariable "fza_systems_apuBtnOn";
private _apuOn       = _heli getVariable "fza_systems_apuOn";
private _apuRPM_pct  = _heli getVariable "fza_systems_apuRPM_pct";
private _apuDamage   = _heli getHitPointDamage "hit_apu";
//--FCR
private _fcrState    = _heli getVariable "fza_ah64_fcrState";
//--Generators
private _gen1Damage  = _heli getHitPointDamage "hit_elec_generator1";
private _gen2Damage  = _heli getHitPointDamage "hit_elec_generator2";
//--Rectifiers
private _rect1Damage = _heli getHitPointDamage "hit_elec_rectifier1";
private _rect2Damage = _heli getHitPointDamage "hit_elec_rectifier2";
//--Engine 1
private _eng1PwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select 0;
private _eng1Ng          = _heli getVariable "fza_sfmplus_engPctNG" select 0;
private _eng1Np          = _heli getVariable "fza_sfmplus_engPctNP" select 0;
private _eng1State       = _heli getVariable "fza_sfmplus_engState" select 0;
//--Engine 2
private _eng2PwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select 1;
private _eng2Ng          = _heli getVariable "fza_sfmplus_engPctNG" select 1;
private _eng2Np          = _heli getVariable "fza_sfmplus_engPctNP" select 1;
private _eng2State       = _heli getVariable "fza_sfmplus_engState" select 1;
//--Rotor RPM
private _pwrLvrAtfly     = false;
private _onGnd           = [_heli] call fza_sfmplus_fnc_onGround;
if (_eng1PwrLvrState == "FLY" || _eng2PwrLvrState == "FLY") then {
    _pwrLvrAtFly = true; 
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
//ASE
private _msnEquipState       = _heli getVariable "fza_ah64_ase_msnEquipPwr";

///////////////////////////////////////////////////////////////////////////////////////////// 
// WARNINGS         /////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// 
//--APU Warnings
if (_heli getVariable "fza_ah64_apu_fire") then {
    ([_heli, _activeWarn, "APU FIRE", "", FIRE_PRIORITY, "fza_ah64_APU_fire", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "APU FIRE"] call fza_wca_fnc_wcaDelWarning;
};

//--Engine 1 Out
if (_eng1Ng < 0.63 && _eng1PwrLvrState == "FLY") then {
    ([_heli, _activeWarn, "ENGINE 1 OUT", "ENG1 OUT", ENG_OUT_PRIORITY, "fza_ah64_engine_1_out", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "ENGINE 1 OUT"] call fza_wca_fnc_wcaDelWarning;
};
//--Engine 1 Fire
if (_heli getVariable "fza_ah64_e1_fire") then {
    ([_heli, _activeWarn, "ENGINE 1 FIRE", "", FIRE_PRIORITY, "fza_ah64_engine_1_fire", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "ENGINE 1 FIRE"] call fza_wca_fnc_wcaDelWarning;
};
//--Engine 1 Overspeed
if (_eng1Np >= 1.15) then {
    ([_heli, _activeWarn, "ENG1 OVSP", "ENG1 OVSP", OVRSPD_PRIORITY, "fza_ah64_engine_1_overspeed", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "ENG1 OVSP"] call fza_wca_fnc_wcaDelWarning;
};
//--Engine 2 Out
if (_eng2Ng < 0.63 && _eng2PwrLvrState == "FLY") then {
    ([_heli, _activeWarn, "ENGINE 2 OUT", "ENG2 OUT", ENG_OUT_PRIORITY, "fza_ah64_engine_2_out", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "ENGINE 2 OUT"] call fza_wca_fnc_wcaDelWarning;
};
//--Engine 2 Fire
if (_heli getVariable "fza_ah64_e2_fire") then {
    ([_heli, _activeWarn, "ENGINE 2 FIRE", "", FIRE_PRIORITY, "fza_ah64_engine_2_fire", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "ENGINE 2 FIRE"] call fza_wca_fnc_wcaDelWarning;
};
//--Aft Deck fire
if (_heli getVariable "fza_ah64_aft_deck_fire") then {
    _wcas pushBack [WCA_WARNING, "AFT DECK FIRE", "DECK FIRE"];
};

//--Engine 2 Overspeed
if (_eng2Np >= 1.15) then {
    ([_heli, _activeWarn, "ENG2 OVSP", "ENG2 OVSP", OVRSPD_PRIORITY, "fza_ah64_engine_2_overspeed", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "ENG2 OVSP"] call fza_wca_fnc_wcaDelWarning;
};
//--Rotor RPM Low
if (!_onGnd && (_rtrRPM < 0.95)) then {
    ([_heli, _activeWarn, "LOW ROTOR RPM", "LOW RTR", RTR_RPM_PRIORITY, "fza_ah64_rotor_rpm_low", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "LOW ROTOR RPM"] call fza_wca_fnc_wcaDelWarning;
    if ("fza_ah64_rotor_rpm_low" in (_heli getVariable "fza_audio_warning_message")) then {
        [_heli] call fza_audio_fnc_delwarning;
        [_heli, "fza_ah64_mstrWarnLightOn", false] call fza_fnc_updateNetworkGlobal;
    };
};
//--Rotor RPM High
if (_rtrRPM > 1.06) then {
    ([_heli, _activeWarn, "HIGH ROTOR RPM", "HIGH RTR", RTR_RPM_PRIORITY, "fza_ah64_rotor_rpm_high", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "HIGH ROTOR RPM"] call fza_wca_fnc_wcaDelWarning;
    if ("fza_ah64_rotor_rpm_high" in (_heli getVariable "fza_audio_warning_message")) then {
        [_heli] call fza_audio_fnc_delwarning;
        [_heli, "fza_ah64_mstrWarnLightOn", false] call fza_fnc_updateNetworkGlobal;
    };
};
//--Hydraulics
if (_priHydPumpDamage >= SYS_HYD_DMG_THRESH && _utilHydPumpDamage >= SYS_HYD_DMG_THRESH) then {
    ([_heli, _activeWarn, "HYD FAILURE", "HYD FAIL", HYD_FAIL_PRIORITY, "fza_ah64_hydraulic_failure", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "HYD FAILURE"] call fza_wca_fnc_wcaDelWarning;
};
if (_priHydPSI < SYS_MIN_HYD_PSI && _utilLevel_pct < SYS_HYD_MIN_LVL) then {
    ([_heli, _activeWarn, "TAIL ROTOR HYD", "TAIL RTR", HYD_FAIL_PRIORITY, "fza_ah64_tail_rotor_hydraulic_failure", 3] call fza_wca_fnc_wcaAddWarning)
        params ["_wcaAddWarning"];
    
    _wcas pushBack _wcaAddWarning;
} else {
    [_activeWarn, "TAIL ROTOR HYD"] call fza_wca_fnc_wcaDelWarning;
};
///////////////////////////////////////////////////////////////////////////////////////////// 
// CAUTIONS         /////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// 
//--Generator 1 Fail
if (_gen1Damage >= SYS_GEN_DMG_THRESH) then {
    ([_heli, _activeCaut, "GENERATOR 1 FAIL", "GEN1 FAIL", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "GEN1 FAIL"] call fza_wca_fnc_wcaDelCaution;
};
//--Generator 2 Fail
if (_gen2Damage >= SYS_GEN_DMG_THRESH) then {
    ([_heli, _activeCaut, "GENERATOR 2 FAIL", "GEN2 FAIL", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "GEN2 FAIL"] call fza_wca_fnc_wcaDelCaution;
};
//--Rectifier 1 Fail
if (_rect1Damage >= SYS_RECT_DMG_THRESH) then {
    ([_heli, _activeCaut, "RECTIFIER 1 FAIL", "RECT1 FAIL", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "RECT1 FAIL"] call fza_wca_fnc_wcaDelCaution;
};
//--Rectifier 2 Fail
if (_rect2Damage >= SYS_RECT_DMG_THRESH) then {
    ([_heli, _activeCaut, "RECTIFIER 2 FAIL", "RECT2 FAIL", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "RECT2 FAIL"] call fza_wca_fnc_wcaDelCaution;
};
//--Intermediate and Tail Rotor Gearboxes
if (_IGBDamage >= SYS_IGB_DMG_THRESH || _TGBDamage >= SYS_TGB_DMG_THRESH) then {
    ([_heli, _activeCaut, "GEARBOX VIBRATION", "GRBX VIB", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "GRBX VIB"] call fza_wca_fnc_wcaDelCaution;
};
//--Nose gearbox 1
if (_NGB1Damage >= SYS_NGB_DMG_THRESH) then {
     ([_heli, _activeCaut, "GEARBOX 1 CHIPS", "GRBX1 CHIPS", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "GRBX1 CHIPS"] call fza_wca_fnc_wcaDelCaution;
};
//--Nose Gearbox 2
if (_NGB2Damage >= SYS_NGB_DMG_THRESH) then {
     ([_heli, _activeCaut, "GEARBOX 2 CHIPS", "GRBX2 CHIPS", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "GRBX2 CHIPS"] call fza_wca_fnc_wcaDelCaution;
};
//--Transmission
if (_xmsnDamage >= SYS_XMSN_DMG_THRESH) then {
    ([_heli, _activeCaut, "MAIN XMSN CHIPS", "XMSN CHIPS", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "XMSN CHIPS"] call fza_wca_fnc_wcaDelCaution;
};
//--Fuel
if (fuel _heli < 0.05) then {
    ([_heli, _activeCaut, "FORWARD FUEL LOW", "FWD FUEL LO", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "FWD FUEL LO"] call fza_wca_fnc_wcaDelCaution;
};
if (fuel _heli >= 0.05 && fuel _heli < 0.1) then {
    ([_heli, _activeCaut, "AFT FUEL LOW", "AFT FUEL LO", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "AFT FUEL LO"] call fza_wca_fnc_wcaDelCaution;
};
//--APU
if (_apuOn && !_onGnd && _apuBtnOn) then {
    ([_heli, _activeCaut, "APU ON", "APU ON", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "APU ON"] call fza_wca_fnc_wcaDelCaution;
};
//--Stabilator
if (_stabDamage >= SYS_STAB_DMG_THRESH) then {
    ([_heli, _activeCaut, "AUTO/MAN STAB FAIL", "STAB FAIL", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "STAB FAIL"] call fza_wca_fnc_wcaDelCaution;
};
//--Hydraulics
if (_priHydPSI < SYS_MIN_HYD_PSI) then {
    ([_heli, _activeCaut, "PRI HYD PSI LOW", "PRI HYD PSI", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "PRI HYD PSI"] call fza_wca_fnc_wcaDelCaution;
};
if (_priLevel_pct < SYS_HYD_MIN_LVL) then {
    ([_heli, _activeCaut, "PRI HYD LEVEL LOW", "PRI HYD LVL", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "PRI HYD LVL"] call fza_wca_fnc_wcaDelCaution;
};
if (_utilHydPSI < SYS_MIN_HYD_PSI) then {
    ([_heli, _activeCaut, "UTIL HYD PSI LOW", "UTIL HYD PSI", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "UTIL HYD PSI"] call fza_wca_fnc_wcaDelCaution;
};
if (_utilLevel_pct < SYS_HYD_MIN_LVL) then {
    ([_heli, _activeCaut, "UTIL HYD LEVEL LOW", "UTIL HYD LVL", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "UTIL HYD LVL"] call fza_wca_fnc_wcaDelCaution;
};
//--Flight Controls
if (_priHydPumpDamage >= SYS_HYD_DMG_THRESH) then {
    ([_heli, _activeCaut, "BUCS FAIL", "BUCS FAIL", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "BUCS FAIL"] call fza_wca_fnc_wcaDelCaution;
};
if (_priHydPumpDamage >= SYS_HYD_DMG_THRESH
    || !(_heli getVariable "fza_ah64_fmcPitchOn")
    || !(_heli getVariable "fza_ah64_fmcRollOn")
    || !(_heli getVariable "fza_ah64_fmcYawOn")
    || !(_heli getVariable "fza_ah64_fmcCollOn")) then {
        ([_heli, _activeCaut, "FMC DISENGAGED", "FMC DISENG", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "FMC DISENG"] call fza_wca_fnc_wcaDelCaution;
};

if (_playCautAudio) then {
    [_heli] call fza_audio_fnc_addCaution;
};
//ASE
if ((!_dcBusOn || _heli getHitPointDamage "hit_msnEquip_irJam" >= SYS_ASE_DMG_THRESH) && _MsnEquipState == ASE_MSNEQUIP_STATE_ON && _heli animationPhase "msn_equip_american" == 1) then {
        ([_heli, _activeCaut, "IRJAM FAIL", "IRJAM FAIL", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "IRJAM FAIL"] call fza_wca_fnc_wcaDelCaution;
};
///////////////////////////////////////////////////////////////////////////////////////////// 
// ADVISORIES       /////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// 
if (_heli animationphase "gdoor" > 0 || _heli animationphase "pdoor" > 0) then {
    _wcas pushBack [WCA_ADVISORY, "CANOPY OPEN", "CANOPY"];
};
//--Battery
if (_battDamage >= SYS_BATT_DMG_THRESH) then {
    _wcas pushBack [WCA_ADVISORY, "BATTERY", "BATTERY"];
};
//--APU
if (_apuRPM_pct >= 0.02 && !_apuOn && _apuBtnOn) then {
    _wcas pushBack [WCA_ADVISORY, "APU START", "APU START"];
};
if (_apuRPM_pct >= 0.04 && !_apuOn && _apuBtnOn) then {
    _wcas pushBack [WCA_ADVISORY, "APU POWER ON", "APU PWR ON"];
};
if (_apuOn && _onGnd && _apuBtnOn) then {
    _wcas pushBack [WCA_ADVISORY, "APU ON", "APU ON"];
};
if (_apuRPM_pct >= 0.5 && !_apuBtnOn) then {
    _wcas pushBack [WCA_ADVISORY, "APU STOP", "APU STOP"];
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
    _wcas pushBack [WCA_ADVISORY, "ATTITUDE HOLD", "ATT HOLD"];
};
private _desiredPos = 0.0;
private _curPos     = getPos _heli;
if ( !(_heli getVariable "fza_ah64_attHoldActive") || _heli getVariable "fza_ah64_forceTrimInterupted") then {
    _desiredPos = _curPos;
} else {
    _desiredPos = _heli getVariable "fza_ah64_attHoldDesiredPos";
};
private _dist           = _heli distance2D _desiredPos;
private _attHoldSubMode =_heli getVariable "fza_ah64_attHoldSubMode";
if (_dist >= 14.630 && _attHoldSubMode == "POS") then {
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
if (_fcrState#0 == FCR_MODE_FAULT) then {
    _wcas pushBack [WCA_ADVISORY, "FCR FAULT", "FCR FAULT"];
};
if (_onGnd) then {
    _wcas pushBack [WCA_ADVISORY, "TAIL WHEEL LOCk SEL", "TW LOCK SEL"];
};

private _wptAprch = _heli getvariable "fza_ah64_wptAprch";
private _wptPassed = _heli getvariable "fza_ah64_wptpassed";
private _pltMpd = _heli getVariable "fza_mpd_page_plt";
private _cpgMpd = _heli getVariable "fza_mpd_page_cpg";
if (!("tsd" in _pltMpd || "tsd" in _cpgMpd) && _wptAprch#1) then {
    _wcas pushBack [WCA_ADVISORY, "WAYPOINT APPROACH", "WPT APRCH"];
};
if (!("tsd" in _pltMpd || "tsd" in _cpgMpd) && _wptPassed) then {
    _wcas pushBack [WCA_ADVISORY, "WAYPOINT PASSED", "WPT PASSED"];
};

_wcas;