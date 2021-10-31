/* ----------------------------------------------------------------------------
Function: fza_fnc_fireHandlePanel

Description:
    Arms or disarms the fire panel

Parameters:
	heli - The helicopter to act on   
    engine- the engine selected 

Returns:

Examples:
    [_heli] call fza_fnc_firepanel
    
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli","_engine","_value"];

switch(_engine) do {
	case "eng1": {
        _heli setVariable ["fza_ah64_fire1arm", _value, true];
        _heli setObjectTextureGlobal [SEL_IN_LT_FIRE1RDY, ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _value];
    };
    case "eng2": {
        _heli setVariable ["fza_ah64_fire2arm", _value, true];
        _heli setObjectTextureGlobal [SEL_IN_LT_FIRE2RDY, ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _value];
    };
    case "apu": {
        _heli setVariable ["fza_ah64_fireapuarm", _value, true];
        _heli setObjectTextureGlobal [SEL_IN_LT_FIREAPURDY, ["", "\fza_ah64_us\tex\in\pushbut.paa"] select _value];
    };
};