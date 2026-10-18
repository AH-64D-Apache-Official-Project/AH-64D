/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_setMode

Description:
    Selects the FCR display mode. Selecting a new mode recentres the scan,
    clears the target file and cancels an active scan; the operator starts a
    new one. Re-selecting the active mode changes nothing, except RMAP where
    it toggles the video underlay.

Parameters:
    _heli - The helicopter
    _mode - FCR_DISP_MODE_GTM / ATM / RMAP / TPM

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mode"];

if ((_heli getVariable "fza_ah64_fcrMode") == _mode) exitWith {
    if (_mode == FCR_DISP_MODE_RMAP) then {
        _heli setVariable ["fza_ah64_fcrRmapVideo", !(_heli getVariable ["fza_ah64_fcrRmapVideo", true]), true];
    };
};

_heli setVariable ["fza_ah64_fcrMode", _mode, true];
if (_mode == FCR_DISP_MODE_RMAP) then {
    _heli setVariable ["fza_ah64_fcrRmapVideo", true, true];
};
// The video pages keep their last picture while hidden, so entering one starts it blank
if (_mode in [FCR_DISP_MODE_RMAP, FCR_DISP_MODE_TPM]) then {
    [_heli, _mode == FCR_DISP_MODE_RMAP, _mode == FCR_DISP_MODE_TPM] call fza_fcr_fnc_videoClear;
};
_heli setVariable ["fza_ah64_fcrAzBias", 0, true];
_heli setVariable ["fza_ah64_fcrCenterlineWorld", -1, true];
[_heli, "fza_ah64_fcrTargets", []] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_fcrNts", [objNull, [0,0,0], []]] call fza_fnc_updateNetworkGlobal;
[_heli] call fza_fcr_fnc_stopScan;
