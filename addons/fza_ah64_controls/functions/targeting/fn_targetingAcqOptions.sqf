/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqOptions

Description:
    The acquisition sources a crew station can select with its present sight.

    Pilot: PHS (FCR as the sight), GHS, FCR (not with FCR as the sight), FXD, TADS
    CPG:   PHS, GHS (not with HMD as the sight), FCR (TADS or HMD as the sight), FXD,
           TADS (not with TADS as the sight)
    Both:  the crew station's coordinate point, the last selected on its COORD
           page, ?01 before one is (fza_ah64_acqPoint_<seat>)

    A source that is not available is not offered: FCR not fitted or failed,
    TADS without AC power or with both its sensors failed, PHS or GHS without
    a crew member in that seat.

Parameters:
    _heli - The helicopter
    _seat - "plt" or "cpg"

Returns:
    Array of acquisition source names

Examples:
    [_heli, "cpg"] call fza_fnc_targetingAcqOptions

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli", "_seat"];

private _sight = [_heli, "fza_ah64_sight", _seat] call fza_fnc_getSeatVariable;
if (isNil "_sight") then {_sight = SIGHT_HMD};
private _isPilot = _seat == "plt";

private _fcr  = _heli animationPhase "fcr_enable" == 1 && {((_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF]]) # 0) != FCR_MODE_FAULT};
private _tads = (_heli getVariable ["bmkhs_acBusOn", false])
    && {(_heli getHitPointDamage "hit_msnEquip_tads_flir") < SYS_SIGHT_DMG_THRESH || {(_heli getHitPointDamage "hit_msnEquip_tads_dtv") < SYS_SIGHT_DMG_THRESH}};

private _options = [];
if (!isNull driver _heli && {!_isPilot || {_sight == SIGHT_FCR}}) then {_options pushBack "PHS"};
if (!isNull gunner _heli && {_isPilot || {_sight != SIGHT_HMD}}) then {_options pushBack "GHS"};
if (_fcr && {[_sight != SIGHT_FCR, _sight in [SIGHT_TADS, SIGHT_HMD]] select !_isPilot}) then {_options pushBack "FCR"};
_options pushBack "FXD";
if (_tads && {_isPilot || {_sight != SIGHT_TADS}}) then {_options pushBack "TADS"};
_options pushBack (_heli getVariable ["fza_ah64_acqPoint_" + _seat, ACQ_POINT_NONE]);
_options
