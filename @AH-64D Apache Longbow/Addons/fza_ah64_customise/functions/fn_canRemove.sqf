/* ----------------------------------------------------------------------------
Function: fza_customise_fnc_canRemove

Description:
    Can you add the relevent component

Parameters:
    _heli - The apache
    _player - The player
    _targetcomp - desired component to remove

Returns:
    Bool: if it can remove the component
    
Examples:

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