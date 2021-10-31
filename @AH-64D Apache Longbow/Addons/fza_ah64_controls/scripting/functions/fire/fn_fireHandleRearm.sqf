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

private _turret = 0;
if (_heli turretLocal [0]) then {
	_turret = -1;
};

if ((_heli getHit "leng" == 0) && (_heli getVariable "fza_ah64_firepdisch" == true)) then {
    _heli setVariable ["fza_ah64_firepdisch", false, true];
	[_heli, "eng1", false] call fza_fnc_fireHandlepanel;
	[_heli, "eng2", false] call fza_fnc_fireHandlepanel;
	[_heli, "apu", false] call fza_fnc_fireHandlepanel;
};
if ((_heli getHit "reng" == 0) && (_heli getVariable "fza_ah64_firerdisch" == true)) then {
    _heli setVariable ["fza_ah64_firerdisch", false, true];
    [_heli, "eng1", false] call fza_fnc_fireHandlepanel;
	[_heli, "eng2", false] call fza_fnc_fireHandlepanel;
	[_heli, "apu", false] call fza_fnc_fireHandlepanel;
};