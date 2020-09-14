private["_heli"];
_heli = _this select 0;

if (!(player in _heli)) exitwith {};

if (count fza_ah64_waypointdata > 0) then {
    _wpdistr = (fza_ah64_wpdistr - ([(fza_ah64_curwp select 0), (fza_ah64_curwp select 1), 0] distance[(getpos _heli select 0), (getpos _heli select 1), 0])) * 33;
    if (_wpdistr == 0) then {
        _wpdistr = 1;
    };

    _wptime = ([(fza_ah64_curwp select 0), (fza_ah64_curwp select 1), 0] distance[(getpos _heli select 0), (getpos _heli select 1), 0]) / _wpdistr;
    if (_wptime > 32400) then {
        _wptime = 32400;
    };
    if (_wptime < 0) then {
        _wptime = 0;
    };

    _wptimhr = round(floor(_wptime * 0.0002778));
    _wptim = round(60 * ((_wptime * 0.0002778) - floor(_wptime * 0.0002778)));
    _wptimtm = round(10 * (((floor(_wptim * 0.1)) * 0.1) - floor((floor(_wptim * 0.1)) * 0.1)));
    _wptimsm = round(10 * ((_wptim * 0.1) - floor(_wptim * 0.1)));
    if (_wptime < 60) then {
        _wptimtm = round(floor(_wptime * 0.1));
        _wptimsm = round(10 * ((_wptime * 0.1) - (floor(_wptime * 0.1))));
        if (_wptimtm > 9) then {
            _wptimtm = 9;
        };
        if (_wptimsm > 9) then {
            _wptimsm = 9;
        };
    };

    fza_ah64_wptimhr = _wptimhr;
    fza_ah64_wptim = _wptim;
    fza_ah64_wptimtm = _wptimtm;
    fza_ah64_wptimsm = _wptimsm;

    fza_ah64_wpdistr = [(fza_ah64_curwp select 0), (fza_ah64_curwp select 1), 0] distance[(getpos _heli select 0), (getpos _heli select 1), 0];
} else {
    fza_ah64_wptimhr = 0;
    fza_ah64_wptim = 0;
    fza_ah64_wptimtm = 0;
    fza_ah64_wptimsm = 0;
    fza_ah64_wpdistr = 0;
};