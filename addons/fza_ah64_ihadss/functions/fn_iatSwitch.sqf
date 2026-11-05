/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatSwitch

Description:
    The CPG's IAT/OFS switch. IAT engages the image auto tracker on what is
    under the TADS reticle, taking the TADS off slave; without a target the
    gates grow out and it goes to stop mode. IAT again disengages it. OFS
    while tracking toggles offset tracking.

Parameters:
    _heli - The helicopter
    _ofs  - True for OFS, false for IAT

Returns:
    Nothing

Examples:
    --- Code
    [_heli, false] call fza_ihadss_fnc_iatSwitch
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli", "_ofs"];

if (player != gunner _heli) exitWith {};

private _iat = +(_heli getVariable ["fza_ah64_iat", IAT_IDLE]);
private _state = _iat # 0;

if (_ofs) exitWith {
    if !(_state in [IAT_TRACK, IAT_COAST]) exitWith {};
    _iat set [1, !(_iat # 1)];
    [_heli, "fza_ah64_iat", _iat] call fza_fnc_updateNetworkGlobal;
};

if (_state != IAT_OFF) exitWith {[_heli] call fza_ihadss_fnc_iatDisengage};

if (([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_TADS || {!(_heli getVariable ["bmkhs_acBusOn", false])}
    || {(([_heli] call fza_ihadss_fnc_tadsNvs) # 0) != NVS_MODE_OFF}) exitWith {};

_heli setVariable ["fza_ah64_cpgSlaved", false, true];

private _now    = CBA_missionTime;
private _vision = [_heli] call fza_ihadss_fnc_getVisionMode;
private _sensor = ["hit_msnEquip_tads_flir", "hit_msnEquip_tads_dtv"] select (_vision == 0);
if (_heli getHitPointDamage "hit_msnEquip_tads_turret" >= SYS_SIGHT_DMG_THRESH || {_heli getHitPointDamage _sensor >= SYS_SIGHT_DMG_THRESH}) exitWith {
    [_heli, "fza_ah64_iat", [IAT_FAIL, false, objNull, [], [], [0, 0, 0], -1, [0, 0], _now, []]] call fza_fnc_updateNetworkGlobal;
};

private _acq = [_heli, _vision] call fza_ihadss_fnc_iatAcquire;
if (_acq isEqualTo []) exitWith {
    [_heli, "fza_ah64_iat", [IAT_STOP, false, objNull, [], [], [0, 0, 0], -1, [0, 0], _now, [IAT_GATE_MAX, IAT_GATE_MAX]]] call fza_fnc_updateNetworkGlobal;
};
_acq params ["_obj", "_trackPoint", "_half"];
_heli setVariable ["fza_ihadss_iatLocal", nil];
[_heli, "fza_ah64_iat", [IAT_TRACK, false, _obj, _trackPoint, [], [0, 0, 0], _now, _half, _now, []]] call fza_fnc_updateNetworkGlobal;
