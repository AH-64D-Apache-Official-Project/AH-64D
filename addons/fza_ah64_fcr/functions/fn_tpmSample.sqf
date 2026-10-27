/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_tpmSample

Description:
    Samples TPM terrain for the columns the wiper has crossed since the last
    call. Feeds the TPM page video (fza_ah64_fcrTPMFrameCache) and, while the
    C-scope is selected, the IHADSS profile lines (fza_ah64_fcrTPMProfile),
    which are published as each full scan cycle completes. Runs once per frame
    whichever caller comes first (TPM page draw or FCR controller).

Parameters:
    _heli - The helicopter

Returns:
    Column JSON for this frame ("" when nothing new was sampled)

fza_ah64_fcrTPMProfile:
    [leftEdgeBearing, columnWidthDeg, [line1, line2, line3, line4]], each line
    an array of points per column: [x, y, zASL] at the highest terrain the
    radar measures in that line's range band, or [] where it measures none.
    Terrain further below the antenna elevation (ELEV FAR/NEAR) than the
    beam reaches is not measured: unknown on the TPM page, and no line.
fza_ah64_fcrTPMProfileTime:
    Mission time the profile lines were last published.

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _frameCache = _heli getVariable ["fza_ah64_fcrTPMFrameCache", [-1, ""]];
if ((_frameCache # 0) == diag_frameNo) exitWith { _frameCache # 1 };

private _colJson = "";

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _halfFov    = _heli getVariable ["fza_ah64_fcrTpmHalfFov", 90];
private _clearEpoch = _heli getVariable ["fza_ah64_fcrTPMClearEpoch", 0];
private _wantProf   = _heli getVariable ["fza_ah64_fcrcscope", false];

// No FCR picture on the C-scope while FCR data is invalid
if (_fcrScanState == FCR_MODE_FAULT) then { _heli setVariable ["fza_ah64_fcrTPMProfile", []]; };

// Constant 1.5°/column at both FOVs — narrow (±45°) needs half the columns of wide (±90°)
private _aziSteps   = [60, 120] select (_halfFov >= 90);
private _rangeSteps = 150;
private _rangeStep  = 2500 / _rangeSteps;
private _aziStepD   = (_halfFov * 2) / _aziSteps;
private _halfSweepDuration = (_halfFov * 2) / FCR_TPM_SCAN_RATE_DEGS;

// A commanded clear (fza_fcr_fnc_videoClear) or a sector change restarts the sweep bookkeeping
private _hardClear = _clearEpoch != (_heli getVariable ["fza_ah64_fcrTPMSeenEpoch", -1]);
if (_hardClear) then {
    _heli setVariable ["fza_ah64_fcrTPMSeenEpoch", _clearEpoch];
    _heli setVariable ["fza_ah64_fcrTPMProfile", []];
};
private _newScan = _hardClear || { _halfFov != (_heli getVariable ["fza_ah64_fcrTPMPrevHalfFov", -1]) };
_heli setVariable ["fza_ah64_fcrTPMPrevHalfFov", _halfFov];

private _emptyWork = {
    [0, 1, 2, 3] apply {
        private _line = [];
        for "_i" from 1 to _aziSteps do { _line pushBack []; };
        _line
    }
};
if (_newScan) then {
    _heli setVariable ["fza_ah64_fcrTPMLastColIdx", -1];
    _heli setVariable ["fza_ah64_fcrTPMProfWork", call _emptyWork];
};

if (_fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]) then {
    private _t = ((CBA_missionTime - _fcrScanStartTime) max 0) % (_halfSweepDuration * 2);
    private _sweepLtoR = (_t <= _halfSweepDuration);
    private _scanBearingAzi = if (_sweepLtoR) then {
        -_halfFov + (_t / _halfSweepDuration) * (_halfFov * 2)
    } else {
        _halfFov - ((_t - _halfSweepDuration) / _halfSweepDuration) * (_halfFov * 2)
    };

    private _colIdx = ((floor ((_scanBearingAzi + _halfFov) / _aziStepD)) min (_aziSteps - 1)) max 0;

    // Lock heading at each half-sweep flip so columns stay world-aligned
    private _prevSweepLtoR = _heli getVariable ["fza_ah64_fcrTPMPrevSweepLtoR", -1];
    private _curSweepLtoR  = parseNumber _sweepLtoR;
    if (_newScan || _prevSweepLtoR != _curSweepLtoR) then {
        // A completed full cycle (its R→L half ending): publish the profile lines of the sweep that ended it
        if (!_newScan && _prevSweepLtoR == 0 && _curSweepLtoR == 1) then {
            private _sweepHeading = _heli getVariable ["fza_ah64_fcrTPMScanHeading", getDir _heli];
            _heli setVariable ["fza_ah64_fcrTPMProfile", [_sweepHeading - _halfFov, _aziStepD, _heli getVariable ["fza_ah64_fcrTPMProfWork", []]]];
            _heli setVariable ["fza_ah64_fcrTPMProfileTime", CBA_missionTime];
        };
        _heli setVariable ["fza_ah64_fcrTPMProfWork",      call _emptyWork];
        _heli setVariable ["fza_ah64_fcrTPMScanHeading",   getDir _heli];
        _heli setVariable ["fza_ah64_fcrTPMPrevSweepLtoR", _curSweepLtoR];
        _heli setVariable ["fza_ah64_fcrTPMLastColIdx",    -1];
    };
    private _scanHeading = _heli getVariable ["fza_ah64_fcrTPMScanHeading", getDir _heli];

    private _lastColIdx = _heli getVariable ["fza_ah64_fcrTPMLastColIdx", -1];

    private _fillFrom = _colIdx;
    private _fillTo   = _colIdx;
    if (_newScan || _lastColIdx < 0) then {
        // Fresh sweep: backfill the few columns from the sweep-start edge; a clear mid-sweep paints from the wiper on
        if (_sweepLtoR) then {
            if (_colIdx < 16) then { _fillFrom = 0; };
        } else {
            if (_aziSteps - 1 - _colIdx < 16) then { _fillTo = _aziSteps - 1; };
        };
    } else {
        // Continue from last progress: L→R fills (last+1..col), R→L fills (col..last-1)
        if (_sweepLtoR) then {
            _fillFrom = ((_lastColIdx + 1) min _colIdx) max 0;
        } else {
            _fillTo = ((_lastColIdx - 1) max 0) min (_aziSteps - 1);
        };
        if (_fillFrom > _fillTo) then { private _tmp = _fillFrom; _fillFrom = _fillTo; _fillTo = _tmp; };
    };

    // Cap columns per frame; progress carries so stutter backfill spreads over frames
    private _progressIdx = _colIdx;
    if (_fillTo - _fillFrom + 1 > 16) then {
        if (_sweepLtoR) then {
            _fillTo      = _fillFrom + 15;
            _progressIdx = _fillTo;
        } else {
            _fillFrom    = _fillTo - 15;
            _progressIdx = _fillFrom;
        };
    };
    _heli setVariable ["fza_ah64_fcrTPMLastColIdx", _progressIdx];

    if (_colIdx != _lastColIdx || _newScan) then {
        private _heliPosASL = getPosASL _heli;
        private _heliX      = _heliPosASL#0;
        private _heliY      = _heliPosASL#1;
        private _heliWheelZ = _heliPosASL#2;
        private _clearanceM = ([20, 50, 100, 200] select (_heli getVariable ["fza_ah64_fcrTpmClearance", 1])) * 0.3048;
        private _safeHeight = _heliWheelZ - _clearanceM;
        // selectionPosition is model-space — world ASL Z = heli ASL Z + sensor Z offset
        private _FCRpos     = _heli selectionPosition ["sensorPos", "Memory"];
        private _FCRposZ    = if (_FCRpos isEqualTo [0,0,0]) then { _heliWheelZ + 3 } else { _heliWheelZ + (_FCRpos#2) };
        // Lowest slope from the antenna the beam reaches, below the selected antenna elevation
        private _beamFloor  = tan ((FCR_TPM_ANTENNA_EL select (_heli getVariable ["fza_ah64_fcrTpmElev", 0])) - FCR_TPM_BEAM_HALF_EL);

        // Cell centre ranges and their profile band, built once per geometry and PROF setting
        private _profMode = _heli getVariable ["fza_ah64_fcrTpmProfMode", 0];
        private _geomKey  = [_rangeSteps, _profMode];
        private _geom     = _heli getVariable ["fza_ah64_fcrTPMGeom", [[], [], []]];
        if ((_geom # 0) isNotEqualTo _geomKey) then {
            private _ranges = [];
            for "_ri" from 0 to (_rangeSteps - 1) do { _ranges pushBack ((_ri + 0.5) * _rangeStep); };
            private _bandOf = _ranges apply { -1 };
            if (_profMode == 2) then {
                // TEST: one cell at each fixed range
                { _bandOf set [((round (_x / _rangeStep - 0.5)) max 0) min (_rangeSteps - 1), _forEachIndex]; } forEach [500, 1000, 1500, 2000];
            } else {
                private _bands = [
                    [[100, 300], [300, 500], [500, 1000], [1000, 2500]],
                    [[100, 700], [700, 1300], [1300, 1900], [1900, 2500]]
                ] select _profMode;
                {
                    private _r = _x;
                    private _ri = _forEachIndex;
                    { if (_r >= _x # 0 && _r < _x # 1) exitWith { _bandOf set [_ri, _forEachIndex]; }; } forEach _bands;
                } forEach _ranges;
            };
            _geom = [_geomKey, _ranges, _bandOf];
            _heli setVariable ["fza_ah64_fcrTPMGeom", _geom];
        };
        _geom params ["", "_ranges", "_bandOf"];

        private _work = _heli getVariable ["fza_ah64_fcrTPMProfWork", []];
        if (count _work != 4 || { count (_work # 0) != _aziSteps }) then {
            _work = call _emptyWork;
            _heli setVariable ["fza_ah64_fcrTPMProfWork", _work];
        };

        private _sampledCols = [];

        for "_ci" from _fillFrom to _fillTo do {
            private _worldAzi = _scanHeading - _halfFov + (_ci + 0.5) * _aziStepD;

            private _horizonSlope = -9999;
            private _sinAzi       = sin _worldAzi;
            private _cosAzi       = cos _worldAzi;
            private _bandPt       = [[], [], [], []];
            private _ri           = -1;

            private _colLevels = _ranges apply {
                private _terrainASL = getTerrainHeightASL [_heliX + _sinAzi * _x, _heliY + _cosAzi * _x];
                private _rise       = _terrainASL + 1 - _FCRposZ;
                _ri = _ri + 1;
                if (_terrainASL <= -1000) then { 2 } else {
                    if (_rise <= _horizonSlope * _x) then {
                        // Shadowed: grey while the grazing ray is above the clearance plane (hidden terrain could pierce it), black once below;
                        // unknown behind terrain the beam did not reach
                        if (_horizonSlope < _beamFloor) then { 2 } else { [0, 2] select (_FCRposZ + _horizonSlope * _x >= _safeHeight) }
                    } else {
                        _horizonSlope = _rise / _x;
                        // Below the beam: not measured, unknown
                        if (_horizonSlope < _beamFloor) then { 2 } else {
                            // A band's line point is the highest terrain the radar measures in it
                            if (_wantProf) then {
                                private _b = _bandOf # _ri;
                                if (_b >= 0 && {(_bandPt # _b) isEqualTo [] || {_terrainASL > (_bandPt # _b) # 2}}) then {
                                    _bandPt set [_b, [_heliX + _sinAzi * _x, _heliY + _cosAzi * _x, _terrainASL]];
                                };
                            };
                            if (_terrainASL < _safeHeight) then { 0 } else { [1, 3] select (_terrainASL >= _heliWheelZ) }
                        }
                    }
                }
            };

            if (_wantProf) then {
                { (_work # _forEachIndex) set [_ci, _x]; } forEach _bandPt;
            };

            // "d" is one digit (clearance level 0-3) per range cell
            _sampledCols pushBack format ['{"i":%1,"d":"%2"}', _ci, _colLevels joinString ""];
        };

        if (_sampledCols isNotEqualTo []) then {
            _colJson = "[" + (_sampledCols joinString ",") + "]";
        };
    };
};

_heli setVariable ["fza_ah64_fcrTPMFrameCache", [diag_frameNo, _colJson]];
_colJson
