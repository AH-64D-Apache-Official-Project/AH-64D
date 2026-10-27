/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrRMAPDraw

Description:
    Draws the FCR RMAP page: native MFD symbology plus the B-scope terrain
    video and target symbols, which are pushed to the page's HTML canvas.
    Terrain is sampled once per frame for the columns the scan bar has crossed
    and shared by both MPDs.

Parameters:
    _heli         - The helicopter
    _mpdIndex     - 0 left MPD, 1 right MPD
    _state        - Page state (unused)
    _persistState - Page persistent state (unused)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_state", "_persistState"];

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
private _fcrOn   = _heli animationPhase "fcr_enable" != 0;

if (!_fcrOn || _fcrMode != FCR_DISP_MODE_RMAP) exitWith {
    [_heli, _mpdIndex, ["fcr", "fcrtpm"] select (_fcrOn && _fcrMode == FCR_DISP_MODE_TPM)] call fza_mpd_fnc_setCurrentPage;
};

private _cScope  = _heli getVariable "fza_ah64_fcrcscope";
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CSCOPE), BOOLTONUM(_cScope)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_MODE), FCR_DISP_MODE_RMAP];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_SIZE), _heli getVariable ["fza_ah64_fcrScanSize", 0]];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _gtmHalfFov       = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
private _fcrScanDeltaTime = CBA_missionTime - _fcrScanStartTime;
private _barTime          = (_gtmHalfFov * 2) / FCR_SCAN_RATE_DEGS;
// Wiper hidden while the dish cues to the sector edge — the bar only ever appears at the sweep start
private _cueingRmap = _fcrScanDeltaTime < 0 || { _heli getVariable ["fza_ah64_fcrWaitingForStart", false] };
if (_fcrScanState != FCR_MODE_OFF && !_cueingRmap) then {
    // Bars ride the fixed +-45 display axis — remap wiper bearing into the bone's 0..3.2 range.
    // Display is centerline-referenced: the sector stays centered, so the wiper ignores azimuth bias
    private _t  = (_fcrScanDeltaTime max 0) % (_barTime * 2);
    private _az = [-_gtmHalfFov + (_t / _barTime) * (_gtmHalfFov * 2), _gtmHalfFov - ((_t - _barTime) / _barTime) * (_gtmHalfFov * 2)] select (_t > _barTime);
    private _anim = [0.8 * (1 + _az / 45), 2.4 - 0.8 * _az / 45] select (_t > _barTime);
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      _anim];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
};

[_heli, _mpdIndex] call fza_mpd_fnc_fcrStatusDraw;

// ---- Terrain sampling ----

[_heli] call fza_fcr_fnc_resolveDisplay;
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];
// RMAP re-select toggles the video underlay; sampling continues while hidden so it returns current
private _rmapVideo  = _heli getVariable ["fza_ah64_fcrRmapVideo", true];
private _scanning   = _fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS];
private _clearEpoch = _heli getVariable ["fza_ah64_fcrRMAPClearEpoch", 0];

// Constant 0.3 deg/column at all sizes — wide 300, med 150, nrw 100, zoom 50
private _aziSteps     = round ((_gtmHalfFov * 2) / 0.3);
private _nearSteps    = 150;
private _farSteps     = 150;
private _maxRange     = 8000;
private _nearMaxRange = 4000;
private _nearRangeStep = _nearMaxRange / _nearSteps;
private _farRangeStep  = (_maxRange - _nearMaxRange) / _farSteps;
private _aziStepD     = (_gtmHalfFov * 2) / _aziSteps;

// Dual-screen guard: the first call in a frame samples, the second reuses its columns
private _frameCache = _heli getVariable ["fza_ah64_fcrRMAPFrameCache", [-1, ""]];
private _colJson    = "";

if ((_frameCache # 0) == diag_frameNo) then {
    _colJson = _frameCache # 1;
} else {
    // A commanded clear (fza_fcr_fnc_videoClear) restarts the sweep bookkeeping
    private _hardClear = _clearEpoch != (_heli getVariable ["fza_ah64_fcrRMAPSeenEpoch", -1]);
    if (_hardClear) then {
        _heli setVariable ["fza_ah64_fcrRMAPSeenEpoch",     _clearEpoch];
        _heli setVariable ["fza_ah64_fcrRMAPLastColIdx",    -1];
        _heli setVariable ["fza_ah64_fcrRMAPHorizonSlopes", []];
    };

    if (_scanning) then {
        private _t = (_fcrScanDeltaTime max 0) % (_barTime * 2);
        private _isNearPhase = (_t <= _barTime);

        // Near sweeps L→R (0–4000m), far sweeps R→L (4000–8000m)
        private _scanBearingAzi = if (_isNearPhase) then {
            -_gtmHalfFov + (_t / _barTime) * (_gtmHalfFov * 2)
        } else {
            _gtmHalfFov - ((_t - _barTime) / _barTime) * (_gtmHalfFov * 2)
        };

        private _colIdx = ((floor ((_scanBearingAzi + _gtmHalfFov) / _aziStepD)) min (_aziSteps - 1)) max 0;

        // Lock to _dir (scan centerline world bearing, includes azimuth bias) at each
        // phase flip — column azimuths stay in the scan-data frame mid-turn and mid-slew
        private _prevSweepIsNear = _heli getVariable ["fza_ah64_fcrRMAPPrevSweepIsNear", -1];
        private _curPhaseNum     = parseNumber _isNearPhase;
        if (_hardClear || _prevSweepIsNear != _curPhaseNum) then {
            _heli setVariable ["fza_ah64_fcrRMAPScanHeading",     _dir];
            _heli setVariable ["fza_ah64_fcrRMAPPrevSweepIsNear", _curPhaseNum];
            _heli setVariable ["fza_ah64_fcrRMAPLastColIdx",      -1];
        };
        private _scanHeading = _heli getVariable ["fza_ah64_fcrRMAPScanHeading", _dir];

        private _lastColIdx = _heli getVariable ["fza_ah64_fcrRMAPLastColIdx", -1];

        private _fillFrom = _colIdx;
        private _fillTo   = _colIdx;
        if (_hardClear || _lastColIdx < 0) then {
            // Fresh sweep: backfill the few columns from the sweep-start edge; a clear mid-sweep paints from the wiper on
            if (_isNearPhase) then {
                if (_colIdx < 24) then { _fillFrom = 0; };
            } else {
                if (_aziSteps - 1 - _colIdx < 24) then { _fillTo = _aziSteps - 1; };
            };
        } else {
            if (_isNearPhase) then {
                _fillFrom = ((_lastColIdx + 1) max 0) min (_aziSteps - 1);
                _fillTo   = _colIdx;
            } else {
                _fillFrom = _colIdx;
                _fillTo   = ((_lastColIdx - 1) max 0) min (_aziSteps - 1);
            };
            if (_fillFrom > _fillTo) then { private _tmp = _fillFrom; _fillFrom = _fillTo; _fillTo = _tmp; };
        };

        // Cap columns per frame; progress carries so stutter backfill spreads over frames
        private _progressIdx = _colIdx;
        if (_fillTo - _fillFrom + 1 > 24) then {
            if (_isNearPhase) then {
                _fillTo      = _fillFrom + 23;
                _progressIdx = _fillTo;
            } else {
                _fillFrom    = _fillTo - 23;
                _progressIdx = _fillFrom;
            };
        };
        _heli setVariable ["fza_ah64_fcrRMAPLastColIdx", _progressIdx];

        if (_colIdx != _lastColIdx || _hardClear) then {
            private _heliPosASL = getPosASL _heli;
            private _FCRpos     = _heli selectionPosition ["sensorPos", "Memory"];
            private _FCRposZ    = if (_FCRpos isEqualTo [0,0,0]) then { (_heliPosASL#2) + 3 } else { (_heliPosASL#2) + (_FCRpos#2) };

            private _startRange = [_nearMaxRange, 0] select _isNearPhase;
            private _stepSize   = [_farRangeStep, _nearRangeStep] select _isNearPhase;
            private _stepCount  = [_farSteps, _nearSteps] select _isNearPhase;
            private _isNearStr  = ["false","true"] select _isNearPhase;
            private _slope1 = 0.0175 * _stepSize;
            private _slope2 = 0.0875 * _stepSize;
            private _slope3 = 0.268 * _stepSize;
            private _slope4 = 0.466 * _stepSize;
            private _slope5 = 0.700 * _stepSize;

            // Cell centre ranges for this bar, built once per bar geometry
            private _rangeKey = [_startRange, _stepSize, _stepCount];
            private _ranges   = _heli getVariable ["fza_ah64_fcrRMAPRanges", [[], []]];
            if ((_ranges # 0) isNotEqualTo _rangeKey) then {
                private _list = [];
                for "_ri" from 0 to (_stepCount - 1) do { _list pushBack (_startRange + (_ri + 0.5) * _stepSize); };
                _ranges = [_rangeKey, _list];
                _heli setVariable ["fza_ah64_fcrRMAPRanges", _ranges];
            };
            _ranges = _ranges # 1;

            // Surface memo — substring find once per unique surfaceType, hashmap lookup per cell
            private _surfCache = uiNamespace getVariable "fza_fcr_surfModCache";
            if (isNil "_surfCache") then {
                _surfCache = createHashMap;
                uiNamespace setVariable ["fza_fcr_surfModCache", _surfCache];
            };

            private _sampledCols  = [];
            private _heliX        = _heliPosASL#0;
            private _heliY        = _heliPosASL#1;
            private _savedSlopes  = _heli getVariable ["fza_ah64_fcrRMAPHorizonSlopes", []];
            private _newSlopes    = +_savedSlopes;

            for "_ci" from _fillFrom to _fillTo do {
                private _relAzi   = -_gtmHalfFov + (_ci + 0.5) * _aziStepD;
                private _worldAzi = _scanHeading + _relAzi;
                private _sinAzi   = sin _worldAzi;
                private _cosAzi   = cos _worldAzi;

                private _prevTerrainZ = getTerrainHeightASL [_heliX + _sinAzi * (_startRange max _stepSize), _heliY + _cosAzi * (_startRange max _stepSize)];
                private _horizonSlope = if (_isNearPhase) then { -9999 } else { _savedSlopes param [_ci, -9999] };

                private _colLevels = _ranges apply {
                    private _cellPos    = [_heliX + _sinAzi * _x, _heliY + _cosAzi * _x];
                    private _terrainASL = getTerrainHeightASL _cellPos;
                    private _rise       = _terrainASL + 1 - _FCRposZ;
                    private _level      = 0;

                    if (_terrainASL > -1000 && { _rise > _horizonSlope * _x }) then {
                        _horizonSlope = _rise / _x;
                        // tan(1/5/15/25/35 deg) scaled by the cell length, so no divide per cell
                        private _dz = abs (_terrainASL - _prevTerrainZ);
                        _level = if (_dz < _slope1) then { 1 }
                            else { if (_dz < _slope2) then { 2 }
                            else { if (_dz < _slope3) then { 3 }
                            else { if (_dz < _slope4) then { 4 }
                            else { [6, 5] select (_dz < _slope5) } } } };
                        private _surfType = surfaceType _cellPos;
                        private _surfMod  = _surfCache getOrDefault [_surfType, -2];
                        if (_surfMod == -2) then {
                            private _s = toLower _surfType;
                            _surfMod = 0;
                            {
                                if ((_s find _x) >= 0) exitWith { _surfMod = 1; };
                            } forEach ["metal","steel","rock","stone","concrete","asphalt","gravel","rubble","ruin","building","road","runway","tarmac","cobble"];
                            if (_surfMod == 0) then {
                                {
                                    if ((_s find _x) >= 0) exitWith { _surfMod = -1; };
                                } forEach ["grass","forest","leaves","water","lake","sea","sand","beach","snow","ice","mud","dirt","soil","bog"];
                            };
                            _surfCache set [_surfType, _surfMod];
                        };
                        _level = (_level + _surfMod) min 6 max 1;
                    };

                    _prevTerrainZ = _terrainASL;
                    _level
                };

                // Accumulate near-phase horizon slopes locally — flushed once after column loop
                if (_isNearPhase) then {
                    while {count _newSlopes <= _ci} do { _newSlopes pushBack -9999; };
                    _newSlopes set [_ci, _horizonSlope];
                };

                // "d" is one digit (return level 0-6) per range cell
                _sampledCols pushBack format ['{"i":%1,"near":%2,"d":"%3"}', _ci, _isNearStr, _colLevels joinString ""];
            };

            if (_isNearPhase && count _newSlopes > 0) then {
                _heli setVariable ["fza_ah64_fcrRMAPHorizonSlopes", _newSlopes];
            };

            if (_sampledCols isNotEqualTo []) then {
                _colJson = "[" + (_sampledCols joinString ",") + "]";
            };
        };
    };

    _heli setVariable ["fza_ah64_fcrRMAPFrameCache", [diag_frameNo, _colJson]];
};

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str (_heli getVariable "fza_ah64_fcrDisplayCount")];

// ---- Video columns, FCR targets and shot-at markers → HTML canvas ----

private _ctrl = [_heli, _mpdIndex] call fza_mpd_fnc_htmlCtrl;
if (isNull _ctrl) exitWith {};

// Each display clears once per commanded clear, including one that loads afterwards
private _dispClear = _clearEpoch != (_ctrl getVariable ["fza_fcrClearEpoch", -1]);
if (_dispClear) then { _ctrl setVariable ["fza_fcrClearEpoch", _clearEpoch]; };

private _displayTargets = _heli getVariable "fza_ah64_fcrDisplayTargets";
private _nts       = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = if (!isNull _nts) then { _displayTargets findIf {_x # 3 == _nts} } else { -1 };
private _antsIndex = -1;
if (count _displayTargets > 1 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (count _displayTargets min FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS);
};

// "a" normalised to -1..1 over the fixed +-45 B-scope x axis
([_heli, _displayTargets, _scanPos, _ntsIndex, _antsIndex, _heli getVariable "fza_ah64_was",
    _gtmHalfFov, _maxRange, _dir, 45, false
] call fza_mpd_fnc_buildFCRTargetsJson) params ["_tgtJson", "_shotJson"];

private _json = format [
    '{"halfFov":%1,"aziSteps":%2,"nearSteps":%3,"farSteps":%4,"hardClear":%5,"video":%6,"targets":[%7],"shots":[%8]%9}',
    _gtmHalfFov,
    _aziSteps,
    _nearSteps,
    _farSteps,
    ["false","true"] select _dispClear,
    ["false","true"] select _rmapVideo,
    _tgtJson,
    _shotJson,
    ["", ',"columns":' + _colJson] select (_colJson != "")
];

[_ctrl, "fzaFCRRmap.update", _json] call fza_mpd_fnc_htmlPush;
