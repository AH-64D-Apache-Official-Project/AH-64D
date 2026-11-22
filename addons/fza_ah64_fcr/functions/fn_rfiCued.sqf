/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_rfiCued

Description:
    FCR cued search, for the crew station owning the FCR with it as the sight. Turns the centerline to an RFI
    emitter's bearing, in GTM (RMAP stays RMAP) for one on the ground or ATM for one in the air, at the cued scan
    size, and does one scanburst. The CUED switch cues the selected or No. 1 emitter, then each press the next. A
    symbol chosen with the cursor only sets the centerline and size, the scan switch then scans.

Parameters:
    _heli  - the helicopter
    _index - (optional) the emitter chosen with the cursor; -1, the CUED switch

Returns:
    Nothing

Examples:
    [_heli] call fza_fcr_fnc_rfiCued

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_ase\headers\ase.h"
// Cued scan sizes: medium for a coarse bearing, narrow for a fine one
#define RFI_CUED_SIZE_COARSE 1
#define RFI_CUED_SIZE_FINE   2
params ["_heli", ["_index", -1]];
private _picked = _index >= 0;

private _seat = [_heli] call fza_fnc_getSeat;
if (isNil "_seat" || {FCR_OWNER(_heli) != _seat}) exitWith {};
if (([_heli, "fza_ah64_sight", _seat] call fza_fnc_getSeatVariable) != SIGHT_FCR) exitWith {};

private _emitters = _heli getVariable ["fza_ah64_ase_rfiEmitters", []];
if (_emitters isEqualTo [] || {!([_heli] call fza_ase_fnc_rfiWorking)}) exitWith {
    _heli setVariable ["fza_ah64_rfiDataUntil_" + _seat, CBA_missionTime + 3];
};

if (_index < 0) then {
    (_heli getVariable ["fza_ah64_fcrCued", [false, objNull]]) params ["_active", "_last"];
    if (_active) then {
        _index = ((_emitters findIf {(_x # ASE_RFI_OBJ) isEqualTo _last}) + 1) % count _emitters;
    } else {
        private _selected = _heli getVariable ["fza_ah64_ase_rfiSel_" + _seat, objNull];
        _index = 0 max (_emitters findIf {!isNull _selected && {(_x # ASE_RFI_OBJ) isEqualTo _selected}});
    };
};
private _record = _emitters param [_index, []];
if (_record isEqualTo []) exitWith {};
([_heli, _record] call fza_ase_fnc_rfiBearing) params [["_world", -1], ["_rel", 0]];
if (_world < 0) exitWith {};

// Kept for the next press, though a ground emitter past the GTM's limits is not searched
_heli setVariable ["fza_ah64_fcrCued", [true, _record # ASE_RFI_OBJ], true];
private _air = _record # ASE_RFI_AIR;
if (!_air && {abs _rel > 90}) exitWith {
    _heli setVariable ["fza_ah64_rfiLimitsUntil_" + _seat, CBA_missionTime + 10];
};

if (((_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF]]) # 0) in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]) then {
    [_heli] call fza_fcr_fnc_stopScan;
};
private _mode = _heli getVariable ["fza_ah64_fcrMode", FCR_DISP_MODE_GTM];
private _want = if (_air) then {FCR_DISP_MODE_ATM} else {[FCR_DISP_MODE_GTM, _mode] select (_mode in [FCR_DISP_MODE_GTM, FCR_DISP_MODE_RMAP])};
if (_want != _mode) then {
    [_heli, _want] call fza_fcr_fnc_setMode;
    _heli setVariable ["fza_ah64_fcrCued", [true, _record # ASE_RFI_OBJ], true];
};
_heli setVariable ["fza_ah64_fcrScanSize", [RFI_CUED_SIZE_COARSE, RFI_CUED_SIZE_FINE] select (_record # ASE_RFI_FINE), true];
[_heli, round _rel] call fza_fcr_fnc_setCenterline;
if (_picked) exitWith {};

[_heli] call fza_fcr_fnc_singleScan;
