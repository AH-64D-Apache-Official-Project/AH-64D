params ["_heli"];
#include "\fza_ah64_ku\headers\constants.hpp"

switch (_heli getVariable "fza_ku_state") do {
    case KU_STATE_INPUT: {
        private _input = _heli getVariable "fza_ku_input";
        ([_input, _user, _heli] call (_heli getVariable "fza_ku_checker"))
            params ["_success", ["_ret", _input]];
        
        if (_success) then {
            [_ret, _user, _heli] call (_heli getVariable "fza_ku_callback");
            _heli setVariable ["fza_ku_state", KU_STATE_OFF];
        } else {
            _heli setVariable ["fza_ku_state", KU_STATE_ERROR];
        };
    };
    case KU_STATE_ERROR: {
        _heli setVariable ["fza_ku_state", KU_STATE_INPUT];
        _heli setVariable ["fza_ku_input", ""];
    };
};

[_heli] call fza_ku_fnc_update