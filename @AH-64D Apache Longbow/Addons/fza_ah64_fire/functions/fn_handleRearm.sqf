/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_handleRearm

Description:
    Handles the reset of fire system when rearming

Parameters:
    _heli - The helicopter to act on

Returns:

Examples:
    [_heli] call fireHandleRearm
    
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli"];

if ((_heli getHit "hitengine1" == 0) && (_heli getVariable "fza_ah64_firepdisch" == true)) then {
    _heli setVariable ["fza_ah64_firepdisch", false, true];
};
if ((_heli getHit "hitengine2" == 0) && (_heli getVariable "fza_ah64_firerdisch" == true)) then {
    _heli setVariable ["fza_ah64_firerdisch", false, true];
};