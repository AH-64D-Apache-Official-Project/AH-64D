#include "\fza_ah64_controls\headers\systemConstants.h"
// The ANTS: the next of the top FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS after the NTS, not one in an active NF zone; -1 if none
params ["_display", "_ntsIndex"];

if (_ntsIndex == -1) exitWith {-1};
private _n = count _display min FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS;
private _ants = -1;
for "_k" from 1 to _n - 1 do {
    private _i = (_ntsIndex + _k) mod _n;
    if (((_display # _i) param [7, 0]) != 2) exitWith {_ants = _i};
};
_ants
