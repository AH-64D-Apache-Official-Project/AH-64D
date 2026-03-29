#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];

if (!(_heli getVariable ["fza_mpd_aircraftInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_mpd_page_plt", ["Off", "Off"], true];
    _heli setVariable ["fza_mpd_page_cpg", ["Off", "Off"], true];
};

_heli setVariable ["fza_mpd_tsdShowHsi", [false, false]];
_heli setVariable ["fza_mpd_tsdShowWind", [true, true]];
_heli setVariable ["fza_mpd_tsdShowEndr", [true, true]];
_heli setVariable ["fza_mpd_tsdShowNavWptData", true];
_heli setVariable ["fza_mpd_tsdShowAtkCurrRoute", false];
_heli setVariable ["fza_mpd_tsdShowEnemy", [false, false]];
_heli setVariable ["fza_mpd_tsdShowFriendly", [false, true]];
_heli setVariable ["fza_mpd_tsdShowRlwr", [true, true]];
_heli setVariable ["fza_mpd_tsdShowPlanTgts", [false, true]];
_heli setVariable ["fza_mpd_tsdShowCtrlMeasures", [true, true]];
_heli setVariable ["fza_mpd_tsdShowAtkShot", true];
_heli setVariable ["fza_mpd_tsdShowAtkHazard", true];

_heli setVariable ["fza_mpd_tsdWptCurrentSel", []];
_heli setVariable ["fza_mpd_tsdThrtCurrentSel", []];
_heli setVariable ["fza_mpd_tsdRteCurrentSel", []];
_heli setVariable ["fza_mpd_tsdRteCurrentRvw", -1];

_heli setVariable ["fza_ah64_routeSelected",          0, true];
_heli setVariable ["fza_ah64_routeData",[[],[],[],[],[],[],[],[],[],[]], true];
_heli setVariable ["fza_ah64_routeCurPoint", -1, true];
_heli setVariable ["fza_ah64_wptAprch", [-1,false], true];
_heli setVariable ["fza_ah64_wptpassed", false, true];

_heli setVariable ["fza_mpd_mpdState", [["Off", 0, {}, {}, createHashMap, createHashMap, {}, 0], ["Off", 0, {}, {}, createHashMap, createHashMap, {}, 0]]];

_heli setObjectTexture ["mpd_back", "#(rgb,2048,2048,1)uiEx(display:RscFzaAH64MPD)"];


//Software Page Info
private _loadedApacheAddons = [];
private _addonInfo = allAddonsInfo apply {if ("fza_ah64" in _x#0 || "fza_compat" in _x#0) then {_x#0;};};
{_loadedApacheAddons pushback (if ("fza_compat" in _x) then { _x select [11, (count _x) -12];} else {_x select [9, (count _x) -10]});} foreach _addonInfo;
private _expectedAddons = getArray (configFile >> "CfgPatches" >> "fza_ah64_controls" >> "pbos");
private _expectedHash = getText (configFile >> "CfgPatches" >> "fza_ah64_controls" >> "hash");
_heli setVariable ["fza_mpd_verLoadedAddons", _loadedApacheAddons];
_heli setVariable ["fza_mpd_verExpectedAddons", _expectedAddons];
_heli setVariable ["fza_mpd_verExpectedHash", _expectedHash];

for "_i" from 0 to ((count _expectedAddons) min 39) do {
    private _validationState = 2;
    private _addonName = _expectedAddons # _i;
    private _addonHash = (getText (configFile >> "CfgPatches" >> _addonName >> "hash")) select [0,8];
    if ("fza_ah64" in _addonName) then {_addonName = _addonName select [9, 9]};
    if ("fza_compat" in _addonName) then {_addonName = _addonName select [11, 9]};
    if (_addonName in _loadedApacheAddons) then {_validationState = 1;};
    if (_addonHash == _expectedHash) then {_validationState = 0;};
    if (_validationState == 1 && _addonHash isnotequalto "" || _validationState == 2) then {_heli setVariable ["fza_mpd_verMisMatch", true];};
};