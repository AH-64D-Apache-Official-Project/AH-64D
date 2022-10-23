/* ----------------------------------------------------------------------------
Function: fza_misc_fnc_customiseCanRemove

Description:
	...

Parameters:
	...

Returns:
	...

Examples:
    ...

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_player","_targetComp"];

private _return = false;

if (_targetComp == "FCR") then {
    if (!("ToolKit" in (items player))) exitWith {};
    if (_heli animationPhase "fcr_enable" == 0) exitWith {};
    _return = true;
};
_return;