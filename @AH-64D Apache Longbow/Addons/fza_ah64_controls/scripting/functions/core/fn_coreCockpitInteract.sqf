params ["_heli", "_system", "_control"];

switch (_system) do {
    case "lmpd";
    case "rmpd" : {
        [_heli, _system, _control] call fza_mpd_fnc_handleControl;
    };
    case "fire": {
        [_heli, _system, _control] call fza_fnc_fireHandleControl;
    };
    case "door": {
        if (_control == "handle") then {
            if (player == gunner _heli) then {
                [_heli] spawn fza_fnc_doortoggleG;
            } else {
                [_heli] spawn fza_fnc_doortogglep;
            };
        }
    };
    case "engine": {
        [_heli, _system, _control] call fza_fnc_engineHandleControl;
    };
    case "ihadss": {
        [_heli, _system, _control] call fza_fnc_ihadssHandleControl;
    };
    case "nvs": {
        private _nvsSwitch = (if (driver _heli == player) then {"plt_nvsmode"} else {"cpg_nvsmode"});
        if (_control == "mode") then {
            if (_heli animationphase _nvsSwitch < 1) then {
                _heli animateSource[_nvsSwitch, 1];
                _heli setVariable ["fza_ah64_ihadss_pnvs_cam", true];
            } else {
                _heli animateSource[_nvsSwitch, 0];
                _heli setVariable ["fza_ah64_ihadss_pnvs_cam", false];
            };
            ["fza_ah64_switch_flip3", 0.1] spawn fza_fnc_playAudio;
        }
    };
    case "light": {
        [_heli, _system, _control] call fza_fnc_lightHandleControl;
    };
    case "ku": {
        [_heli, _system, _control] call fza_ku_fnc_toggleInput;
    };
};