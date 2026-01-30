params ["_heli", "_activeWarn", "_mpdText", "_ufdText", "_priority", "_audio", "_audioLength"];
#include "\fza_ah64_controls\headers\wcaConstants.h"

private _wcaAdd = [WCA_WARNING, _mpdText, _ufdText];

if !(_mpdText in _activeWarn) then {
    [_heli, "fza_ah64_mstrWarnLightOn", true] call fza_fnc_updateNetworkGlobal;
    _activeWarn set [_mpdText, true];
    [_heli, _priority, _audio, _audioLength] call fza_audio_fnc_addWarning;
};

[_wcaAdd];