params ["_state", "_classification"];

#include "\fza_ah64_controls\headers\systemConstants.h"

private _ident      = "";
private _unitStatus = "";
private _unitType   = "";
//Unit type
switch (_classification) do {
    case "sa2": {
        _unitType = "SA2";
    };
    case "sa3": {
        _unitType = "SA3";
    };
    case "sa8": {
        _unitType = "SA8";
    };
    case "sa10": {
        _unitType = "SA10";
    };
    case "sa15": {
        _unitType = "SA15";
    };
    case "sa17": {
        _unitType = "SA17";
    };
    case "sa19": {
        _unitType = "SA19";
    };
    case "sa20": {
        _unitType = "SA20";
    };
    case "sa21": {
        _unitType = "SA21";
    };
    case "gun": {
        _unitType = "GU";
    };
    case "hawk": {
        _unitType = "HK";
    };
    case "naval": {
        _unitType = "NV";
    };
    case "2S6": {
        _unitType = "2S6";
    };
    case "radar": {
        _unitType = "SR";
    };
    case "zsu": {
        _unitType = "ZU";
    };
};
//Unit status
switch (_state) do {
    case ASE_SRH: {
        _unitStatus = "SRH";
    };
    case ASE_ACQ: {
        _unitStatus = "ACQ_TRK";
    };
    case ASE_TRK: {
        _unitStatus = "ACQ_TRK";
    };
    case ASE_LNC: {
        _unitType   = "MSL";
        _unitStatus = "LNC";
    };
};

_ident = (["RLWR", _unitType,_unitStatus]) joinString "_";

_ident;