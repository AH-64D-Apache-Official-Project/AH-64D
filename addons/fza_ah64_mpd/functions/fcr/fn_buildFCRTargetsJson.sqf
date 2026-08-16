/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_buildFCRTargetsJson

Description:
    Builds the "targets" and "shots" JSON fragments for the FCR HTML display
    pages (RMAP B-scope, GTM/ATM scope) from a pre-resolved display target list.
    Native drawIcons cannot be used on these pages: the CT_WEBBROWSER control
    occludes all sibling controls within its rect in RTT displays (verified
    in-game). Targets are classified in SQF (buildFCRIdent) and drawn by the
    shared JS icon layer.

Parameters:
    _heli           - The helicopter
    _displayTargets - Pre-resolved array from fza_ah64_fcrDisplayTargets
                      Record: [pos, type, moving, obj, aziAngle, range, isGhost, lastPaintedTime]
    _scanPos        - World position of the helicopter at last scan
    _ntsIndex       - Index of NTS target in _displayTargets (-1 = none)
    _antsIndex      - Index of ANTS target in _displayTargets (-1 = none)
    _wasState       - fza_ah64_was value
    _halfFov        - Half field-of-view in degrees (culls shot-at markers)
    _maxRange       - Display max range in metres (normalises "r" to 0..1)
    _scanDir        - Scan centerline world bearing at last update (markers hold
                      screen position between scan updates instead of sliding
                      with live yaw)
    _aziDivisor     - Azimuth divisor for the "a" field: pass _halfFov to send
                      a normalised -1..1 (RMAP B-scope x axis), or 1 to send
                      degrees (GTM/ATM polar scopes do the trig in JS)
    _filterAirOnly  - (optional, default false) Skip non-air targets (ATM)

Returns:
    [_targetsJson, _shotsJson] - comma-joined fragment strings (no brackets)

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_displayTargets", "_scanPos", "_ntsIndex", "_antsIndex",
        "_wasState", "_halfFov", "_maxRange", "_scanDir",
        "_aziDivisor", ["_filterAirOnly", false], ["_aziOffset", 0]];

// ident → [iconKey, overlayKey] memo; mission-scoped because uiNamespace outlives mission restarts and served stale keys
private _iconKeys = missionNamespace getVariable "fza_fcr_identIconKeys";
if (isNil "_iconKeys") then {
    _iconKeys = createHashMap;
    missionNamespace setVariable ["fza_fcr_identIconKeys", _iconKeys];
};
private _texToKey = {
    params ["_p"];
    if (_p == "") exitWith { "" };
    private _parts = _p splitString "\";
    private _base  = _parts # (count _parts - 1);
    // toLower: config texture case differs from disk and JS keys are case-sensitive
    toLower (_base select [0, (count _base) - 7])
};

private _tgtParts = [];
{
    _x params ["_tgtPos", "_type", "_moving", "_target", "_aziAngle", "_range", "_isGhost", ["_lastPainted", 0]];

    if (_filterAirOnly && _type != FCR_TYPE_FLYER && _type != FCR_TYPE_HELICOPTER) then { continue; };

    private _selStatus = 0;
    if (_forEachIndex == _ntsIndex)  then { _selStatus = 1; };
    if (_forEachIndex == _antsIndex) then { _selStatus = 2; };
    private _ident = [_type, _range, _moving, _selStatus, _wasState == WAS_WEAPON_NONE] call fza_mpd_fnc_buildFCRIdent;
    if (_ident == "") then { continue; };

    private _keys = _iconKeys get _ident;
    if (isNil "_keys") then {
        private _details = [_ident] call fza_dms_fnc_pointGetIdentDetails;
        if (isNil "_details") then { continue; };
        _keys = [[_details # 0] call _texToKey, [_details # 1] call _texToKey];
        _iconKeys set [_ident, _keys];
    };

    // TM 4.44.4: stale = 5s movers / 30s static since last painted; scanning re-stamps every cycle
    private _stale = (CBA_missionTime - _lastPainted) >= ([FCR_STALE_STATIC_SEC, FCR_STALE_MOVING_SEC] select _moving);

    // ATM's PPI wedge rotates to the slewed bearing, so symbols sit at nose-relative
    // azimuth (centerline-relative angle + bias); GTM/RMAP pass 0 and stay centerline-referenced
    _tgtParts pushBack format ['{"a":%1,"r":%2,"icon":"%3","ov":"%4","stale":%5}',
        ((_aziAngle + _aziOffset) / _aziDivisor) toFixed 3,
        (_range / _maxRange) toFixed 4,
        _keys # 0,
        _keys # 1,
        [0, 1] select _stale
    ];
} forEach (_displayTargets select [0, (count _displayTargets) min 16]);

private _shotParts = [];
{
    if (_x isEqualTo -1) then { continue; };
    _x params ["_index", "_shotIdent", "_missileType", "_triggerTime", "_shotPos", "_owner", "_overlay"];
    // Scan-time reference frame so markers hold screen position between scan updates
    private _shotRange  = _scanPos distance2D _shotPos;
    private _shotRelAzi = [(_scanPos getDir _shotPos) - _scanDir] call CBA_fnc_simplifyAngle180;
    if ((abs _shotRelAzi) > _halfFov || _shotRange > FCR_LIMIT_MOVING_RANGE) then { continue; };
    // TM 4.44.6: o 0 = under targets (pre-launch), 1 = over (post-launch)
    _shotParts pushBack format ['{"a":%1,"r":%2,"o":%3}',
        ((_shotRelAzi + _aziOffset) / _aziDivisor) toFixed 3,
        (_shotRange / _maxRange) toFixed 4,
        _overlay
    ];
} forEach (_heli getVariable ["fza_dms_shotAt", []]);

[_tgtParts joinString ",", _shotParts joinString ","]
