_heli = _this select 0;

while {
    (alive _heli) && (damage _heli > 0.01) && ("fza_ah64_fwd_leak" in (_heli magazinesturret[-1]) || "fza_ah64_aft_leak" in (_heli magazinesturret[-1]))
}
do {
    waituntil {
        player in _heli
    };
    _heli setfuel((fuel _heli) - 0.0003);
    sleep 0.1;
};