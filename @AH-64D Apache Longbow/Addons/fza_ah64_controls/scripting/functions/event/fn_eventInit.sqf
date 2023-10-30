/* ----------------------------------------------------------------------------
Function: fza_fnc_eventInit

Description:
    Master init event handler

    Handles variable initialisation, and continues running to ensure weapon textures are kept up to date

    Must be run in a scheduled environment (spawn)

Parameters:
    _heli - the helicopter to initialise

Returns:
    Nothing

Examples:
    [_heli] spawn fza_fnc_eventInit

Author:
    unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli"];

//Pbo initializations
[_heli] call fza_fcr_fnc_init;

if (!(isNil "fza_ah64_noinit")) exitwith {};
_heli addAction ["<t color='#ff0000'>Weapons inhibited</t>", {}, [], -10, false, false, "DefaultAction", "count (_target getVariable ""fza_ah64_weaponInhibited"") != 0"];

if (!(_heli getVariable ["fza_ah64_aircraftInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_aircraftInitialised", true, true];
    _heli selectweapon "fza_ma_safe";

    _heli setVariable ["fza_ah64_rtrbrake", false, true];
    _heli setVariable ["fza_ah64_tadsStow", true, true];
    _heli setVariable ["fza_ah64_powerLever1", 0, true];
    _heli setVariable ["fza_ah64_powerLever2", 0, true];

    _heli setVariable ["fza_ah64_sight_plt", 1, true];
    _heli setVariable ["fza_ah64_sight_cpg", 1, true];
    _heli setVariable ["fza_ah64_hmdfsmode", "trans", true];
    _heli setVariable ["fza_ah64_hellfireTrajectory", "DIR", true];
    //
    _heli setVariable ["fza_ah64_tsdsort", 0, true];
    _heli setVariable ["fza_ah64_currentLase", objNull, true];
    _heli setVariable ["fza_ah64_magazineAddLastValue", _heli animationSourcePhase "magazine_set_1200", true];
    _heli setVariable ["fza_ah64_currentSkippedLases", [], true];
    //ASE Initial States
    //--Chaff       - Aircraft common
    _heli setVariable ["fza_ah64_ase_chaffState",   "safe", true];
    //--RLWR        - Aircraft Common
    _heli setVariable ["fza_ah64_ase_rlwrPwr",      "off", true];
    _heli setVariable ["fza_ah64_ase_rlwrCount",    0, true];
    _heli setVariable ["fza_ah64_ase_rlwrObjects",  [], true];
    _heli setVariable ["fza_ah64_ase_audioList",  [], true];
    //--IR Jammer   - Aircraft Common
    _heli setVariable ["fza_ah64_ase_msnEquipPwr",      "off", true];
    _heli setVariable ["fza_ah64_ase_irJamState",    0, true];
    _heli setVariable ["fza_ah64_ase_irJamTimer",    0.0, true];
    _heli setVariable ["fza_ah64_ase_irJamLaunchTimer", 0];
    //--Autopage    - Crewstation independent
    _heli setVariable ["fza_ah64_ase_autopage",     1, true];
    _heli setVariable ["fza_ah64_ase_searchingObj",  [], true];
    _heli setVariable ["fza_ah64_ase_acquisitionObj",  [], true];
    _heli setVariable ["fza_ah64_ase_trackingobj",  [], true];

    _heli setVariable ["fza_ah64_IAFSInstalled", true, true];
    _heli setVariable ["fza_ah64_IAFSOn", false, true];
    _heli setVariable["fza_ah64_engineStates", [
        ["OFF", 0],
        ["OFF", 0]
    ], true];
    _heli setVariable ["fza_ah64_tadsLocked", objNull, true];

    private _rockets = weapons _heli select {_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]};
    _heli setVariable ["fza_ah64_selectedRocket", ["", _rockets # 0] select (count _rockets > 0), true];
    private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
    _heli setVariable ["fza_ah64_selectedMissile", ["", _missiles # 0] select (count _missiles > 0), true];
    _heli setVariable ["fza_ah64_was", WAS_WEAPON_NONE, true];


    _heli setVariable ["fza_ah64_laserMissilePrimaryCode",    0, true];
    _heli setVariable ["fza_ah64_laserMissileAlternateCode",  1, true];
    _heli setVariable ["fza_ah64_laserLRFDCode",              "A", true];
    _heli setVariable ["fza_ah64_laserLSTCode",               "B", true];
    _heli setVariable ["fza_ah64_laserChannelCodes",         ["A", "B", "C", "D"], true];
    _heli setVariable ["fza_ah64_laserChannelIndex", createHashMapFromArray
        [ ["A",1111],["B",1112]
        , ["C",1113],["D",1114]
        , ["E",1121],["F",1122]
        , ["G",1123],["H",1124]
        , ["J",1131],["K",1132]
        , ["L",1133],["M",1134]
        , ["N",1141],["P",1142]
        , ["Q",1143],["R",1144]
        ], true];
    //FMC
    _heli setVariable ["fza_ah64_fmcPitchOn",          true,  true];
    _heli setVariable ["fza_ah64_fmcRollOn",           true,  true];
    _heli setVariable ["fza_ah64_fmcYawOn",            true,  true];
    _heli setVariable ["fza_ah64_fmcCollOn",           true,  true];
    _heli setVariable ["fza_ah64_fmcTrimOn",           true,  true];
    //Force Trim
    _heli setVariable ["fza_ah64_forceTrimInterupted", false, true];
    _heli setVariable ["fza_ah64_forceTrimPosPitch",   0.0,   true];
    _heli setVariable ["fza_ah64_forceTrimPosRoll",    0.0,   true];
    _heli setVariable ["fza_ah64_forceTrimPosPedal",   0.0,   true];
    //Attitude Hold
    _heli setVariable ["fza_ah64_attHoldActive",       false, true];
    _heli setVariable ["fza_ah64_attHoldDesiredPos",   getPos _heli, true];
    _heli setVariable ["fza_ah64_attHoldDesiredVel",   [0.0, 0.0],   true];
    _heli setVariable ["fza_ah64_attHoldDesiredAtt",   [0.0, 0.0],   true];
    _heli setVariable ["fza_ah64_attHoldSubMode",      "pos", true];   //pos, vel, att
    //Altitude Hold
    _heli setVariable ["fza_ah64_altHoldActive",       false, true];
    _heli setVariable ["fza_ah64_altHoldDesiredAlt",   0.0,   true];
    _heli setVariable ["fza_ah64_altHoldSubMode",      "rad", true];   //rad, bar
    _heli setVariable ["fza_ah64_altHoldCollRef",      0.0,   true];
    //Heading Hold
    _heli setVariable ["fza_ah64_hdgHoldActive",          false, true];
    _heli setVariable ["fza_ah64_hdgHoldDesiredHdg",      0.0,   true];
    _heli setVariable ["fza_ah64_hdgHoldDesiredSideslip", 0.0,   true];
    _heli setVariable ["fza_ah64_hdgHoldSubMode",         "hdg", true];    //hdg, trn
    _heli setVariable ["fza_ah64_hdgHoldPedalRef",        0.0,   true];    //<-- probably not needed, kept just in case...
    //Systems
    _heli setVariable ["fza_ah64_emerHydOn",              false, true];
    _heli setVariable ["fza_ah64_gndOrideOn",             false, true];
    _heli setVariable ["fza_ah64_armSafeArmed",           false, true];
    _heli setVariable ["fza_ah64_mstrCautAudioOn",        false, true];
    _heli setVariable ["fza_ah64_activeCaut", createHashMapFromArray [["exists", true]], true];
    _heli setVariable ["fza_ah64_mstrWarnAudioOn",        false, true];
    _heli setVariable ["fza_ah64_activeWarn", createHashMapFromArray [["exists", true]], true];
    _heli setVariable ["fza_ah64_engineOverspeed",        [false, false], true];
};//fza_ah64_aircraftInitialised end

_heli setVariable ["fza_ah64_weaponInhibited", ""];
_heli setVariable ["fza_ah64_burst_limit", 10];
_heli setVariable ["fza_ah64_ihadss_pnvs_cam", false];
_heli setVariable ["fza_ah64_monocleinbox", true];
_heli setVariable ["fza_ah64_mpdbrightness", 1];
_heli setVariable ["fza_ah64_rocketsalvo", 2];
//Systems local to the crewstation
_heli setVariable ["fza_ah64_mstrCautLightOn", false];
_heli setVariable ["fza_ah64_mstrWarnLightOn", false];

//free cursor
_heli setVariable ["fza_ah64_freeCursorEnabled", false];
_heli setVariable ["fza_ah64_freeCursorHpos", 0.5];
_heli setVariable ["fza_ah64_freeCursorVpos", 0.5];

_heli setVariable ["fza_ah64_tadsThermal", true];
_heli setVariable ["fza_ah64_tadsZoom", 0];
_heli setVariable ["fza_ah64_tadsA3ti", false];

[_heli] call fza_sfmplus_fnc_coreConfig;
[_heli] call fza_systems_fnc_coreVariables;
//[_heli] call BMK_fnc_coreConfig;

if (player in _heli && !is3den && {fza_ah64_showPopup && !fza_ah64_introShownThisScenario}) then {
    _heli spawn {
        waitUntil {cba_missiontime != 0;};
        createDialog "RscFzaDisplayWelcome";
    };
};

//Fixes pylons that went onto the wrong turret (pilot, rather than gunner)
if (local _heli) then { 
    { 
        _x params ["_pylId", "", "_pylTurr", "_pylMag", "_pylAmmo"]; 
        if (_pylTurr isNotEqualTo [0]) then { 
            _wep = configFile >> "CfgMagazines" >> _pylMag >> "pylonWeapon";
            if (isText _wep) then {
                [[_heli, getText _wep, _pylTurr], { 
                    params["_heli", "_weapon", "_turret"]; 
                    
                    _heli removeWeaponTurret [_weapon, _turret] 
                }] remoteExec ["call", [driver _heli, _heli] select (isNull driver _heli)];
            };
            _heli setPylonLoadout [_pylId, _pylMag, true, [0]]; 
            _heli setAmmoOnPylon [_pylId, _pylAmmo]; 
        }; 
    } foreach getAllPylonsInfo _heli; 
};

if !(isMultiplayer) then {
    _blades = [_heli] execvm "\fza_ah64_controls\scripting\singleplayer\bladerot.sqf";
};

while {
    alive _heli
}
do {
    private _battBusOn              = _heli getVariable "fza_systems_battBusOn";
    ace_map_vehicleLightCondition   = {isLightOn [_vehicle, [0]]}; 
    if (!isLightOn [_heli,[0]] || !_battBusOn) then {

        _heli setobjecttextureGlobal ["in_backlight", ""];
        _heli setobjecttextureGlobal ["in_backlight2", ""];

        [_heli, false] call fza_fnc_lightSetCockpitLight;
        systemchat "1";
    };
    _magsp = _heli magazinesturret[-1];

    if (local _heli) then {
        private _acBusOn            = _heli getVariable "fza_systems_acBusOn";
        private _dcBusOn            = _heli getVariable "fza_systems_dcBusOn";
        private _tadsShouldBeStowed = true;

        if (_acBusOn && _dcBusOn) then {
            _tadsShouldBeStowed = false;
        };

        if (_tadsShouldBeStowed != _heli getVariable "fza_ah64_tadsStow") then {
            [_heli, "fza_ah64_tadsStow", _tadsShouldBeStowed] call fza_fnc_animSetValue;
        };
    };
    sleep 0.03;
};
