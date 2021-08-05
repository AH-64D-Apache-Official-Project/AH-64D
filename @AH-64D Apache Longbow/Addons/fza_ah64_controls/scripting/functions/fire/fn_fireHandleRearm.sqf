/* ----------------------------------------------------------------------------
Function: fza_fnc_fireHandleRearm

Description:
    Handles the reset of fire system when rearming

Parameters:
	_heli - The helicopter to act on

Returns:

Examples:
    [_heli] call fireHandleRearm
    
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

if ((_heli ammo "fza_Fx1" == 1) && (_heli getVariable "fza_ah64_firepdisch" == true)) then {
    _heli setVariable ["fza_ah64_firepdisch", false, true];
    _heli setVariable ["fza_ah64_fire1arm", 0];
	_heli setobjecttexture [SEL_IN_LT_FIRE1RDY, ""];
    _heli setVariable ["fza_ah64_fire2arm", 0];
	_heli setobjecttexture [SEL_IN_LT_FIRE2RDY, ""];
    _heli setVariable ["fza_ah64_fireapuarm", 0];
	_heli setobjecttexture [SEL_IN_LT_FIREAPURDY, ""];
};
if ((_heli ammo "fza_Fx2" == 1) && (_heli getVariable "fza_ah64_firerdisch" == true)) then {
    _heli setVariable ["fza_ah64_firerdisch", false, true];
    _heli setVariable ["fza_ah64_fire1arm", 0];
	_heli setobjecttexture [SEL_IN_LT_FIRE1RDY, ""];
    _heli setVariable ["fza_ah64_fire2arm", 0];
	_heli setobjecttexture [SEL_IN_LT_FIRE2RDY, ""];
    _heli setVariable ["fza_ah64_fireapuarm", 0];
	_heli setobjecttexture [SEL_IN_LT_FIREAPURDY, ""];
};