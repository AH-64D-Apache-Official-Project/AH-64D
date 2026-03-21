params ["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

private _loadedApacheAddons = [];
private _addonInfo = allAddonsInfo apply {if ("fza_ah64" in _x#0 || "fza_compat" in _x#0) then {_x#0;};};
{_loadedApacheAddons pushback (if ("fza_compat" in _x) then { _x select [11, (count _x) -12];} else {_x select [9, (count _x) -10]});} foreach _addonInfo;
private _expectedAddons = getArray (configFile >> "CfgPatches" >> "fza_ah64_controls" >> "pbos");
private _expectedHash = getText (configFile >> "CfgPatches" >> "fza_ah64_controls" >> "hash");

for "_i" from 0 to 39 do {
    _heli setUserMfdText [MFD_INDEX_OFFSET(_i), ""];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(_i), 2];
};

{
    private _validationState = 2;
    private _outputString = "";
    _x params ["_addonName"];
    if ("fza_ah64" in _addonName) then {_addonName = _addonName select [9, 9]};
    if ("fza_compat" in _addonName) then {_addonName = _addonName select [11, 9]};
    private _addonHash = getText (configFile >> "CfgPatches" >> _x >> "hash");
    if (_addonName in _loadedApacheAddons) then {_validationState = 1;};
    if (_addonHash == _expectedHash) then {_validationState = 0;};
    if (_validationState == 2) then {_addonHash = "????????";};
    private _paddedString = [_addonName, 9, true] call fza_fnc_padString;
    private _outputString = (_paddedString + _addonHash);
    _heli setUserMfdText [MFD_INDEX_OFFSET(_forEachIndex), _outputString];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(_forEachIndex), _validationState];
} foreach _expectedAddons;