params ["_heli", "_activeWarn", "_mpdText", "_ufdText", "_priority", "_audio", "_audioLength"];
#include "\fza_ah64_controls\headers\wcaConstants.h"

hintsilent format ["Act Warn = %1
                    \nMpd Text = %2", _activeWarn, _mpdText];

private _wcaAdd = [WCA_WARNING, _mpdText, _ufdText];

if !(_mpdText in _activeWarn) then {
    _heli setVariable ["fza_ah64_mstrWarnLightOn", true, true];
    _activeWarn set [_mpdText, true];
    [_heli, _priority, _audio, _audioLength] call fza_audio_fnc_addWarning;
};

_wcaAdd;