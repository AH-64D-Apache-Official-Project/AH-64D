params ["_heli", "_system", "_control"];

switch (_system) do {
    case "ihadss": {
        [_heli, _system, _control] call fza_ihadss_fnc_handleControl;
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