/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rlwr


Description:
    Handles the Radar/Laser Warning Receiver

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_rlwr

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"

params ["_heli"];

private _rlwrPwr     = _heli getVariable "fza_ah64_ase_rlwrPwr";
private _irJamState = _heli getVariable "fza_ah64_ase_irJamState";
private _rlwrObjects = [];
private _rlwrCount   = 0;
private _rlwrAudio   = [];
private _launching   = [];

//Sensor threats - acquisition, Track and Launch
{
    _x params ["_object", "_type", "_sensor"];
    if (_object in _launching) then {continue;};
    if ("missile" in _type) then {
        private _seekerhead = getNumber (configFile >> "CfgAmmo" >> typeof _object >> "weaponLockSystem");
        if ((_rlwrPwr == "on" && [_seekerhead, 8] call BIS_fnc_bitwiseAND != 0) || (_irJamState == ASE_IRJAM_STATE_OPER && _heli animationPhase "msn_equip_British" == 1)) then {
            private _launcher   = getShotParents _object;
            _launching append _launcher;
            _rlwrObjects deleteAt (_rlwrObjects findIf {_launcher in _x});
            _rlwrObjects pushBack [ASE_LNC, _heli getRelDir _object, [_object] call fza_ase_fnc_adaClassification, _object];
            continue;
        };
    };
    if ("locked" in _type && _rlwrPwr == "on") then {
        _rlwrObjects pushBack [ASE_TRK, _heli getRelDir _object, [_object] call fza_ase_fnc_adaClassification, _object];
        _rlwrAudio pushback [vehicle _object, "tracking"];
        continue;
    };
    if ("marked" in _type && _rlwrPwr == "on") then {
        _rlwrObjects pushBack [ASE_ACQ, _heli getRelDir _object, [_object] call fza_ase_fnc_adaClassification, _object];
        _rlwrAudio pushback [vehicle _object, "acquisition"];
    };
} foreach getSensorThreats _heli;
//Sensor targets - Search
{
    if !(_rlwrPwr == "on") then {continue;};
    _x params ["_object", "_type", "_relationship", "_sensor"];
    if (_object in _launching) then {continue;};
    if ("passiveradar" in _sensor && !(_object in (getSensorThreats _heli))) then {
        _rlwrObjects pushBack [ASE_SRH, _heli getRelDir _object, [_object] call fza_ase_fnc_adaClassification, _object];
        _rlwrAudio pushback [vehicle _object, "searching"];
    };
} foreach getSensorTargets _heli;

_rlwrObjects = [_rlwrObjects, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy;
_heli setVariable ["fza_ah64_ase_rlwrObjects", _rlwrObjects];
_heli setVariable ["fza_ah64_ase_rlwrCount", count _rlwrObjects];

[_heli,_rlwrAudio] spawn fza_ase_fnc_audioController;