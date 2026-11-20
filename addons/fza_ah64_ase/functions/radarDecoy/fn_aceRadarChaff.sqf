/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_aceRadarChaff

Description:
    Whether chaff takes a Doppler radar off its target: each radar chaff round in the radar's
    resolution cell around the target has ASE_RADAR_CHAFF_CHANCE, times the missile's chaff
    effectiveness and ACE's chaff effectiveness setting. The cell is ASE_RADAR_CHAFF_RANGE_GATE
    either side of the target's range, and the beam across: ASE_RADAR_CHAFF_SEEKER_BEAM for a missile seeker,
    ASE_RADAR_BEAM_HALF_ANGLE for the launcher's radar, never under ASE_RADAR_CHAFF_CELL.
    Chaff all but stops, so the chance is full while the target is no faster along the line of
    sight than the Doppler filter, falling to none at ASE_RADAR_CHAFF_DOPPLER_LIMIT. The
    missile's seeker must have it in its cone and in sight. Once a radar check.
    Draw only: no roll, the chaff drawn green with a chance, red without.

Parameters:
    _target       - Target
    _radar        - The missile, or the launcher guiding it
    _minimumSpeed - Doppler filter, m/s
    _seekerAngle  - The missile seeker's cone, deg, or -1 for the launcher's radar
    _drawOnly     - Debug: draw the chaff instead
    _chaffEffectiveness - How well chaff works on the missile, 0 immune

Returns:
    The chaff round taken for the target, or objNull <OBJECT>

Examples:
    [_target, _projectile, 5, 50, false, 0.5] call fza_ase_fnc_aceRadarChaff

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\radarDecoy.h"
params ["_target", "_radar", ["_minimumSpeed", 30, [0]], ["_seekerAngle", -1, [0]], ["_drawOnly", false, [false]], ["_chaffEffectiveness", ASE_RADAR_CHAFF_EFFECTIVENESS, [0]]];

if (isNull _target || {isNull _radar}) exitWith {objNull};

private _radarPos    = getPosASLVisual _radar;
private _targetPos   = getPosASLVisual _target;
private _range       = _radarPos vectorDistance _targetPos;
private _los         = _radarPos vectorFromTo _targetPos;
private _radialSpeed = abs ((velocity _target) vectorDotProduct _los);
private _chance = ASE_RADAR_CHAFF_CHANCE * _chaffEffectiveness * (missionNamespace getVariable ["ace_missileguidance_chaffEffectivenessCoef", 1])
    * linearConversion [_minimumSpeed, ASE_RADAR_CHAFF_DOPPLER_LIMIT max (_minimumSpeed + 1), _radialSpeed, 1, 0, true];
private _log       = !_drawOnly && {missionNamespace getVariable ["fza_ase_radarDebug", false]};
private _crossGate = ASE_RADAR_CHAFF_CELL max (_range * tan ([ASE_RADAR_CHAFF_SEEKER_BEAM, ASE_RADAR_BEAM_HALF_ANGLE] select (_seekerAngle < 0)));
private _reach     = ASE_RADAR_CHAFF_RANGE_GATE + _crossGate;

if (isNil "fza_ase_radarChaffTypes") then {fza_ase_radarChaffTypes = createHashMap;};
private _isChaff = {
    private _type = typeOf _this;
    fza_ase_radarChaffTypes getOrDefaultCall [_type, {
        private _config = configFile >> "CfgAmmo" >> _type;
        // 8: radar countermeasure
        isClass _config && {getText (_config >> "simulation") == "shotCM"}
            && {([getNumber (_config >> "weaponLockSystem"), 8] call BIS_fnc_bitwiseAND) != 0}
    }, true]
};

if (_chance <= 0 && {!_drawOnly}) exitWith {
    if (_log) then {
        private _count = {_x call _isChaff} count (_target nearObjects ["Default", _reach]);
        if (_count == 0) exitWith {};
        diag_log format ["fza_ase radar | #%5 chaff near %1 from %2: %3 within %4 m, no chance, radial %6 m/s", typeOf _target, typeOf _radar,
            _count, _reach toFixed 0, _radar getVariable ["fza_ase_radarLogId", "L"], _radialSpeed toFixed 1];
    };
    objNull
};

private _chaff   = objNull;
private _found   = 0;
private _inCell  = 0;
private _inView  = 0;
private _nearest = 1e9;
{
    if !(_x call _isChaff) then {continue;};
    _found = _found + 1;
    if (_log) then {_nearest = _nearest min (_x distance _target);};
    private _pos   = getPosASLVisual _x;
    private _rel   = _pos vectorDiff _radarPos;
    private _cross = vectorMagnitude (_rel vectorDiff (_los vectorMultiply (_rel vectorDotProduct _los)));
    private _cell  = abs ((vectorMagnitude _rel) - _range) < ASE_RADAR_CHAFF_RANGE_GATE && {_cross < _crossGate};
    if (_cell) then {_inCell = _inCell + 1;};
    private _considered = _cell && {_chance > 0} && {_seekerAngle < 0 || {
        [_radar, _pos, _seekerAngle] call ace_missileguidance_fnc_checkSeekerAngle
        && {[_radar, _x, false] call ace_missileguidance_fnc_checkLos}
    }};
    if (_drawOnly) then {
        drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [[1,0,0,1], [0,1,0,1]] select _considered, ASLToAGL _pos, 0.75, 0.75, 0, "C", 1, 0.025, "TahomaB"];
        continue;
    };
    if !(_considered) then {continue;};
    _inView = _inView + 1;
    if (random 1 < _chance) exitWith {_chaff = _x;};
} forEach (_target nearObjects ["Default", _reach]);

if (_log && {_found > 0}) then {
    diag_log format ["fza_ase radar | #%13 chaff near %1 from %2 at %3 m: %4 within %5 m (nearest %6 m), %7 in the cell (%8 m either side in range, %9 m across), %10 in view, chance %11 each (effectiveness %12), radial %14 m/s, %15",
        typeOf _target, typeOf _radar, _range toFixed 0, _found, _reach toFixed 0, _nearest toFixed 0, _inCell,
        ASE_RADAR_CHAFF_RANGE_GATE, _crossGate toFixed 0, _inView, _chance toFixed 3, _chaffEffectiveness,
        _radar getVariable ["fza_ase_radarLogId", "L"], _radialSpeed toFixed 1, ["not taken", "TAKEN"] select !isNull _chaff];
};

_chaff
