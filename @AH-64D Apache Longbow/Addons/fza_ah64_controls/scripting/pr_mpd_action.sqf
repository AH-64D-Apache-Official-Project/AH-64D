_heli = _this select 0;
_actionadd = 0;
_actionaddl = 0;
_object1 = "fza_ah64_ic"
createvehiclelocal(getpos _heli);
_object2 = "fza_ah64_ic"
createvehiclelocal(getpos _heli);
_object1 attachto[_heli, [1, 8, -3]];
_object2 attachto[_heli, [-1, 8, -3]];
while {
    (alive _heli)
}
do {
    waituntil {
        driver _heli == player
    };
    _mpdarea = worldtoscreen(getpos _object1);
    _mpdareal = worldtoscreen(getpos _object2);
    _mpdareax = _mpdarea select 0;
    _mpdareay = _mpdarea select 1;
    _mpdarealx = _mpdareal select 0;
    _mpdarealy = _mpdareal select 1;
    if (_actionadd == 0 && _mpdareax > 0.3 && _mpdareax < 0.6 && _mpdareay > 0.3 && _mpdareay < 0.6) then {
        _actionadd = 1;
        fza_ah64_mpd_action1 = _heli addaction["Filter TSD Targets 2", "\fza_ah64_US\scripting\tsd_targfilter.sqs"];
    };
    if (_mpdareax < 0.3 || _mpdareax > 0.6 || _mpdareay < 0.3 || _mpdareay > 0.6) then {
        _actionadd = 0;
        _heli removeaction fza_ah64_mpd_action1;
    };
    sleep 0.03;
};