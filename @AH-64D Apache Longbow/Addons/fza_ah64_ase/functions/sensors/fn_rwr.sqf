/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rwr

Description:
    Proccessor function for the RADAR WARNING RECIEVER

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    _rwrObjects - [state, objectPos, "_iconClass"]
    _rwrAudio   - [object, "state", "_soundclass"];

Examples:
    [_heli] call fza_ase_fnc_rwr

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

[] params [["_rwrObjects",[]],["_rwrCount",0],["_rwrAudio",[]],["_launching",[]]];

{
    _x params ["_object", "_type", "_sensor"];

    private _object = vehicle _object;
    if (_object in _launching) then {continue;};
    switch (_type) do {
        case "missile": {
            private _launcher = (getShotParents _object)#0;
            private _seekerhead = getNumber (configFile >> "CfgAmmo" >> typeof _object >> "weaponLockSystem");
            if ([_seekerhead, 8] call BIS_fnc_bitwiseAND == 8) then {
                _launching pushBack _launcher;
                _rwrObjects deleteAt (_rwrObjects findIf {_x isEqualTo _launcher;});
                [_heli, _launcher, ASE_LNC] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
                _rwrObjects pushBack [ASE_LNC, _object, _iconClass];
                continue;
            };
        };
        case "locked": {
            [_heli, _object] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
            _rwrObjects pushBack [ASE_TRK, _object, _iconClass];
            _rwrAudio pushback [_object, "tracking", _soundclass];
            continue;
        };
        case "marked": {
            [_heli, _object] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
            _rwrObjects pushBack [ASE_ACQ, _object, _iconClass];
            _rwrAudio pushback [_object, "acquisition", _soundclass];
        };
    };
} foreach getSensorThreats _heli;

{
    _x params ["_object", "_type", "_relationship", "_sensor"];
    private _object = vehicle _object;
    if (_object in _launching) then {continue;};
    if (_object in (getSensorThreats _heli)) exitwith {};
    if ("passiveradar" in _sensor) then {
        [_heli, _object] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
        _rwrObjects pushBack [ASE_SRH, getpos _object, _iconClass];
        _rwrAudio pushback [_object, "searching", _soundclass];
    };
} foreach getSensorTargets _heli;

_rwrObjects = [_rwrObjects, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy;

[_rwrObjects, _rwrAudio]