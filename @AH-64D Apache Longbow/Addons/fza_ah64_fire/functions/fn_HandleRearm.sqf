/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_HandleRearm

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

private _turret = 0;
if (_heli turretLocal [0]) then {
    _turret = -1;
};

if ((_heli getHit "hitengine1" == 0) && (_heli getVariable "fza_ah64_firepdisch" == true)) then {
    _heli setVariable ["fza_ah64_firepdisch", false, true];
    [_heli, "eng1", false] call fza_fire_fnc_HandlePanel;
    [_heli, "eng2", false] call fza_fire_fnc_HandlePanel;
    [_heli, "apu", false] call fza_fire_fnc_HandlePanel;
};
if ((_heli getHit "hitengine2" == 0) && (_heli getVariable "fza_ah64_firerdisch" == true)) then {
    _heli setVariable ["fza_ah64_firerdisch", false, true];
    [_heli, "eng1", false] call fza_fire_fnc_HandlePanel;
    [_heli, "eng2", false] call fza_fire_fnc_HandlePanel;
    [_heli, "apu", false] call fza_fire_fnc_HandlePanel;
};