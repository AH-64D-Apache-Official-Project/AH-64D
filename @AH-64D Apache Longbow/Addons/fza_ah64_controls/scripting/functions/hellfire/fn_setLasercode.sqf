/* ----------------------------------------------------------------------------
Function: fza_fnc_setLaserCode

Description:
	Setting of Ace laser code

Parameters:
    _heli - the helicopter
    _channel - the channel Letter for the desired channel
    _code the code you wish to set it to

Returns:
	Returns - "invalid" if it is considered an invalid ace code

Examples:
    Success = [_heli, "A", "1112"] call fza_fnc_setLaserCode;

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_Channel","_newCode"];

//Invalid code check
_check = false;
if ((_newCode < 1110) || (_newCode > 1789)) exitwith {_check;};
if ((((str _newCode) find "0") >= 0) || (((str _newCode) find "9") >= 0)) exitwith {_check;};

//set new code in index
private _laserChannelIndex = _heli getvariable "fza_ah64_LaserChannelIndex";
private _LRFD_LST_channel = _heli getvariable "fza_ah64_LRFD_LST_channel";
private _LaserBoxChannels = _heli getvariable "fza_ah64_LaserBoxChannels";
private _PrimaryAlternateChannels = _heli getvariable "fza_ah64_PrimaryAlternateChannels";

//Update Index
{
    _x params ["_letter","_code"];
    if (((_letter) find _Channel)>=0) then {
        _laserChannelIndex set [_foreachindex,[_letter, _newCode]];
        _check = true;
    };
} forEach _laserChannelIndex;

//Update LRFD & LST
{
    _x params ["_letter","_code"];
    if (((_letter) find _Channel)>=0) then {
        _LRFD_LST_channel set [_foreachindex,[_letter, _newCode]];
        _check = true;
    };
} forEach _LRFD_LST_channel;

//Update Laser Box Channel
{
    _x params ["_letter","_code"];
    if (((_letter) find _Channel)>=0) then {
        _LaserBoxChannels set [_foreachindex,[_letter, _newCode]];
        _check = true;
    };
} forEach _LaserBoxChannels;

//Update Laser Box Channel
{
    _x params ["_letter","_code"];
    if (((_letter) find _Channel)>=0) then {
        _PrimaryAlternateChannels set [_foreachindex,[_letter, _newCode]];
        _check = true;
    };
} forEach _PrimaryAlternateChannels;

_heli setVariable ["fza_ah64_LaserChannelIndex", _laserChannelIndex, true];
_heli setVariable ["fza_ah64_LRFD_LST_channel", _LRFD_LST_channel, true];
_heli setVariable ["fza_ah64_LaserBoxChannels", _LaserBoxChannels, true];
_heli setVariable ["fza_ah64_PrimaryAlternateChannels", _PrimaryAlternateChannels, true];

_check;