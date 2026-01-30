params ["_heli", "_activeCaut", "_mpdText", "_ufdText", "_playCautAudio"];
#include "\fza_ah64_controls\headers\wcaConstants.h"

private _wcaAdd    = [WCA_CAUTION, _mpdText, _ufdText];

if !(_ufdText in _activeCaut) then {
    [_heli, "fza_ah64_mstrCautLightOn", true] call fza_fnc_updateNetworkGlobal;
    _activeCaut set [_ufdText, true];
    _playCautAudio = true;
};

[_wcaAdd, _playCautAudio];