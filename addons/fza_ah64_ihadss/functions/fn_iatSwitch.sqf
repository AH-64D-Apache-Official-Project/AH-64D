/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatSwitch

Description:
    The CPG's IAT/OFS switch. IAT pressed with the tracker off starts it in
    the FLIR or DTV, taking the TADS off slave; held, the gates size
    (fza_ihadss_fnc_iatSizing).
    On release it captures what is under the reticle, or inside the gates
    when sized; without a target it goes off, with no gates. IAT pressed with the
    tracker on disengages it. OFS while tracking lets the aim input move the
    LOS about the target; OFS again brings it back onto the target.

Parameters:
    _heli    - The helicopter
    _ofs     - True for OFS, false for IAT
    _pressed - True on press, false on release (default: true)

Returns:
    Nothing

Examples:
    --- Code
    [_heli, false, true] call fza_ihadss_fnc_iatSwitch
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli", "_ofs", ["_pressed", true]];

if (player != gunner _heli) exitWith {};

private _iat   = _heli getVariable ["fza_ah64_iat", IAT_IDLE];
private _state = _iat # 0;
private _now   = CBA_missionTime;

if (_ofs) exitWith {
    if (!_pressed || {!(_state in [IAT_TRACK, IAT_COAST])}) exitWith {};
    // Selected again, the LOS goes back onto the target and OFS off (fza_ihadss_fnc_iatUpdate)
    if (_iat # 10) exitWith {_heli setVariable ["fza_ihadss_iatReturn", true]};
    _heli setVariable ["fza_ihadss_iatReturn", false];
    private _new = +_iat;
    _new set [10, true];
    [_heli, "fza_ah64_iat", _new] call fza_fnc_updateNetworkGlobal;
};

if (_pressed) exitWith {
    if (_state != IAT_OFF) exitWith {[_heli] call fza_ihadss_fnc_iatDisengage};
    if (([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_TADS || {!(_heli getVariable ["bmkhs_acBusOn", false])}
        || {(([_heli] call fza_ihadss_fnc_tadsNvs) # 0) != NVS_MODE_OFF}
        || {([_heli] call fza_ihadss_fnc_getVisionMode) == 3}) exitWith {};
    _heli setVariable ["fza_ah64_cpgSlaved", false, true];
    [_heli, "fza_ah64_iat", [IAT_SIZING, 0, objNull, [], [], [0, 0, 0], -1, [0, 0], _now, [], false]] call fza_fnc_updateNetworkGlobal;
};

// Released: captures, within the gates if they were sized
if (_state != IAT_SIZING) exitWith {};
// A press shorter than IAT_HOLD captures near the reticle, unsized
private _size   = if (_now - (_iat # 8) < IAT_HOLD) then {0} else {[_iat # 8] call fza_ihadss_fnc_iatSizing};
private _vision = [_heli] call fza_ihadss_fnc_getVisionMode;
private _sensor = ["hit_msnEquip_tads_flir", "hit_msnEquip_tads_dtv"] select (_vision == 0);
if (_heli getHitPointDamage "hit_msnEquip_tads_turret" >= SYS_SIGHT_DMG_THRESH || {_heli getHitPointDamage _sensor >= SYS_SIGHT_DMG_THRESH}) exitWith {
    [_heli, "fza_ah64_iat", [IAT_FAIL, 0, objNull, [], [], [0, 0, 0], -1, [0, 0], _now, [], false]] call fza_fnc_updateNetworkGlobal;
};

private _acq = [_heli, _vision, _size] call fza_ihadss_fnc_iatAcquire;
if (_acq isEqualTo []) exitWith {[_heli] call fza_ihadss_fnc_iatDisengage};
_acq params ["_obj", "_trackPoint", "_half"];
_heli setVariable ["fza_ihadss_iatLocal", nil];
[_heli, "fza_ah64_iat", [IAT_TRACK, _size max IAT_MIN_SIZE, _obj, _trackPoint, [], [0, 0, 0], _now, _half, _now, [], false]] call fza_fnc_updateNetworkGlobal;
