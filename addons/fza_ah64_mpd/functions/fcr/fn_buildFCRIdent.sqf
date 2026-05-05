/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_buildFCRIdent

Description:
    Builds a standardised FCR icon ident string from a target record entry.
    Used by all FCR display contexts: ATM/GTM page draw, TSD page draw,
    cscope IHADSS, and shot-record functions.

Parameters:
    _type          - FCR_TYPE_* integer (fza_ah64_fcrTargets record index 1)
    _distance_m    - Real 2D distance in metres (distance2D or stored range)
    _moving        - Boolean, target is moving
    _selStatus     - (optional, default 0) 0=none, 1=NTS, 2=ANTS
    _wasWeaponNone - (optional, default false) True when WAS_WEAPON_NONE, adds NOMSL suffix

Returns:
    String - FCR ident for FzaIconTypes config, e.g. "FCR_HELI_MOVE_NTS".
             Returns "" when target is outside valid engagement range; caller should skip.

Examples:
    private _ident = [_type, _distance_m, _moving] call fza_mpd_fnc_buildFCRIdent;
    private _ident = [_type, _distance_m, _moving, 1, true] call fza_mpd_fnc_buildFCRIdent;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_type", "_distance_m", "_moving", ["_selStatus", 0], ["_wasWeaponNone", false]];

// Out-of-range: signal caller to skip this target
if (_distance_m < FCR_LIMIT_MIN_RANGE || _distance_m > FCR_LIMIT_STATIONARY_RANGE) exitWith { "" };

// Resolve unit type string
private _unitType = switch (_type) do {
    case FCR_TYPE_HELICOPTER: { "HELI" };
    case FCR_TYPE_FLYER:      { "FLYER" };
    case FCR_TYPE_TRACKED:    { "TRACK" };
    case FCR_TYPE_WHEELED:    { "WHEEL" };
    case FCR_TYPE_ADU:        { "ADU" };
    default                   { "UNK" };
};

// Resolve engagement status
private _unitStatus = if ((_moving && _distance_m <= FCR_LIMIT_MOVING_RANGE) || _unitType == "FLYER") then {
    "MOVE"
} else {
    if (_distance_m <= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) then { "LOBL" } else { "LOAL" }
};

// Build optional selection / weapon suffix
private _suffix = switch (_selStatus) do {
    case 1: { if (_wasWeaponNone) then { ["NTS", "NOMSL"] } else { ["NTS"] } };
    case 2: { ["ANTS"] };
    default { [] };
};

(["FCR", _unitType, _unitStatus] + _suffix) joinString "_"
