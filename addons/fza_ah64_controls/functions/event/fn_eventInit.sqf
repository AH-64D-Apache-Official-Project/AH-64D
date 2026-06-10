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

if (!(isNil "fza_ah64_noinit")) exitWith {};
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

_heli setVariable ["fza_ah64_lastTimePropagated", 0];
_heli setVariable ["fza_ah64_tadsElevation", 0];
_heli setVariable ["fza_ah64_tadsAzimuth",   0];
_heli setVariable ["ace_rearm_scriptedLoadout", true];

// Defer one frame: CBA fires ACE's "Air init" class EH (which adds the pylon action) in the
// same init tick as our CfgEventHandlers entry. Running next frame guarantees our removal
// fires after ACE's addition regardless of EH registration order.
if (!isNil "ace_interact_menu_fnc_removeActionFromClass") then {
    [{
        params ["_heli"];
        if (isNil "fza_mplanner_pylonRemoveDone") then { fza_mplanner_pylonRemoveDone = []; };
        private _typeStr = typeOf _heli;
        if (!(_typeStr in fza_mplanner_pylonRemoveDone)) then {
            fza_mplanner_pylonRemoveDone pushBack _typeStr;
            [_typeStr, 0, ["ACE_MainActions", "ace_pylons_loadoutAction"]] call ace_interact_menu_fnc_removeActionFromClass;
        };
    }, _heli] call CBA_fnc_execNextFrame;
};

if (player in _heli && !is3DEN && {fza_ah64_showPopupv2_2 && !fza_ah64_introShownThisScenario}) then {
    _heli spawn {
        waitUntil {cba_missiontime != 0;};
        createDialog "RscFzaDisplayWelcome";
    };
};
