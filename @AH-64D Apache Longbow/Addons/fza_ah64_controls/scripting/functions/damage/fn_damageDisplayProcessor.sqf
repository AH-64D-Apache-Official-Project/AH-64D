/* ----------------------------------------------------------------------------
Function: fza_fnc_damageDisplayProcessor

Description:
    Event handler that decides if a display processor was damaged, and declares that damage.

Parameters:
    _heli - The helicopter to modify
    _system - the *HitPoint* that was damaged.

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "rfab"] call fza_fnc_damageDisplayProcessor
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
private["_heli", "_system"];

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