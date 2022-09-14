/* ----------------------------------------------------------------------------
Function: fza_fnc_getLaserCode

Description:
	Call up and laser Info for any channel

Parameters:
    _heli - the helicopter
    _request = "Primary_Alternate"
               "LRST_LST"
               "LaserBoxChannels"
               "LaserChannelIndex"
    _index - the index in the desired array

Returns:
	returns the Channel letter & code

Examples:
    _result = [_heli, _Request, _index] call fza_fnc_getLaserCode;

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_request", "_index"];

Private _channelInfo = false;

switch _request do {
    case "Primary_Alternate": {
        _channelInfo = (_heli getvariable "fza_ah64_PrimaryAlternateChannels") # _index;
    };
    case "LRST_LST": {
        _channelInfo = (_heli getvariable "fza_ah64_LRFD_LST_channel") # _index;
    };
    case "LaserBoxChannels": {
        _channelInfo = (_heli getvariable "fza_ah64_LaserBoxChannels") # _index;
    };
    case "LaserChannelIndex": {
        _channelInfo = (_heli getvariable "fza_ah64_LaserChannelIndex");
    };
};
_channelInfo;