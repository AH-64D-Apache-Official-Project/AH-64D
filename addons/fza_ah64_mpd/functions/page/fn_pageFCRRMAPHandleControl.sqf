#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_control"];

switch _control do {
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t1": {
        _heli setVariable ["fza_ah64_fcrcscope", !(_heli getVariable "fza_ah64_fcrcscope")];
    };
    case "t6": {
        [_heli, _mpdIndex, "fcrutil"] call fza_mpd_fnc_setCurrentPage;
    };
    case "l1": {
        [_heli] call fza_fcr_fnc_cycleNTS;
    };
    case "l2": {
        [_heli, -1] call fza_fcr_fnc_slewCenterline;
    };
    case "l4": {
        // TGT — designate NTS as acquisition source (same as existing FCR TGT behavior)
        [_heli] call fza_fcr_fnc_cycleNTS;
    };
    case "r1": {
        // ZOOM — TM 4.42.3 6:1 display zoom, not implemented; scan size is the grip switch
    };
    case "r2": {
        [_heli, 1] call fza_fcr_fnc_slewCenterline;
    };
    case "r4": {
        // RFHO — RF handover (fire to LOBL transition)
        // Placeholder — implement RFHO logic when available
    };
    case "r6": {
        // ACQ — cycle acquisition source (handled by targeting system at higher level)
    };
};
