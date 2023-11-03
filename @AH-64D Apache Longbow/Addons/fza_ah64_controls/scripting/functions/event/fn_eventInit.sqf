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

if (!(isNil "fza_ah64_noinit")) exitwith {};

//Pbo initializations
[_heli] call fza_aiCrew_fnc_init;
[_heli] call fza_ase_fnc_init;
[_heli] call fza_audio_fnc_init;
[_heli] call fza_cannon_fnc_init;
[_heli] call fza_fcr_fnc_init;
[_heli] call fza_fire_fnc_init;
[_heli] call fza_ihadss_fnc_init;
[_heli] call fza_laser_fnc_init;
[_heli] call fza_sfmplus_fnc_coreConfig;
[_heli] call fza_systems_fnc_coreVariables;
[_heli] call fza_wca_fnc_init;
[_heli] call fza_weapons_fnc_init;

_heli addAction ["<t color='#ff0000'>Weapons inhibited</t>", {}, [], -10, false, false, "DefaultAction", "count (_target getVariable ""fza_ah64_weaponInhibited"") != 0"];

if (!(_heli getVariable ["fza_ah64_aircraftInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_aircraftInitialised", true, true];

    _heli setVariable ["fza_ah64_rtrbrake", false, true];
    _heli setVariable ["fza_ah64_powerLever1", 0, true];
    _heli setVariable ["fza_ah64_powerLever2", 0, true];

    _heli setVariable ["fza_ah64_sight_plt", 1, true];
    _heli setVariable ["fza_ah64_sight_cpg", 1, true];

    _heli setVariable ["fza_ah64_magazineAddLastValue", _heli animationSourcePhase "magazine_set_1200", true];
    _heli setVariable ["fza_ah64_currentSkippedLases", [], true];

    _heli setVariable ["fza_ah64_IAFSInstalled", true, true];
    _heli setVariable ["fza_ah64_IAFSOn", false, true];
    _heli setVariable["fza_ah64_engineStates", [
        ["OFF", 0],
        ["OFF", 0]
    ], true];
    _heli setVariable ["fza_ah64_tadsLocked", objNull, true];

    _heli setVariable ["fza_ah64_freeCursorEnabled", false, true];
    _heli setVariable ["fza_ah64_freeCursorHpos", 0.5, true];
    _heli setVariable ["fza_ah64_freeCursorVpos", 0.5, true];
};

if (player in _heli && !is3den && {fza_ah64_showPopup && !fza_ah64_introShownThisScenario}) then {
    _heli spawn {
        waitUntil {cba_missiontime != 0;};
        createDialog "RscFzaDisplayWelcome";
    };
};

if !(isMultiplayer) then {
    _blades = [_heli] execvm "\fza_ah64_controls\scripting\singleplayer\bladerot.sqf";
};

while {player != vehicle player && alive player && alive _heli && local _heli} do {
    private _battBusOn              = _heli getVariable "fza_systems_battBusOn";
    ace_map_vehicleLightCondition   = {isLightOn [_vehicle, [0]]}; 
    if (!isLightOn [_heli,[0]] || !_battBusOn) then {

        _heli setobjecttextureGlobal ["in_backlight", ""];
        _heli setobjecttextureGlobal ["in_backlight2", ""];

        [_heli, false] call fza_fnc_lightSetCockpitLight;
    };
    _magsp = _heli magazinesturret[-1];
    sleep 0.2;
};