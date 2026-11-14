/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsLosSend

Description:
    Sends the TADS's line of sight and angles from the machine turning it to
    the others, as one message (fza_ihadss_fnc_tadsLos): at most 30 times a
    second while it moves, the final one once it stops, at once when this
    machine takes it over, and once a second regardless, so a send from a
    machine that briefly took it for its own does not stand. The other crew
    station takes the angles from it.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_tadsLosSend
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#define KEEPALIVE 1
params ["_heli"];

if (!isMultiplayer || {!(player in [driver _heli, gunner _heli])}) exitWith {};

([_heli] call fza_ihadss_fnc_tadsLos) params ["", "_los", "_driving"];
private _was = _heli getVariable ["fza_ihadss_tadsLosDriving", false];
if (_was isNotEqualTo _driving) then {_heli setVariable ["fza_ihadss_tadsLosDriving", _driving]};

if !_driving exitWith {
    private _packet = _heli getVariable ["fza_ah64_tadsLos", []];
    if (!(_packet isEqualTypeArray [0, 0, 0, 0, 0]) || {_packet isEqualTo (_heli getVariable ["fza_ihadss_tadsLosRead", []])}) exitWith {};
    _heli setVariable ["fza_ihadss_tadsLosRead", _packet];
    _heli setVariable ["fza_ah64_tadsAzimuth",   _packet # 3];
    _heli setVariable ["fza_ah64_tadsElevation", _packet # 4];
};

// The turret's angles and the turn added while the TADS is an NVS sensor (fza_ihadss_fnc_tadsNvsControl), as
// fza_fnc_weaponTurretAim has them
private _az = -deg ((_heli animationPhase "tads_tur") + (_heli animationPhase "tads_nvs_tur"));
private _el = deg ((_heli animationPhase "tads") + (_heli animationPhase "tads_nvs"));

private _since = diag_tickTime - (_heli getVariable ["fza_ihadss_tadsLosSentAt", -1e6]);
(_heli getVariable ["fza_ihadss_tadsLosSent", []]) params [["_sentLos", [0, 0, 0]], ["_sentAz", 1e9], ["_sentEl", 1e9]];
private _moved = (_los vectorDistance _sentLos) > TADS_LOS_SEND_MIN || {abs (_az - _sentAz) > 1e-4} || {abs (_el - _sentEl) > 1e-4};
if (_was && {_since < KEEPALIVE} && {!_moved || {_since < TADS_LOS_SEND_PERIOD}}) exitWith {};

_heli setVariable ["fza_ihadss_tadsLosSent", [_los, _az, _el]];
_heli setVariable ["fza_ihadss_tadsLosSentAt", diag_tickTime];
_heli setVariable ["fza_ah64_tadsLos", _los + [_az, _el], true];
