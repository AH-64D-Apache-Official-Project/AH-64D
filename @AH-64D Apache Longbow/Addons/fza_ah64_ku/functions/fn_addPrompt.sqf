params ["_heli", "_prompt", "_callback", ["_checker", {true}], "_user"];
#include "\fza_ah64_ku\headers\constants.hpp"

_heli setVariable ["fza_ku_state", KU_STATE_INPUT];
_heli setVariable ["fza_ku_prompt", _prompt];
_heli setVariable ["fza_ku_checker", _checker];
_heli setVariable ["fza_ku_callback", _callback];
_heli setVariable ["fza_ku_input", ""];
_heli setVariable ["fza_ku_user", _user];

[_heli] call fza_ku_fnc_update