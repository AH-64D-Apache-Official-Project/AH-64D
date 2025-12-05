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
[_heli] call fza_ase_fnc_init;
[_heli] call fza_audio_fnc_Init;
[_heli] call fza_cannon_fnc_Init;
[_heli] call fza_fire_fnc_init;
[_heli] call fza_fcr_fnc_init;
[_heli] call fza_hellfire_fnc_init;
[_heli] call fza_ihadss_fnc_init;
[_heli] call fza_light_fnc_init;
[_heli] call fza_sfmplus_fnc_init;
[_heli] call fza_wca_fnc_init;
[_heli] spawn fza_weapons_fnc_init;

//flight setup
[_heli] call fza_sfmplus_fnc_coreConfig;
[_heli] call fza_systems_fnc_coreVariables;

if (!(isNil "fza_ah64_noinit")) exitwith {};
_heli addAction ["<t color='#ff0000'>Weapons inhibited</t>", {}, [], -10, false, false, "DefaultAction", "count (_target getVariable ""fza_ah64_weaponInhibited"") != 0"];

if (!(_heli getVariable ["fza_ah64_aircraftInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_aircraftInitialised", true, true];

    _heli setVariable ["fza_ah64_rtrbrake", false, true];
    _heli setVariable ["fza_ah64_powerLever1", 0, true];
    _heli setVariable ["fza_ah64_powerLever2", 0, true];

    _heli setVariable ["fza_ah64_sight_plt", 1, true];
    _heli setVariable ["fza_ah64_sight_cpg", 1, true];

    _heli setVariable ["fza_ah64_IAFSInstalled", true, true];
    _heli setVariable ["fza_ah64_IAFSOn", false, true];
    _heli setVariable["fza_ah64_engineStates", [
        ["OFF", 0],
        ["OFF", 0]
    ], true];
};

//free cursor
_heli setVariable ["fza_ah64_freeCursorEnabled", false];
_heli setVariable ["fza_ah64_freeCursorHpos", 0.5];
_heli setVariable ["fza_ah64_freeCursorVpos", 0.5];
_heli setVariable ["fza_ah64_lastTimePropagated", 0];
_heli setVariable ["fza_ah64_tadsElevation", 0];
_heli setVariable ["fza_ah64_tadsAzimuth",   0];
_heli setVariable ["ace_rearm_scriptedLoadout", true];

if (player in _heli && !is3den && {fza_ah64_showPopupv2_2 && !fza_ah64_introShownThisScenario}) then {
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

#define COCKPIT_CONTROL(pilot_mempoint, gunner_mempoint, system, system_name, control, sensitivity, control_name, movable) [pilot_mempoint, gunner_mempoint, #system, #control, sensitivity, control_name, movable]
#define COCKPIT_CONTROL_SEP ,
private _data =  [
    #include "\fza_ah64_controls\headers\controls.h"
];

private _controls = [];
{
    _x params [["_pilotPos", ""], ["_gunnerPos", ""], "_systemName", "_eventName", "_sensitivity", "_description", "_movable"];
    if (_pilotPos != "" && !_movable) then {
        _pilotPos = _heli selectionposition _pilotPos;
    };
    if (_gunnerPos != "" && !_movable) then {
        _gunnerPos = _heli selectionposition _gunnerPos;
    };
    _controls pushback [_pilotPos, _gunnerPos, _systemName, _eventName, _sensitivity, _description, _movable];
} foreach _data;
_heli setvariable ["fza_ah64_objectsDataArray", _controls];