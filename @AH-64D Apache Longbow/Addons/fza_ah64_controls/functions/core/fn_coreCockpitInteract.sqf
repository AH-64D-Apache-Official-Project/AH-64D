params ["_heli", "_system", "_control"];

switch (_system) do {
    case "door": {
        if (_control == "handle") then {
            if (player == gunner _heli) then {
                [_heli] spawn fza_fnc_doortoggleG;
            } else {
                [_heli] spawn fza_fnc_doortogglep;
            };
        }
    };
    case "ihadss": {
        [_heli, _system, _control] call fza_ihadss_fnc_handleControl;
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
            playsound "fza_ah64_switch_flip3";
        };
    };
    case "light": {
        [_heli, _system, _control] call fza_light_fnc_handleControl;
    };
    case "ku": {
        [_heli, _system, _control] call fza_ku_fnc_toggleInput;
    };
    case "armSafeBtn": {
        [_heli, _system, _control] call fza_wca_fnc_wcaBtnHandleControl;
    };
    case "gndOrideBtn": {
        [_heli, _system, _control] call fza_wca_fnc_wcaBtnHandleControl;
    };
    case "emerHydBtn": {
        [_heli, _system, _control] call fza_wca_fnc_wcaBtnHandleControl;
    };
    case "mstrCautBtn": {
        [_heli, _system, _control] call fza_wca_fnc_wcaBtnHandleControl;
    };
    case "mstrWarnBtn": {
        [_heli, _system, _control] call fza_wca_fnc_wcaBtnHandleControl;
    };
};