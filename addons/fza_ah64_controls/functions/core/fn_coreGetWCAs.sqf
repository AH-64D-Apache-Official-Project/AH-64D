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
#include "\bmkhs_helisim\functions\systems\systems.hpp"
#include "\bmkhs_helisim\functions\core\core.hpp"
#include "\bmkhs_helisim\functions\fuel\fuel.hpp"
#include "\fza_ah64_ase\headers\ase.h"

params ["_heli"];

#define SYSTEM_PRIORITY            0
#define HYD_FAIL_PRIORITY          1
#define OVRSPD_PRIORITY            1
#define RTR_RPM_PRIORITY           2
#define ENG_OUT_PRIORITY           3
#define FIRE_PRIORITY              4

private _configVehicles = configOf _heli;

private _mags = _heli weaponsTurret [-1];

private _wcas       = [];
private _activeCaut = _heli getVariable "fza_ah64_activeCaut";
private _activeWarn = _heli getVariable "fza_ah64_activeWarn";
private _acBusOn    = _heli getVariable "bmkhs_acBusOn";
private _dcBusOn    = _heli getVariable "bmkhs_dcBusOn";
/////////////////////////////////////////////////////////////////////////////////////////////
// System States    /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _playCautAudio = false;
//--APU
private _apuBtnOn    = _heli getVariable "bmkhs_apuBtnOn";
private _apuOn       = _heli getVariable "bmkhs_apuOn";
private _apuRPM_pct  = _heli getVariable "bmkhs_apuRPM_pct";
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
private _eng1PwrLvrState = _heli getVariable "bmkhs_engPowerLeverState" select 0;
private _eng1Ng          = _heli getVariable "bmkhs_engPctNg" select 0;
private _eng1Np          = _heli getVariable "bmkhs_engPctNp" select 0;
private _eng1State       = _heli getVariable "bmkhs_engState" select 0;
//--Engine 2
private _eng2PwrLvrState = _heli getVariable "bmkhs_engPowerLeverState" select 1;
private _eng2Ng          = _heli getVariable "bmkhs_engPctNg" select 1;
private _eng2Np          = _heli getVariable "bmkhs_engPctNp" select 1;
private _eng2State       = _heli getVariable "bmkhs_engState" select 1;
//--Engine oil and chips
private _engChips        = _heli getVariable "bmkhs_engChips";
private _engOilPsiLow    = _heli getVariable "bmkhs_engOilPsiLow";
private _engNgMin        = (_heli getVariable "bmkhs_engines") apply {_x get "ngMin"};
private _engFailed       = _heli getVariable "bmkhs_engFailed";
//--Rotor RPM
private _pwrLvrAtfly     = false;
private _onGnd           = [_heli] call bmkhs_fnc_stateOnGround;
if (_eng1PwrLvrState == "FLY" || _eng2PwrLvrState == "FLY") then {
    _pwrLvrAtFly = true;
};

private _rtrRPM     = [_heli] call bmkhs_fnc_stateRtrRPM;
private _nrLimits   = _heli getVariable "bmkhs_nrLimits";
//--Transmission
private _xmsnDamage = _heli getHitPointDamage "hit_drives_transmission";
//--Tail rotor & Intermediate gearboxes
private _IGBDamage  = _heli getHitPointDamage "hit_drives_intermediateGearbox";
private _TGBDamage  = _heli getHitPointDamage "hit_drives_tailRotorGearbox";
//--Nose gearboxes
private _NGB1Damage = _heli getHitPointDamage "hit_drives_noseGearbox1";
private _NGB2Damage = _heli getHitPointDamage "hit_drives_noseGearbox2";
//--Battery
private _battDamage = _heli getHitPointDamage "hit_elec_battery";
//--Stabilator
private _stabDamage = _heli getHitPointDamage "hit_stabilator";
//-Hydraulics
private _priHydPumpDamage    = _heli getHitPointDamage "hit_hyd_priPump";
private _priHydPSI           = _heli getVariable "bmkhs_priHydPsi";
private _priLevel_pct        = _heli getVariable "bmkhs_priLevel_pct";

private _utilHydPumpDamage   = _heli getHitPointDamage "hit_hyd_utilPump";
private _utilHydPSI          = _heli getVariable "bmkhs_utilHydPsi";
private _accHydPSI           = _heli getVariable ["bmkhs_accHydPsi", SYS_MIN_ACC_PSI];
private _utilLevel_pct       = _heli getVariable "bmkhs_utilLevel_pct";
//ASE
private _msnEquipState       = _heli getVariable "fza_ah64_ase_msnEquipPwr";

private _pylonMagazines = getPylonMagazines _heli;
private _fwdFuelMass = _heli getVariable ["bmkhs_fwdTankMass", 0];
private _aftFuelMass = _heli getVariable ["bmkhs_aftTankMass", 0];
private _auxTank1FuelMass = _heli getVariable ["bmkhs_stn1TankMass", 0];
private _auxTank2FuelMass = _heli getVariable ["bmkhs_stn2TankMass", 0];
private _auxTank3FuelMass = _heli getVariable ["bmkhs_stn3TankMass", 0];
private _auxTank4FuelMass = _heli getVariable ["bmkhs_stn4TankMass", 0];


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

//An engine that is off or still spooling has not failed - it is not running yet. The
//engine flips to ON at engRunNG, which is BELOW this warning threshold, so a starting
//engine passes through the window legitimately; requiring it to have reached running
//speed first is what stops the momentary annunciation on every start.
//Latched, so an engine that HAS reached running speed still warns when it falls back
//below - the point is to skip the window on the way up, not to suppress a real failure.
private _eng1Cmd = _heli getVariable ["bmkhs_eng1Ran", false];
private _eng2Cmd = _heli getVariable ["bmkhs_eng2Ran", false];
if (_eng1State == "OFF") then { _eng1Cmd = false };
if (_eng2State == "OFF") then { _eng2Cmd = false };
if (_eng1State == "ON" && {_eng1Ng >= (_engNgMin select 0)}) then { _eng1Cmd = true };
if (_eng2State == "ON" && {_eng2Ng >= (_engNgMin select 1)}) then { _eng2Cmd = true };
_heli setVariable ["bmkhs_eng1Ran", _eng1Cmd];
_heli setVariable ["bmkhs_eng2Ran", _eng2Cmd];

//--Engine 1 Out
if ((_eng1Cmd && _eng1Ng < (_engNgMin select 0) && _eng1PwrLvrState == "FLY") || (_engFailed select 0)) then {
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
if ((_eng2Cmd && _eng2Ng < (_engNgMin select 1) && _eng2PwrLvrState == "FLY") || (_engFailed select 1)) then {
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
if (!_onGnd && (_rtrRPM < (_nrLimits select 0))) then {
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
if (_rtrRPM >= (_nrLimits select 2)) then {
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
if (_NGB1Damage >= 0.50) then {
     ([_heli, _activeCaut, "GRBX 1 OIL PSI LOW", "GRBX1 OIL PSI", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "GRBX1 OIL PSI"] call fza_wca_fnc_wcaDelCaution;
};
if (_NGB1Damage >= 0.75) then {
     ([_heli, _activeCaut, "GEARBOX 1 CHIPS", "GRBX1 CHIPS", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "GRBX1 CHIPS"] call fza_wca_fnc_wcaDelCaution;
};
//--Nose Gearbox 2
if (_NGB2Damage >= 0.50) then {
     ([_heli, _activeCaut, "GRBX 2 OIL PSI LOW", "GRBX2 OIL PSI", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "GRBX2 OIL PSI"] call fza_wca_fnc_wcaDelCaution;
};
if (_NGB2Damage >= 0.75) then {
     ([_heli, _activeCaut, "GEARBOX 2 CHIPS", "GRBX2 CHIPS", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "GRBX2 CHIPS"] call fza_wca_fnc_wcaDelCaution;
};
//--Transmission
if (_xmsnDamage >= 0.50) then {
    ([_heli, _activeCaut, "XMSN 1 OIL PSI LOW", "XMSN1 OIL PSI", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "XMSN1 OIL PSI"] call fza_wca_fnc_wcaDelCaution;
};
if (_xmsnDamage >= 0.63) then {
    ([_heli, _activeCaut, "XMSN 2 OIL PSI LOW", "XMSN2 OIL PSI", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "XMSN2 OIL PSI"] call fza_wca_fnc_wcaDelCaution;
};
if (_xmsnDamage >= 0.75) then {
    ([_heli, _activeCaut, "MAIN XMSN CHIPS", "XMSN CHIPS", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "XMSN CHIPS"] call fza_wca_fnc_wcaDelCaution;
};
//--Engine 1
if (_engChips select 0) then {
    ([_heli, _activeCaut, "ENGINE 1 CHIPS", "ENG1 CHIPS", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "ENG1 CHIPS"] call fza_wca_fnc_wcaDelCaution;
};
if (_engOilPsiLow select 0) then {
    ([_heli, _activeCaut, "ENG 1 OIL PSI LOW", "ENG1 OIL PSI", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "ENG1 OIL PSI"] call fza_wca_fnc_wcaDelCaution;
};
//--Engine 2
if (_engChips select 1) then {
    ([_heli, _activeCaut, "ENGINE 2 CHIPS", "ENG2 CHIPS", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "ENG2 CHIPS"] call fza_wca_fnc_wcaDelCaution;
};
if (_engOilPsiLow select 1) then {
    ([_heli, _activeCaut, "ENG 2 OIL PSI LOW", "ENG2 OIL PSI", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "ENG2 OIL PSI"] call fza_wca_fnc_wcaDelCaution;
};
//--Fuel low cautions
if (_fwdFuelMass < (_heli getVariable "bmkhs_fwdTankLow")) then {
    ([_heli, _activeCaut, "FORWARD FUEL LOW", "FWD FUEL LO", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];
    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "FWD FUEL LO"] call fza_wca_fnc_wcaDelCaution;
};
if (_aftFuelMass < (_heli getVariable "bmkhs_aftTankLow")) then {
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
//On the ground, no pressure is expected until whatever turns the pumps is up to speed -
//that covers both a cold aircraft and one still spooling. Airborne they always apply.
private _accyDrive   = [_heli, "ACCESSORY_DRIVE"] call bmkhs_fnc_systemCircuit;
private _hydExpected = !_onGnd || _accyDrive >= SYS_MIN_RPM;
if (_hydExpected && _priHydPSI < SYS_MIN_HYD_PSI) then {
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
if (_hydExpected && _utilHydPSI < SYS_MIN_HYD_PSI) then {
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
    || !(_heli getVariable "bmkhs_fmcPitchOn")
    || !(_heli getVariable "bmkhs_fmcRollOn")
    || !(_heli getVariable "bmkhs_fmcYawOn")
    || !(_heli getVariable "bmkhs_fmcCollOn")) then {
        ([_heli, _activeCaut, "FMC DISENGAGED", "FMC DISENG", _playCautAudio] call fza_wca_fnc_wcaAddCaution)
        params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "FMC DISENG"] call fza_wca_fnc_wcaDelCaution;
};

//--Rotor brake. Set with a power lever off OFF is the caution; both levers off is the
//advisory further down.
//
//A start begun with the brake set LATCHES the caution off and it stays off until the brake
//comes off - a locked-rotor start is deliberate the whole way through, not just while the
//starter turns. The latch is cleared in fn_transmissionUpdate, where the brake is read.
private _rtrBrake = _heli getVariable ["bmkhs_rotorBrakeVal", 0];
if (_rtrBrake > 0
    && {(_heli getVariable ["bmkhs_rtrBrkStartLatch", 0]) == 0}
    && {_eng1PwrLvrState != "OFF" || _eng2PwrLvrState != "OFF"}) then {
    ([_heli, _activeCaut, "ROTOR BRAKE ON/LK", "RTR BRK ON/LK", _playCautAudio]
        call fza_wca_fnc_wcaAddCaution) params ["_wcaAddCaution", "_playAudio"];

    _playCautAudio = _playAudio;
    _wcas pushBack _wcaAddCaution;
} else {
    [_activeCaut, "RTR BRK ON/LK"] call fza_wca_fnc_wcaDelCaution;
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

//First in the stack: on an APU start this is what the crew is waiting on, so it should not
//be below the door and waypoint advisories. <= because a spent accumulator sits AT the
//precharge, which is not usable pressure.
if (_accHydPSI <= SYS_MIN_ACC_PSI) then {
    _wcas pushBack [WCA_ADVISORY, "ACCUM OIL PRES LO", "ACCUM PSI"];
};

if  (_heli getVariable "fza_mpd_verMisMatch") then {
    _wcas pushBack [WCA_ADVISORY, "VERSION MISMATCH", "VERS MISM"];
};

if (_heli animationPhase "gdoor" > 0 || _heli animationPhase "pdoor" > 0) then {
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
if (_heli getVariable "bmkhs_attHoldActive") then {
    _wcas pushBack [WCA_ADVISORY, "ATTITUDE HOLD", "ATT HOLD"];
};
private _desiredPos = 0.0;
private _curPos     = getPos _heli;
if ( !(_heli getVariable "bmkhs_attHoldActive") || _heli getVariable "bmkhs_forceTrimInterupted") then {
    _desiredPos = _curPos;
} else {
    _desiredPos = _heli getVariable "bmkhs_attHoldDesiredPos";
};
private _dist           = _heli distance2D _desiredPos;
private _attHoldSubMode =_heli getVariable "bmkhs_attHoldSubMode";
if (_dist >= 14.630 && _attHoldSubMode == "pos") then {
    _wcas pushBack [WCA_ADVISORY, "HOVER DRIFT", "HOVER DRIFT"];
};
if (_heli getVariable "bmkhs_altHoldActive") then {
    if (_heli getVariable "bmkhs_altHoldSubMode" == "rad") then {
        _wcas pushBack [WCA_ADVISORY, "RAD ALT HOLD", "RAD HOLD  "];
    } else {
        _wcas pushBack [WCA_ADVISORY, "BAR ALT HOLD", "BAR HOLD  "];
    };
};
//The rotor brake ADVISORY, with both levers off - or through a locked-rotor start, where the
//caution is latched off and this stays up in its place until the brake comes off.
//Its caution is up with the other cautions, before the audio gate.
if ((_heli getVariable ["bmkhs_rotorBrakeVal", 0]) > 0
    && {(_heli getVariable ["bmkhs_rtrBrkStartLatch", 0]) > 0
        || {_eng1PwrLvrState == "OFF" && _eng2PwrLvrState == "OFF"}}) then {
    _wcas pushBack [WCA_ADVISORY, "ROTOR BRAKE ON", "RTR BRK ON"];
};
//--FCR
if (_fcrState#0 == FCR_MODE_FAULT) then {
    _wcas pushBack [WCA_ADVISORY, "FCR FAULT", "FCR FAULT"];
};
if (_onGnd) then {
    _wcas pushBack [WCA_ADVISORY, "TAIL WHEEL LOCk SEL", "TW LOCK SEL"];
};

//Auxilary Fuel tanks
if (("auxTank" in (_pylonMagazines select 0))  && _auxTank1FuelMass < EXT_EMPTY_ADV_THRESH_KG && (_heli getVariable ["bmkhs_stn1TankEmptyArmed", true])) then {
    _wcas pushBack [WCA_ADVISORY, "EXTERNAL 1 EMPTY", "EXT1 EMPTY"];
};
if (("auxTank" in (_pylonMagazines select 4))  && _auxTank2FuelMass < EXT_EMPTY_ADV_THRESH_KG && (_heli getVariable ["bmkhs_stn2TankEmptyArmed", true])) then {
    _wcas pushBack [WCA_ADVISORY, "EXTERNAL 2 EMPTY", "EXT2 EMPTY"];
};
if (("auxTank" in (_pylonMagazines select 8))  && _auxTank3FuelMass < EXT_EMPTY_ADV_THRESH_KG && (_heli getVariable ["bmkhs_stn3TankEmptyArmed", true])) then {
    _wcas pushBack [WCA_ADVISORY, "EXTERNAL 3 EMPTY", "EXT3 EMPTY"];
};
if (("auxTank" in (_pylonMagazines select 12)) && _auxTank4FuelMass < EXT_EMPTY_ADV_THRESH_KG && (_heli getVariable ["bmkhs_stn4TankEmptyArmed", true])) then {
    _wcas pushBack [WCA_ADVISORY, "EXTERNAL 4 EMPTY", "EXT4 EMPTY"];
};


private _wptAprch = _heli getVariable "fza_ah64_wptAprch";
private _wptPassed = _heli getVariable "fza_ah64_wptpassed";
private _pltMpd = _heli getVariable "fza_mpd_page_plt";
private _cpgMpd = _heli getVariable "fza_mpd_page_cpg";
if (!("tsd" in _pltMpd || "tsd" in _cpgMpd) && _wptAprch#1) then {
    _wcas pushBack [WCA_ADVISORY, "WAYPOINT APPROACH", "WPT APRCH"];
};
if (!("tsd" in _pltMpd || "tsd" in _cpgMpd) && _wptPassed) then {
    _wcas pushBack [WCA_ADVISORY, "WAYPOINT PASSED", "WPT PASSED"];
};
if (_heli getVariable ["bmkhs_checkPendingAdvisory", false]) then {
    _wcas pushBack [WCA_ADVISORY, "FUEL CHECK", "FUEL CHECK"];
};
_wcas;
