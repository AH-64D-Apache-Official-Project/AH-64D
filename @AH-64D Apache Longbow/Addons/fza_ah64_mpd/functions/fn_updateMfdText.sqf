/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_updateMfdText

Description:
    Checks the current value of the MFD Text and compares it to the value that is being set. If they are different, it sets the new value.
    This is used to prevent the MFDs from being updated when they are not needed.

Parameters:
    _heli - the helicopter to update the MFD value for.
    _mfdIndex - the index of the MFD to update.
    _text - the value to set the MFD to.

Returns:
    Nothing.

Examples:
    --- Code
    [_heli, 0, "1"] call fza_mpd_fnc_updateMfdText
    ---
    This will set the value of the first MFD to "1" if it is not already set to "1".

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_mfdIndex", "_text"];

private _usermfdTextArray = getUserMFDText _heli;
if ((count _usermfdTextArray) == 0) exitWith {
    _heli setUserMfdText [49, ""];
};

if ((_usermfdTextArray # _mfdIndex) isnotEqualTo _text) exitWith {
    _heli setUserMfdText [_mfdIndex, _text];
};