/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_classification

Description:
    handles returns anti air classification

Parameters:
    _heli : object - aircraft
    _object : object - unit to id
    _state: num - radar state for icon class

Returns:
    [class, icon class]

Examples:
    [_heli, _object,_state] call fza_ase_fnc_classification params ["_soundclass", "_iconClass"];

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_object",["_state", 0]];

// Called for every RLWR threat at every update: the type's class and icon type are read once
if (isNil "fza_ase_classCache") then {fza_ase_classCache = createHashMap;};
(fza_ase_classCache getOrDefaultCall [typeOf _object, {
    private _cfg = configOf _object;
    [
        ["radar", getText (_cfg >> "fza_aseClass")] select isText (_cfg >> "fza_aseClass"),
        ["SR", getText (_cfg >> "fza_aseIcon")] select isText (_cfg >> "fza_aseIcon")
    ]
}, true]) params ["_class", "_unitType"];

private _unitStatus = "";

//Unit status
switch (_state) do {
    case ASE_SRH: {
        _unitStatus = "SRH";
    };
    case ASE_ACQ;
    case ASE_TRK;
    case ASE_LNC: {
        _unitStatus = "ACQ_TRK";
    };
    case ASE_MSL: {
        _unitType   = "MSL";
        _unitStatus = "LNC";
    };
    case ASE_LSR: {
        _unitType   = "LSR";
        _unitStatus = "DES";
    };
};

private _ident = (["RLWR", _unitType,_unitStatus]) joinString "_";

[_class, _ident];
