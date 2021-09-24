/* ----------------------------------------------------------------------------
Function: fza_fnc_fireHandlepanel

Description:
    handles remotely setting fire panel texture for mulitplayer compatibilty

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
        if (_value == true) then {
			_heli setobjecttexture [SEL_IN_LT_FIRE1RDY, "\fza_ah64_us\tex\in\pushbut.paa"];
        };
        if (_value == false) then {
			_heli setobjecttexture [SEL_IN_LT_FIRE1RDY, ""];
        };
    };
	case "eng2": {
        if (_value == true) then {
			_heli setobjecttexture [SEL_IN_LT_FIRE2RDY, "\fza_ah64_us\tex\in\pushbut.paa"];
        };
        if (_value == false) then {
			_heli setobjecttexture [SEL_IN_LT_FIRE2RDY, ""];
        };
    };
	case "apu": {
        if (_value == true) then {
			_heli setobjecttexture [SEL_IN_LT_FIREAPURDY, "\fza_ah64_us\tex\in\pushbut.paa"];
        };
        if (_value == false) then {
			_heli setobjecttexture [SEL_IN_LT_FIREAPURDY, ""];
        };
    };
};