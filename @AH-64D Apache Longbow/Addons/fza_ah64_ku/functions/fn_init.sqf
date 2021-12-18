params ["_heli"];
#include "\fza_ah64_ku\headers\constants.hpp"

_heli setVariable ["fza_ku_state", KU_STATE_OFF];
_heli setVariable ["fza_ku_prompt", ""];
_heli setVariable ["fza_ku_checker", {true}];
_heli setVariable ["fza_ku_callback", {}];
_heli setVariable ["fza_ku_input", ""];
_heli setVariable ["fza_ku_user", nil];
