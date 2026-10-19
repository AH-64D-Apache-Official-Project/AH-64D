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
    // t6 UTIL — FCR utility page not implemented
    case "l1": {
        // PROF — cycle profile mode: GEOM(0) → ARITH(1) → TEST(2) → GEOM(0)
        private _profMode = _heli getVariable ["fza_ah64_fcrTpmProfMode", 0];
        _heli setVariable ["fza_ah64_fcrTpmProfMode", (_profMode + 1) mod 3, true];
    };
    case "l2": {
        // LINES — cycle displayed terrain line count: 0 → 1 → 2 → 3 → 4 → 0
        private _lines = _heli getVariable ["fza_ah64_fcrTpmLines", 4];
        _heli setVariable ["fza_ah64_fcrTpmLines", (_lines + 1) mod 5, true];
    };
    case "r1": {
        // CLEARANCE — cycle clearance plane: 20ft(0) → 50ft(1) → 100ft(2) → 200ft(3) → 20ft(0)
        private _clearance = _heli getVariable ["fza_ah64_fcrTpmClearance", 1];
        _heli setVariable ["fza_ah64_fcrTpmClearance", (_clearance + 1) mod 4, true];
    };
    case "r2": {
        // ELEV — antenna elevation FAR (-0.5 deg, high terrain out to 2500 m) or NEAR (-3 deg, rain and short range)
        private _elev = _heli getVariable ["fza_ah64_fcrTpmElev", 0];
        _heli setVariable ["fza_ah64_fcrTpmElev", 1 - _elev, true];
    };
};
