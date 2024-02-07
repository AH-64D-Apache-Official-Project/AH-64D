["fza_dms_pointDeleted", {
    params ["_heli", "_id"];
    if (_heli getVariable "fza_mpd_tsdWptCurrentSel" isEqualTo _id) then {
        _heli setVariable ["fza_mpd_tsdWptCurrentSel", []];
    };
    if (_heli getVariable "fza_mpd_tsdThrtCurrentSel" isEqualTo _id) then {
        _heli setVariable ["fza_mpd_tsdThrtCurrentSel", []];
    };

    if (_heli getVariable "fza_mpd_tsdRteCurrentSel" isEqualTo _id) then {
        _heli setVariable ["fza_mpd_tsdRteCurrentSel", []];
    };
    if (_heli getVariable "fza_mpd_tsdRteCurrentRvw" isEqualTo _id) then {
        _heli setVariable ["fza_mpd_tsdRteCurrentRvw", -1];
    };
    private _currentDir = _heli getVariable "fza_dms_routeNext";
    private _wptAprch = _heli getvariable "fza_ah64_wptAprch";
    if (_id isEqualTo _wptAprch#0) then {
        [_heli, "fza_ah64_wptAprch", [-1, false]] call fza_fnc_updateNetworkGlobal;
    };
    if (_currentDir isEqualTo _id) then {
        [_heli, []] call fza_dms_fnc_routeSetDir;
    };
}] call CBA_fnc_addEventHandler;