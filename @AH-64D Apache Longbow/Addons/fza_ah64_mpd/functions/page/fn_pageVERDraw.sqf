params ["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

private _loadedApacheAddons = _heli getvariable "fza_mpd_verLoadedAddons";
private _expectedAddons = _heli getvariable "fza_mpd_verExpectedAddons";
private _expectedHash = _heli getvariable "fza_mpd_verExpectedHash";

for "_i" from 0 to ((count _expectedAddons) min 39) do {
    private _validationState = 2;
    private _outputString = "";
    private _addonName = _expectedAddons # _i;
    private _addonHash = (getText (configFile >> "CfgPatches" >> _addonName >> "hash")) select [0,8];
    if ("fza_ah64" in _addonName) then {_addonName = _addonName select [9, 9]};
    if ("fza_compat" in _addonName) then {_addonName = _addonName select [11, 9]};
    if (_addonName in _loadedApacheAddons) then {_validationState = 1;};
    if (_addonHash == _expectedHash) then {_validationState = 0;};
    if (_validationState == 2) then {_addonHash = "????????";};
    private _paddedString = [_addonName, 9, true] call fza_fnc_padString;
    private _outputString = (_paddedString + _addonHash);
    _heli setUserMfdText [MFD_INDEX_OFFSET(_i), _outputString];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(_i), (_validationState min 1)];
};