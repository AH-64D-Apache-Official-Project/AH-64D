params ["_heli", "_system", "_control"];

switch (_system) do {
    case "lmpd";
    case "rmpd" : {
        [_heli, _system, _control] call fza_mpd_fnc_handleControl;
    };
    case "fire": {
        [_heli, _system, _control] call fza_fire_fnc_handleControl;
    };
    case "door": {
        [_heli] spawn fza_fnc_doortoggle;
    };
    case "engine": {
        [_heli, _system, _control] call fza_fnc_engineHandleControl;
    };
    case "ihadss": {
        [_heli, _system, _control] call fza_ihadss_fnc_handleControl;
    };
    case "nvs": {
        [_heli, _system, _control] call fza_ihadss_fnc_handleControl;
    };
    case "light": {
        [_heli, _system, _control] call fza_light_fnc_handleControl;
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