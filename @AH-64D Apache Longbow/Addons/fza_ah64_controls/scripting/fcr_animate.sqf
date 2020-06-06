_heli = _this select 0;
_reverse = 0;

_heli animate["longbow", -0.125];
sleep 2;

while {
    (alive _heli)
}
do {
    waituntil {
        player in _heli && fza_ah64_fcrstate == 1 && (isengineon _heli || fza_ah64_apuon == 1) && local _heli && !("fza_ah64_fcr_fail" in (_heli magazinesturret[-1]))
    };

    if (fza_ah64_agmode != 1) then {
        if (_reverse == 0) then {
            _heli animate["longbow", (_heli animationphase "longbow") + 0.006250];
        };
        if (_reverse == 1) then {
            _heli animate["longbow", (_heli animationphase "longbow") - 0.006250];
        };
        if (_heli animationphase "longbow" >= 0.125) then {
            _reverse = 1;
        };
        if (_heli animationphase "longbow" <= -0.125) then {
            _reverse = 0;
        };
    };

    if (fza_ah64_agmode == 1) then {
        if (_heli animationphase "longbow" < 0.875) then {
            _heli animate["longbow", (_heli animationphase "longbow") + 0.006250];
        };
        if (_heli animationphase "longbow" >= 0.875) then {
            _heli animate["longbow", -0.125];
            sleep 0.01;
        };
    };

    _heli animate["mpd_pr_fcrag_wiper", (_heli animationphase "longbow")];
    _heli animate["mpd_pr_fcraa_wiper", (_heli animationphase "longbow")];
    _heli animate["mpd_pr_mpd_had_apos2_h", (_heli animationphase "longbow")];

    sleep 0.03;
};