/* ----------------------------------------------------------------------------
Function: fza_fnc_setLaserChannels

Description:
	Setting of Ace laser code

Parameters:
    _heli - the helicopter
    _change - "Primary_Alternate"
               "LRST_LST"
               "LaserBoxChannels"
    _NewLaserchannel - The Alphabetcs channel you wish to set in another variable
    _indexToChange - The index you want changing

Returns:
	Returns - "invalid" if it is considered an invalid ace code

Examples:
    Success = [_heli, "Primary_Alternate", "D", 0] call fza_fnc_setLaserChannels;

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_Request", "_NewLaserchannel","_indexToChange"];

_check = false;
_Update = [];

//Grab Library of codes
private _laserChannelIndex = _heli getvariable "fza_ah64_LaserChannelIndex";

//Update Index
private _LRFD_LST_channel = _heli getvariable "fza_ah64_LRFD_LST_channel";
private _LaserBoxChannels = _heli getvariable "fza_ah64_LaserBoxChannels";
private _PrimaryAlternateChannels = _heli getvariable "fza_ah64_PrimaryAlternateChannels";

//Update Index
{
    _x params ["_letter","_code"];
    if (((_letter) find _NewLaserchannel)>=0) then {
        _Update = _x;
        _check = true;
    };
} forEach _laserChannelIndex;

if (_Update isEqualTo []) exitwith {false;};

switch _request do {
    case "Primary_Alternate": {
        _PrimaryAlternateChannels set [_indexToChange,_Update];
        _heli setVariable ["fza_ah64_PrimaryAlternateChannels", _PrimaryAlternateChannels, true];
    };
    case "LRST_LST": {
        _LRFD_LST_channel set [_indexToChange,_change];
        _heli setVariable ["fza_ah64_LRFD_LST_channel", _LRFD_LST_channel, true];
    };
    case "LaserBoxChannels": {
        _LaserBoxChannels set [_indexToChange,_change];
        _heli setVariable ["fza_ah64_LaserBoxChannels", _LaserBoxChannels, true];
    };
};
_check;