#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_state", "_persistState"];

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";

if (_fcrMode != FCR_DISP_MODE_TPM) exitWith {
    [_heli, _mpdIndex, "fcr"] call fza_mpd_fnc_setCurrentPage;
};

private _cScope = _heli getVariable "fza_ah64_fcrcscope";
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CSCOPE), BOOLTONUM(_cScope)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_MODE), FCR_DISP_MODE_TPM];

private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _sightSelStat = "HMD ";
switch _sight do {
    case 0: { _sightSelStat = "FCR "; };
    case 1: { _sightSelStat = "HMD "; };
    case 2: { _sightSelStat = "TADS"; };
    case 3: { _sightSelStat = "FXD "; };
};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_SSS), _sightSelStat];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_SS),  ""];

private _wasState = _heli getVariable "fza_ah64_was";
private _mslTraj  = _heli getVariable "fza_ah64_hellfireTrajectory";
private _wpnCtrl  = "";
private _wpnStat  = "";
switch _wasState do {
    case WAS_WEAPON_GUN: {
        if (isManualFire _heli) then {
            _wpnStat = format["ROUNDS %1", _heli ammo "fza_m230"];
        } else { _wpnCtrl = "CGUN"; };
    };
    case WAS_WEAPON_MSL: {
        if (isManualFire _heli) then {
            _wpnStat = switch _mslTraj do { case "DIR": {"DIR MAN"}; case "LO": {"LO MAN"}; case "HI": {"HI MAN"}; default {""} };
        } else { _wpnCtrl = "CMSL"; };
    };
    case WAS_WEAPON_RKT: {
        if (isManualFire _heli) then {
            private _rktAmmo = getText (configFile >> "CfgWeapons" >> (_heli getVariable "fza_ah64_selectedRocket") >> "fza_ammoType");
            private _rktCode = getText (configFile >> "CfgAmmo" >> _rktAmmo >> "fza_shortCode");
            _wpnStat = format["%1 NORM %2", _rktCode, _heli ammo(_heli getVariable "fza_ah64_selectedRocket")];
        } else { _wpnCtrl = "CRKT"; };
    };
};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_WC), _wpnCtrl];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_WS), _wpnStat];

private _rngSrc = ["3.0", "1.5"] select (driver _heli isEqualTo player);
if (!isNull laserTarget _heli) then { _rngSrc = format["*%1", round(_heli distance laserTarget _heli)]; };
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_RRS), _rngSrc];

private _profMode    = _heli getVariable ["fza_ah64_fcrTpmProfMode", 0];
private _clearanceFt = _heli getVariable ["fza_ah64_fcrTpmClearance", 1];
private _profLabel   = ["GEOM","ARITH","TEST"] select _profMode;
_profLabel = "GEOM"; // TEMP: force GEOM until we implement Cscope display of lines
private _clrLabel    = ["20","50","100","200"] select _clearanceFt;
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TPM_PROF), _profLabel];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TPM_CLR),  _clrLabel];

// FOV auto-select with hysteresis per TM §4.35.16 — must be resolved before scan state
private _groundSpeedKts = (speed _heli) * 0.539957;
private _halfFov = _heli getVariable ["fza_ah64_fcrTpmHalfFov", 90];
if (_groundSpeedKts < 45) then { _halfFov = 90; };
if (_groundSpeedKts > 55) then { _halfFov = 45; };
_heli setVariable ["fza_ah64_fcrTpmHalfFov", _halfFov];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_TPM_WIDE), parseNumber (_halfFov > 45)];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _fcrScanDeltaTime = CBA_missionTime - _fcrScanStartTime;

// One sweep covers the sector width at the TPM antenna rate; cycle = there and back
private _halfSweepDuration = (_halfFov * 2) / FCR_TPM_SCAN_RATE_DEGS;
private _cycleDuration = _halfSweepDuration * 2;
private _tpmCueing = _fcrScanDeltaTime < 0 || { _heli getVariable ["fza_ah64_fcrWaitingForStart", false] };
if (_fcrScanState != FCR_MODE_OFF && !_tpmCueing) then {
    // Wiper bones are calibrated in the legacy time-base (wide 0..6.4, narrow 0..3.2) —
    // normalize the real phase into bone-time so bars and dish stay in sync at any scan rate
    private _boneCycle = [3.2, 6.4] select (_halfFov >= 90);
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      ((_fcrScanDeltaTime max 0) % _cycleDuration) / _cycleDuration * _boneCycle];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
};

private _linesOption = 4; // TEMP: forced until Cscope line display is implemented
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TPM_LINES), str _linesOption];

// TM 4.35.17: OBS window appears only when obstacles are detected (value drives text + box condition)
private _tpmObsCount = count (_heli getVariable ["fza_ah64_fcrTPMObsDisplay", []]);
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TPM_OBS), ["", str _tpmObsCount] select (_tpmObsCount > 0)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_TPM_OBS_SHOW), parseNumber (_tpmObsCount > 0)];

// Constant 1.5°/column at both FOVs — narrow (±45°) needs half the columns of wide (±90°)
private _aziSteps   = [60, 120] select (_halfFov >= 90);
private _rangeSteps = 150;
private _maxRange   = 2500;
private _aziStepD   = (_halfFov * 2) / _aziSteps;
private _rangeStep  = _maxRange / _rangeSteps;

// Dual-screen guard: first call per frame samples and consumes flags, second reuses the cache
private _frameCache = _heli getVariable ["fza_ah64_fcrTPMFrameCache", [-1, false, false, "", ""]];
private _sameFrame  = (_frameCache#0) == CBA_missionTime;

private _hardClear = false;
private _fovChange = false;
private _colJson   = "";
private _obsJson   = "";

if (_sameFrame) then {
    _hardClear = _frameCache#1;
    _fovChange = _frameCache#2;
    _colJson   = _frameCache#3;
    _obsJson   = _frameCache param [4, ""];
} else {
    private _prevHalfFov = _heli getVariable ["fza_ah64_fcrTPMPrevHalfFov", -1];
    _hardClear = _heli getVariable ["fza_ah64_fcrTPMHardClear", false];
    if (_hardClear) then {
        _heli setVariable ["fza_ah64_fcrTPMHardClear", false];
        _heli setVariable ["fza_ah64_fcrTPMObsDisplay", []];
    };
    // TM 4.15.3c: obstacles are not presented if FCR data is not valid (fault); a stopped healthy radar keeps its picture
    if (_fcrScanState == FCR_MODE_FAULT && (_heli getVariable ["fza_ah64_fcrTPMObsDisplay", []]) isNotEqualTo []) then {
        _heli setVariable ["fza_ah64_fcrTPMObsDisplay", []];
        _obsJson = "[]";
    };
    _fovChange = (!_hardClear && _halfFov != _prevHalfFov && _fcrScanState != FCR_MODE_OFF);
    private _newScan = _hardClear || _fovChange;
    _heli setVariable ["fza_ah64_fcrTPMPrevHalfFov", _halfFov];
    if (_newScan) then { _heli setVariable ["fza_ah64_fcrTPMLastColIdx", -1]; };

    if (_fcrScanState != FCR_MODE_OFF) then {
        private _t = (_fcrScanDeltaTime max 0) % _cycleDuration;
        private _scanBearingAzi = if (_t <= _halfSweepDuration) then {
            -_halfFov + (_t / _halfSweepDuration) * (_halfFov * 2)
        } else {
            _halfFov - ((_t - _halfSweepDuration) / _halfSweepDuration) * (_halfFov * 2)
        };

        private _colIdx = ((floor ((_scanBearingAzi + _halfFov) / _aziStepD)) min (_aziSteps - 1)) max 0;

        // Lock heading at each half-sweep flip so columns stay world-aligned
        private _prevSweepLtoR = _heli getVariable ["fza_ah64_fcrTPMPrevSweepLtoR", -1];
        private _curSweepLtoR  = parseNumber (_t <= _halfSweepDuration);
        if (_newScan || _prevSweepLtoR != _curSweepLtoR) then {
            _heli setVariable ["fza_ah64_fcrTPMScanHeading",   getDir _heli];
            _heli setVariable ["fza_ah64_fcrTPMPrevSweepLtoR", _curSweepLtoR];
            _heli setVariable ["fza_ah64_fcrTPMLastColIdx",    -1];
        };
        private _scanHeading = _heli getVariable ["fza_ah64_fcrTPMScanHeading", getDir _heli];

        private _lastColIdx = _heli getVariable ["fza_ah64_fcrTPMLastColIdx", -1];
        private _sweepLtoR  = (_t <= _halfSweepDuration);

        private _fillFrom = _colIdx;
        private _fillTo   = _colIdx;
        if (_newScan || _lastColIdx < 0) then {
            // Fresh sweep: backfill from the sweep-start edge up to the wiper
            if (_sweepLtoR) then { _fillFrom = 0; } else { _fillTo = _aziSteps - 1; };
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
            private _clearanceM = ([20, 50, 100, 200] select _clearanceFt) * 0.3048;
            private _safeHeight = _heliWheelZ - _clearanceM;
            // selectionPosition is model-space — world ASL Z = heli ASL Z + sensor Z offset
            private _FCRpos     = _heli selectionPosition ["sensorPos", "Memory"];
            private _FCRposZ    = if (_FCRpos isEqualTo [0,0,0]) then { _heliWheelZ + 3 } else { _heliWheelZ + (_FCRpos#2) };

            private _sampledCols = [];

            for "_ci" from _fillFrom to _fillTo do {
                private _relAzi   = -_halfFov + (_ci + 0.5) * _aziStepD;
                private _worldAzi = _scanHeading + _relAzi;

                private _colLevels    = [];
                private _horizonSlope = -9999;
                private _sinAzi       = sin _worldAzi;
                private _cosAzi       = cos _worldAzi;

                for "_ri" from 0 to (_rangeSteps - 1) do {
                    private _range = (_ri + 0.5) * _rangeStep;
                    private _terrainASL = getTerrainHeightASL [_heliX + _sinAzi * _range, _heliY + _cosAzi * _range, 0];
                    private _level = 2;
                    if (_terrainASL > -1000) then {
                        private _cellSlope = (_terrainASL + 1 - _FCRposZ) / _range;
                        if (_cellSlope <= _horizonSlope) then {
                            // Shadowed: grey while the grazing ray is above the clearance plane (hidden terrain could pierce it), black once below
                            _level = [0, 2] select (_FCRposZ + _horizonSlope * _range >= _safeHeight);
                        } else {
                            _horizonSlope = _cellSlope;
                            _level = if (_terrainASL < _safeHeight) then { 0 } else { [1, 3] select (_terrainASL >= _heliWheelZ) };
                        };
                    };
                    _colLevels pushBack _level;
                };

                _sampledCols pushBack format ["{""i"":%1,""d"":[%2]}", _ci, _colLevels joinString ","];
            };

            if (_sampledCols isNotEqualTo []) then {
                _colJson = "[" + (_sampledCols joinString ",") + "]";
            };
        };

        // TM fig 4-55: obstacles display all at once per completed half sweep (each pass covers the full sector)
        [_heli] call fza_fcr_fnc_buildTPMData;
        private _curHalf  = floor (_t / _halfSweepDuration);
        private _prevHalf = _heli getVariable ["fza_ah64_fcrTPMPrevHalf", -1];
        if (_newScan) then {
            _heli setVariable ["fza_ah64_fcrTPMPrevHalf", _curHalf];
        } else {
            if (_curHalf != _prevHalf && _prevHalf != -1) then {
                private _heliPosNow = getPosASL _heli;
                private _snapFCRpos = _heli selectionPosition ["sensorPos", "Memory"];
                private _sensorPos  = [_heliPosNow#0, _heliPosNow#1,
                    (_heliPosNow#2) + ([3, _snapFCRpos#2] select (_snapFCRpos isNotEqualTo [0,0,0]))];
                private _snapSafeHeight = (_heliPosNow#2) - (([20, 50, 100, 200] select _clearanceFt) * 0.3048);

                private _obsParts   = [];
                private _obsDisplay = [];
                {
                    _x params ["_ox", "_oy", ["_oTopZ", 1e9]];
                    private _oPos   = [_ox, _oy, 0];
                    private _oRange = _heliPosNow distance2D _oPos;
                    private _oAzi   = [(_heliPosNow getDir _oPos) - _scanHeading] call CBA_fnc_simplifyAngle180;
                    if ((abs _oAzi) > _halfFov || _oRange > _maxRange) then { continue; };
                    // Only structures penetrating the clearance plane, with radar LOS to their top
                    if (_oTopZ < _snapSafeHeight) then { continue; };
                    if (terrainIntersectASL [_sensorPos, [_ox, _oy, _oTopZ - 0.5]]) then { continue; };

                    _obsParts   pushBack format ['{"a":%1,"r":%2}', _oAzi toFixed 1, (_oRange / _maxRange) toFixed 4];
                    _obsDisplay pushBack [_ox, _oy, _oTopZ];
                } forEach (_heli getVariable ["fza_ah64_fcrTPMObstacles", []]);
                _obsJson = "[" + (_obsParts joinString ",") + "]";
                _heli setVariable ["fza_ah64_fcrTPMObsDisplay", _obsDisplay];
            };
            _heli setVariable ["fza_ah64_fcrTPMPrevHalf", _curHalf];
        };
    };

    _heli setVariable ["fza_ah64_fcrTPMFrameCache", [CBA_missionTime, _hardClear, _fovChange, _colJson, _obsJson]];
};

private _json = format[
    "{""mode"":4,""halfFov"":%1,""aziSteps"":%2,""rangeSteps"":%3,""profMode"":%4,""linesOption"":%5,""clearanceFt"":%6,""hardClear"":%7,""fovChange"":%8%9%10}",
    _halfFov,
    _aziSteps,
    _rangeSteps,
    _profMode,
    _linesOption,
    ([20, 50, 100, 200] select _clearanceFt),
    ["false","true"] select _hardClear,
    ["false","true"] select _fovChange,
    if (_colJson != "") then { format[",""columns"":%1", _colJson] } else { "" },
    // Only present on the completion frame — JS keeps the picture in between
    if (_obsJson != "") then { format[",""obstacles"":%1", _obsJson] } else { "" }
];

private _uniqueId = (_heli getVariable "fza_mpd_mpdState") # _mpdIndex # 9;
private _display  = (uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap]) getOrDefault [_uniqueId, displayNull];
if (!isNull _display) then {
    // Skip push when unchanged; keyed on the control so the cache dies with the display
    private _browserCtrl = _display displayCtrl 369;
    if ((_browserCtrl getVariable ["fza_fcrTpmLastJson", ""]) != _json) then {
        _browserCtrl setVariable ["fza_fcrTpmLastJson", _json];
        [_browserCtrl, format ["fzaFCRTpm.update(%1)", _json]] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
    };
};
