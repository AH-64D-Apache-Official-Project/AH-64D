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

private _class = "radar";
private _unitType = "SR";

private _cfg = configOf _object;
if (isText (_cfg >> "fza_aseClass")) then {
    _class = getText (_cfg >> "fza_aseClass");
};

if (isText (_cfg >> "fza_aseIcon")) then {
    _unitType = getText (_cfg >> "fza_aseIcon"); 
};

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
};

private _ident = (["RLWR", _unitType,_unitStatus]) joinString "_";

[_class, _ident];