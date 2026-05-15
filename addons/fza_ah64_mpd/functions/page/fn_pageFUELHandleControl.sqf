params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

private _chkActive  = (_state get "checkActive") > 0;
private _chkRunning = _heli getVariable ["fza_fuel_checkRunning", false];
private _chkDone    = _heli getVariable ["fza_fuel_checkDone",    false];

switch(_control) do {
    // Page navigation
    case "t2": { [_heli, _mpdIndex, "flt"]    call fza_mpd_fnc_setCurrentPage; };
    case "t3": { [_heli, _mpdIndex, "eng"]    call fza_mpd_fnc_setCurrentPage; };
    case "t4": { [_heli, _mpdIndex, "perf"]   call fza_mpd_fnc_setCurrentPage; };
    case "t6": { [_heli, _mpdIndex, "acutil"] call fza_mpd_fnc_setCurrentPage; };
    case "b1": { [_heli, _mpdIndex, "menu"]   call fza_mpd_fnc_setCurrentPage; };

    // l1 — FWD when XFER menu open; AUX L toggle otherwise
    case "l1": {
        if ((_state get "xferMenuOpen") > 0) then {
            [_heli, "fza_fuel_xferMode", "FWD"] call fza_fnc_updateNetworkGlobal;
            _state set ["xferMenuOpen", 0];
        } else {
            [_heli, "fza_fuel_lAuxOn", !(_heli getVariable ["fza_fuel_lAuxOn", false])] call fza_fnc_updateNetworkGlobal;
        };
    };

    // l2 — OFF when XFER menu open; IAFS/C AUX toggle otherwise
    case "l2": {
        if ((_state get "xferMenuOpen") > 0) then {
            [_heli, "fza_fuel_xferMode", "OFF"] call fza_fnc_updateNetworkGlobal;
            _state set ["xferMenuOpen", 0];
        } else {
            if (_heli getVariable ["fza_ah64_IAFSInstalled", false]) then {
                private _iafsOn  = _heli getVariable ["fza_ah64_IAFSOn", false];
                private _ctrMass = _heli getVariable ["fza_sfmplus_ctrFuelMass", 0];
                // Can turn off freely; can only turn on when CTR has fuel
                if (_iafsOn || _ctrMass > 0) then {
                    _heli setVariable ["fza_ah64_IAFSOn", !_iafsOn];
                };
            };
        };
    };

    // l3 — AFT when XFER menu open; nothing otherwise
    case "l3": {
        if ((_state get "xferMenuOpen") > 0) then {
            [_heli, "fza_fuel_xferMode", "AFT"] call fza_fnc_updateNetworkGlobal;
            _state set ["xferMenuOpen", 0];
        };
    };

    // l4 — AUTO when XFER menu open; open XFER menu otherwise
    case "l4": {
        if ((_state get "xferMenuOpen") > 0) then {
            [_heli, "fza_fuel_xferMode", "AUTO"] call fza_fnc_updateNetworkGlobal;
            _state set ["xferMenuOpen", 0];
        } else {
            _state set ["xferMenuOpen", 1];
        };
    };

    // r1 — AUX R (stn3 inner-right) on/off
    case "r1": {
        [_heli, "fza_fuel_rAuxOn", !(_heli getVariable ["fza_fuel_rAuxOn", false])] call fza_fnc_updateNetworkGlobal;
    };

    // r2 — CHECK 15 min when setup open; else boost pump toggle
    case "r2": {
        if (_chkActive) then {
            if (!_chkRunning) then {
                [_heli, "fza_fuel_checkMinutes", 15] call fza_fnc_updateNetworkGlobal;
            };
        } else {
            private _newBoost = !(_heli getVariable ["fza_fuel_boostOn", false]);
            [_heli, "fza_fuel_boostOn", _newBoost] call fza_fnc_updateNetworkGlobal;
            if (_newBoost) then {
                [_heli, "fza_fuel_crossfeedMode", "AFT"] call fza_fnc_updateNetworkGlobal;
            } else {
                [_heli, "fza_fuel_crossfeedMode", "NORM"] call fza_fnc_updateNetworkGlobal;
            };
        };
    };

    // r3 — CHECK 20 min when setup open; else crossfeed FWD (locked when boost on)
    case "r3": {
        if (_chkActive) then {
            if (!_chkRunning) then {
                [_heli, "fza_fuel_checkMinutes", 20] call fza_fnc_updateNetworkGlobal;
            };
        } else {
            if !(_heli getVariable ["fza_fuel_boostOn", false]) then {
                [_heli, "fza_fuel_crossfeedMode", "FWD"] call fza_fnc_updateNetworkGlobal;
            };
        };
    };

    // r4 — CHECK 30 min when setup open; else crossfeed NORM (locked when boost on)
    case "r4": {
        if (_chkActive) then {
            if (!_chkRunning) then {
                [_heli, "fza_fuel_checkMinutes", 30] call fza_fnc_updateNetworkGlobal;
            };
        } else {
            if !(_heli getVariable ["fza_fuel_boostOn", false]) then {
                [_heli, "fza_fuel_crossfeedMode", "NORM"] call fza_fnc_updateNetworkGlobal;
            };
        };
    };

    // r5 — START when check setup; STOP when check running; else crossfeed AFT
    case "r5": {
        if (_chkActive && !_chkRunning) then {
            // START (also clears any previous done state)
            if (_chkDone) then {
                [_heli, "fza_fuel_checkDone",        false] call fza_fnc_updateNetworkGlobal;
                [_heli, "fza_fuel_checkElapsedSec",  0]     call fza_fnc_updateNetworkGlobal;
                [_heli, "fza_fuel_checkBurnRate",    0]     call fza_fnc_updateNetworkGlobal;
                [_heli, "fza_fuel_checkBurnoutZulu", ""]    call fza_fnc_updateNetworkGlobal;
                [_heli, "fza_fuel_checkVFRZulu",     ""]    call fza_fnc_updateNetworkGlobal;
                [_heli, "fza_fuel_checkIFRZulu",     ""]    call fza_fnc_updateNetworkGlobal;
            };
            private _dh = floor dayTime;
            private _dm = floor ((dayTime - _dh) * 60);
            private _startFuelMass = _heli getVariable ["fza_sfmplus_totFuelMass", 0];
            [_heli, "fza_fuel_checkStartTime", CBA_missionTime] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_fuel_checkStartFuel", _startFuelMass]  call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_fuel_checkRunning",   true]            call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_fuel_checkStartZulu", format ["%1:%2L", _dh, [_dm, 2] call CBA_fnc_formatNumber]] call fza_fnc_updateNetworkGlobal;
        };
        if (_chkActive && _chkRunning && !_chkDone) then {
            // STOP — freeze elapsed and results
            private _totalFuelMass = _heli getVariable ["fza_sfmplus_totFuelMass", 0];
            private _startFuel     = _heli getVariable ["fza_fuel_checkStartFuel", _totalFuelMass];
            private _elapsed       = CBA_missionTime - (_heli getVariable ["fza_fuel_checkStartTime", CBA_missionTime]);
            private _burnRate      = if (_elapsed > 0) then { ((_startFuel - _totalFuelMass) * 2.20462) / (_elapsed / 3600) } else { 0 };
            private _burnoutHours  = if (_burnRate > 0) then { (_totalFuelMass * 2.20462) / _burnRate } else { 0 };
            private _fnZulu = {
                params ["_dt"];
                private _h = floor (_dt % 24);
                format ["%1:%2L", _h, [floor ((_dt % 24 - _h) * 60), 2] call CBA_fnc_formatNumber]
            };
            [_heli, "fza_fuel_checkRunning",     false]    call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_fuel_checkDone",        true]     call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_fuel_checkElapsedSec",  _elapsed] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_fuel_checkBurnRate",    _burnRate] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_fuel_checkBurnoutZulu", [dayTime + _burnoutHours]        call _fnZulu] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_fuel_checkVFRZulu",     [dayTime + _burnoutHours - 20/60] call _fnZulu] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_fuel_checkIFRZulu",     [dayTime + _burnoutHours - 30/60] call _fnZulu] call fza_fnc_updateNetworkGlobal;
        };
        if (!_chkActive && !(_heli getVariable ["fza_fuel_boostOn", false])) then {
            [_heli, "fza_fuel_crossfeedMode", "AFT"] call fza_fnc_updateNetworkGlobal;
        };
    };

    // b6 — CHECK UI toggle
    // Closing only hides the UI; a running check continues in the background.
    // Opening restores whatever state the check is in (setup/running/done).
    case "b6": {
        if ((_state get "checkActive") > 0) then {
            _state set ["checkActive", 0];
        } else {
            _state set ["checkActive", 1];
            [_heli, "fza_fuel_checkPendingAdvisory", false] call fza_fnc_updateNetworkGlobal;
        };
    };
};
