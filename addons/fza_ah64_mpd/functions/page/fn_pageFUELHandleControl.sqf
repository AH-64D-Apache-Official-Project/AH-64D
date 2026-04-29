params ["_heli", "_mpdIndex", "_control"];

switch(_control) do {
    // Page navigation
    case "t2": { [_heli, _mpdIndex, "flt"]    call fza_mpd_fnc_setCurrentPage; };
    case "t3": { [_heli, _mpdIndex, "eng"]    call fza_mpd_fnc_setCurrentPage; };
    case "t4": { [_heli, _mpdIndex, "perf"]   call fza_mpd_fnc_setCurrentPage; };
    case "t6": { [_heli, _mpdIndex, "acutil"] call fza_mpd_fnc_setCurrentPage; };
    case "b1": { [_heli, _mpdIndex, "menu"]   call fza_mpd_fnc_setCurrentPage; };

    // l1 — FWD when XFER menu open; AUX L toggle otherwise
    case "l1": {
        if (_heli getVariable ["fza_fuel_xferMenuOpen", false]) then {
            _heli setVariable ["fza_fuel_xferMode", "FWD"];
            _heli setVariable ["fza_fuel_xferMenuOpen", false];
        } else {
            _heli setVariable ["fza_fuel_lAuxOn", !(_heli getVariable ["fza_fuel_lAuxOn", false])];
        };
    };

    // l2 — OFF when XFER menu open; IAFS/C AUX toggle otherwise
    case "l2": {
        if (_heli getVariable ["fza_fuel_xferMenuOpen", false]) then {
            _heli setVariable ["fza_fuel_xferMode", "OFF"];
            _heli setVariable ["fza_fuel_xferMenuOpen", false];
        } else {
            if (_heli getVariable ["fza_ah64_IAFSInstalled", false]) then {
                _heli setVariable ["fza_ah64_IAFSOn", !(_heli getVariable ["fza_ah64_IAFSOn", false])];
            };
        };
    };

    // l3 — AFT when XFER menu open; open XFER menu otherwise
    case "l3": {
        if (_heli getVariable ["fza_fuel_xferMenuOpen", false]) then {
            _heli setVariable ["fza_fuel_xferMode", "AFT"];
            _heli setVariable ["fza_fuel_xferMenuOpen", false];
        } else {
            _heli setVariable ["fza_fuel_xferMenuOpen", true];
        };
    };

    // l4 — AUTO when XFER menu open; close menu otherwise (double-press l3/l4 closes)
    case "l4": {
        if (_heli getVariable ["fza_fuel_xferMenuOpen", false]) then {
            _heli setVariable ["fza_fuel_xferMode", "AUTO"];
            _heli setVariable ["fza_fuel_xferMenuOpen", false];
        };
    };

    // r1 — AUX R (stn3 inner-right) on/off
    case "r1": {
        _heli setVariable ["fza_fuel_rAuxOn", !(_heli getVariable ["fza_fuel_rAuxOn", false])];
    };

    // r2 — Boost pump toggle; boost on forces crossfeed AFT, off resets to NORM
    case "r2": {
        private _newBoost = !(_heli getVariable ["fza_fuel_boostOn", false]);
        _heli setVariable ["fza_fuel_boostOn", _newBoost];
        if (_newBoost) then {
            _heli setVariable ["fza_fuel_crossfeedMode", "AFT"];
        } else {
            _heli setVariable ["fza_fuel_crossfeedMode", "NORM"];
        };
    };

    // r3 / r4 / r5 — Crossfeed valve position (locked to AFT when boost is on)
    case "r3": { if !(_heli getVariable ["fza_fuel_boostOn", false]) then { _heli setVariable ["fza_fuel_crossfeedMode", "FWD"];  }; };
    case "r4": { if !(_heli getVariable ["fza_fuel_boostOn", false]) then { _heli setVariable ["fza_fuel_crossfeedMode", "NORM"]; }; };
    case "r5": { if !(_heli getVariable ["fza_fuel_boostOn", false]) then { _heli setVariable ["fza_fuel_crossfeedMode", "AFT"];  }; };

    // b6 — CHECK sub-mode toggle
    case "b6": {
        private _active = _heli getVariable ["fza_fuel_checkActive", false];
        if (_active) then {
            _heli setVariable ["fza_fuel_checkActive",    false];
            _heli setVariable ["fza_fuel_checkStartTime", 0];
            _heli setVariable ["fza_fuel_checkStartFuel", 0];
        } else {
            _heli setVariable ["fza_fuel_checkActive",    true];
            _heli setVariable ["fza_fuel_checkStartTime", 0];
        };
    };
};
