/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rlwr


Description:
    proccessor for the ase background systems by, grabing the radar threats and sorting them into and output array order by threat value

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_rlwr

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];


private _dcBusOn         = _heli getVariable "fza_systems_dcBusOn";
private _rlwrPwr         = _heli getVariable "fza_ah64_ase_rlwrPwr";
private _irJamState      = _heli getVariable "fza_ah64_ase_irJamState";
private _rlwrObjects     = [];
private _rlwrCount       = 0;
private _rlwrAudio       = [];
private _launching       = [];

if ((player != driver _heli) && (isplayer driver _heli)) exitwith {};
if !(_dcBusOn) exitwith {
    [_heli, "fza_ah64_ase_rlwrPwr", "off"] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_ase_rlwrObjects", []] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_ase_rlwrCount", 0] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_ase_audioList", []] call fza_fnc_updateNetworkGlobal;
};

//Sensor threats - acquisition, Track and Launch
{
    _x params ["_object", "_type", "_sensor"];
    private _object = vehicle _object;
    if (_object in _launching) then {continue;};
    if ("missile" in _type) then {
        private _launcher = (getShotParents _object)#0;
        if (_irJamState == ASE_IRJAM_STATE_OPER && _heli animationPhase "msn_equip_British" == 1) then {
            _launching pushBack _launcher;
            _rlwrObjects deleteAt (_rlwrObjects findIf {_x isEqualTo _launcher;});
            _rlwrObjects pushBack [ASE_MSL, _object, [_launcher] call fza_ase_fnc_adaClassification];
            continue;
        };
        private _seekerhead = getNumber (configFile >> "CfgAmmo" >> typeof _object >> "weaponLockSystem");
        if (([_seekerhead, 8] call BIS_fnc_bitwiseAND == 8 && _rlwrPwr == "on")) then {
            _launching pushBack _launcher;
            _rlwrObjects deleteAt (_rlwrObjects findIf {_x isEqualTo _launcher;});
            _rlwrObjects pushBack [ASE_LNC, _launcher, [_launcher] call fza_ase_fnc_adaClassification];
            continue;
        };
    };
    if ("locked" in _type && _rlwrPwr == "on") then {
        _rlwrObjects pushBack [ASE_TRK, _object, [_object] call fza_ase_fnc_adaClassification];
        _rlwrAudio pushback [vehicle _object, "tracking"];
        continue;
    };
    if ("marked" in _type && _rlwrPwr == "on") then {
        _rlwrObjects pushBack [ASE_ACQ, _object, [_object] call fza_ase_fnc_adaClassification];
        _rlwrAudio pushback [vehicle _object, "acquisition"];
    };
} foreach getSensorThreats _heli;
//Sensor targets - Search
{
    if !(_rlwrPwr == "on") then {continue;};
    _x params ["_object", "_type", "_relationship", "_sensor"];
    private _object = vehicle _object;
    if (_object in _launching) then {continue;};
    if ("passiveradar" in _sensor && !(_object in (getSensorThreats _heli))) then {
        _rlwrObjects pushBack [ASE_SRH, _object, [_object] call fza_ase_fnc_adaClassification];
        _rlwrAudio pushback [vehicle _object, "searching"];
    };
} foreach getSensorTargets _heli;

_rlwrObjects = [_rlwrObjects, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy;

[_heli, "fza_ah64_ase_rlwrObjects", _rlwrObjects] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_ase_rlwrCount", count _rlwrObjects] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_ase_audioList", _rlwrAudio] call fza_fnc_updateNetworkGlobal;