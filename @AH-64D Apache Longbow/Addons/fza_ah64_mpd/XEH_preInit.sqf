["fza_dms_pointDeleted", {
    params ["_heli", "_id"];
    if (_heli getVariable "fza_mpd_tsdWptCurrentSel" isEqualTo _id) then {
        _heli setVariable ["fza_mpd_tsdWptCurrentSel", []];
    };
}] call CBA_fnc_addEventHandler;