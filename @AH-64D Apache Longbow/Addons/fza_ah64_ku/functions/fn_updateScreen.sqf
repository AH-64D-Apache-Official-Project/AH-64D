params ["_heli"];
#include "\fza_ah64_ku\headers\constants.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

[_heli, MFD_IND_KU_STATE, [0,1] select (_heli getVariable "fza_ku_state" == KU_STATE_ERROR)] call fza_mpd_fnc_updateMfdValue;

if (_heli getVariable "fza_ku_state" == KU_STATE_OFF) exitWith {
    [_heli, MFD_TEXT_IND_KU, ""] call fza_mpd_fnc_updateMfdText;
};

private _out = format["%1: %2", _heli getVariable "fza_ku_prompt", _heli getVariable "fza_ku_input"];

#define MAX_DISPLAY_CHARS 22

if (count _out > MAX_DISPLAY_CHARS) then {
    _out = _out select [count _out - MAX_DISPLAY_CHARS, MAX_DISPLAY_CHARS];
};
[_heli, MFD_TEXT_IND_KU, _out] call fza_mpd_fnc_updateMfdText;