#include "\fza_ah64_ku\headers\constants.hpp"
params ["_heli"];

_heli setVariable ["fza_ku_state", KU_STATE_OFF];
_heli setVariable ["fza_ku_prompt", ""];
_heli setVariable ["fza_ku_checker", {true}];
_heli setVariable ["fza_ku_callback", {}];
_heli setVariable ["fza_ku_input", ""];
_heli setVariable ["fza_ku_user", nil];
_heli setVariable ["fza_ku_inputType", ""];
[_heli] call fza_ku_fnc_updateScreen;
[] call fza_ku_fnc_stopInput;