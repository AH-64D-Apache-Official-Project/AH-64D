_heli = _this select 0;
_system = _this select 1;

_rand = round(random 10);

if (_rand > 5) then {
    _mags = _heli magazinesturret[-1];
    if (_system == "rfab" && !("fza_ah64_rdp_fail" in _mags)) exitwith {
        _heli addmagazineturret["fza_ah64_rdp_fail", [-1]];
    };
    if (_system == "lfab" && !("fza_ah64_ldp_fail" in _mags)) exitwith {
        _heli addmagazineturret["fza_ah64_ldp_fail", [-1]];
    };
    if (_system == "rfab" && _rand > 7 && !("fza_ah64_rwp_fail" in _mags)) exitwith {
        _heli addmagazineturret["fza_ah64_rwp_fail", [-1]];
    };
    if (_system == "lfab" && _rand > 7 && !("fza_ah64_lwp_fail" in _mags)) exitwith {
        _heli addmagazineturret["fza_ah64_lwp_fail", [-1]];
    };
};