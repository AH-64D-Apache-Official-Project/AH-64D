/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_updateMfdValue

Description:
    Checks the current value of the MFD value and compares it to the value that is being set. If they are different, it sets the new value.
    This is used to prevent the MFDs from being updated when they are not needed.

Parameters:
    _heli - the helicopter to update the MFD value for.
    _mfdIndex - the index of the MFD to update.
    _value - the value to set the MFD to.

Returns:
    Nothing.

Examples:
    --- Code
    [_heli, 0, 1] call fza_mpd_fnc_updateMfdValue
    ---
    This will set the value of the first MFD to 1 if it is not already set to 1.

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_mfdIndex", "_value"];

private _usermfdValueArray = getUserMFDValue _heli;
if ((count _usermfdValueArray) == 0) exitWith {
    _heli setUserMfdValue [49, ""];
};

if ((_usermfdValueArray # _mfdIndex) isnotEqualTo _value) exitWith {
    _heli setUserMfdValue [_mfdIndex, _value];
};