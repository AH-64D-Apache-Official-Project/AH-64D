params ["_heli"];
#include "\fza_ah64_ku\headers\constants.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

_heli setUserMfdValue [MFD_IND_KU_STATE, [0,1] select (_heli getVariable "fza_ku_state" == 2)];

if (_heli getVariable "fza_ku_state" == 0) exitWith {
    _heli setUserMfdText [MFD_TEXT_IND_KU, ""];
};

private _out = format["%1: %2", _heli getVariable "fza_ku_prompt", _heli getVariable "fza_ku_input"];

#define MAX_DISPLAY_CHARS 22

if (count _out > MAX_DISPLAY_CHARS) then {
    _out = _out select [count _out - MAX_DISPLAY_CHARS, MAX_DISPLAY_CHARS];
};
_heli setUserMfdText [MFD_TEXT_IND_KU, _out];