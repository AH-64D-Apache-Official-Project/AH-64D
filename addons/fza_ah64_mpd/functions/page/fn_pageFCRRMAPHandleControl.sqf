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
        // Left arrow — shift azimuth scan centerline left
        private _azBias = _heli getVariable ["fza_ah64_fcrAzBias", 0];
        private _halfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
        _azBias = (_azBias - 15) max -(_halfFov);
        _heli setVariable ["fza_ah64_fcrAzBias", _azBias, true];
    };
    case "l4": {
        // TGT — designate NTS as acquisition source (same as existing FCR TGT behavior)
        [_heli] call fza_fcr_fnc_cycleNTS;
    };
    case "r1": {
        // ZOOM — cycle scan size (WIDE → MED → NRW → ZOOM)
        private _halfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
        private _newFov = switch (round _halfFov) do {
            case 45:  { 22.5 };  // WIDE -> MED
            case 22:  { 11.25 }; // MED  -> NRW
            case 11:  { 5.625 }; // NRW  -> ZOOM
            default   { 45 };    // ZOOM -> WIDE
        };
        _heli setVariable ["fza_ah64_fcrGtmHalfFov", _newFov, true];
    };
    case "r2": {
        // Right arrow — shift azimuth scan centerline right
        private _azBias = _heli getVariable ["fza_ah64_fcrAzBias", 0];
        private _halfFov = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
        _azBias = (_azBias + 15) min _halfFov;
        _heli setVariable ["fza_ah64_fcrAzBias", _azBias, true];
    };
    case "r4": {
        // RFHO — RF handover (fire to LOBL transition)
        // Placeholder — implement RFHO logic when available
    };
    case "r6": {
        // ACQ — cycle acquisition source (handled by targeting system at higher level)
    };
};
