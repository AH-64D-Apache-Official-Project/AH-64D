#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_state", "_persistState"];

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";

if (_fcrMode != FCR_DISP_MODE_RMAP) exitWith {
    [_heli, _mpdIndex, "fcr"] call fza_mpd_fnc_setCurrentPage;
};

private _cScope  = _heli getVariable "fza_ah64_fcrcscope";
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CSCOPE), BOOLTONUM(_cScope)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_MODE), FCR_DISP_MODE_RMAP];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _fcrScanDeltaTime = CBA_missionTime - _fcrScanStartTime;
if (_fcrScanState != FCR_MODE_OFF) then {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ANIM),      (_fcrScanDeltaTime max 0) % 3.2];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_TYPE), _fcrScanState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 1];
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_LINE_SHOW), 0];
};

private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _sightSelStat = "HMD ";
switch _sight do {
    case 0: { _sightSelStat = "FCR "; };
    case 1: { _sightSelStat = "HMD "; };
    case 2: { _sightSelStat = "TADS"; };
    case 3: { _sightSelStat = "FXD "; };
};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_SSS), _sightSelStat];

private _nextPoint    = (_heli getVariable "fza_dms_routeNext") # 0;
private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
if (isNil "_nextPointPos") then {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_COMMAND_HEADING), -360];
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_COMMAND_HEADING), [(_heli getRelDir _nextPointPos)] call CBA_fnc_simplifyAngle180];
};

private _tadsAzimuth   = _heli getVariable "fza_ah64_tadsAzimuth";
private _tadsElevation = _heli getVariable "fza_ah64_tadsElevation";
private _altSensorPan  = if (player == gunner _heli) then { deg(_heli animationPhase "pnvs") } else { _tadsAzimuth };
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ALTERNATE_SENSOR), _altSensorPan];

_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time", "_lastDir"];
private _fcrHeading  = [(_dir     - direction _heli) mod 360] call CBA_fnc_simplifyAngle180;
private _lastHeading = [(_lastDir - direction _heli) mod 360] call CBA_fnc_simplifyAngle180;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CENTERLINE),  _fcrHeading];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_PREV_CENTER), _lastHeading];

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_FOV_X), _tadsAzimuth];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_FOV_Y), -_tadsElevation];

private _curTurret  = [_heli] call fza_fnc_currentTurret;
private _currentAcq = [_heli, _curTurret] call fza_fnc_targetingCurAcq;
private _acqVector  = [_heli, _currentAcq] call fza_fnc_targetingAcqVec;
_acqVector = _heli vectorWorldToModelVisual _acqVector;
_acqVector call CBA_fnc_vect2Polar params ["_magnitude", "_cuedLosX", "_cuedLosY"];
private _cuedLosX = _cuedLosX call CBA_fnc_simplifyAngle180;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CUEDLOS_X), _cuedLosX];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CUEDLOS_Y), -_cuedLosY];

private _nts    = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _rngSrc = if (isNull _nts) then {
    ["3.0", "1.5"] select (driver _heli isEqualTo player)
} else {
    format["R%1", ((_heli distance _nts) / 1000) toFixed 1]
};
if (!isNull laserTarget _heli) then { _rngSrc = format["*%1", round(_heli distance laserTarget _heli)]; };
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_RRS), _rngSrc];
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
[_heli, _mpdIndex, MFD_IND_FCR_ACQ_BOX, MFD_TEXT_IND_FCR_ACQ_SRC] call fza_mpd_fnc_acqDraw;

// ---- Terrain sampling ----

[_heli] call fza_fcr_fnc_resolveDisplay;
private _displayTargets = _heli getVariable "fza_ah64_fcrDisplayTargets";
private _fcrAzBias      = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _gtmHalfFov     = _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45];
// TM 4.41: RMAP re-select toggles the video underlay; sampling skipped while off, JS keeps the grid
private _rmapVideo      = _heli getVariable ["fza_ah64_fcrRmapVideo", true];

private _aziSteps     = 300;
private _nearSteps    = 150;
private _farSteps     = 150;
private _maxRange     = 8000;
private _nearMaxRange = 4000;
private _nearRangeStep = _nearMaxRange / _nearSteps;
private _farRangeStep  = (_maxRange - _nearMaxRange) / _farSteps;
private _aziStepD     = (_gtmHalfFov * 2) / _aziSteps;

// Dual-screen guard: first call per frame samples and consumes flags, second reuses the cache
private _frameCache = _heli getVariable ["fza_ah64_fcrRMAPFrameCache", [-1, false, ""]];
private _sameFrame  = (_frameCache#0) == CBA_missionTime;

private _hardClear = false;
private _colJson   = "";

if (_sameFrame) then {
    _hardClear = _frameCache#1;
    _colJson   = _frameCache#2;
} else {
    _hardClear = _heli getVariable ["fza_ah64_fcrRMAPHardClear", false];
    if (_hardClear) then {
        _heli setVariable ["fza_ah64_fcrRMAPHardClear",    false];
        _heli setVariable ["fza_ah64_fcrRMAPLastColIdx",    -1];
        _heli setVariable ["fza_ah64_fcrRMAPHorizonSlopes", []];
    };

    if (_fcrScanState != FCR_MODE_OFF && _rmapVideo) then {
        private _t = (_fcrScanDeltaTime max 0) % 3.2;
        private _isNearPhase = (_t <= 1.6);

        // Near sweeps L→R (0–4000m), far sweeps R→L (4000–8000m)
        private _scanBearingAzi = if (_isNearPhase) then {
            -_gtmHalfFov + (_t / 1.6) * (_gtmHalfFov * 2)
        } else {
            _gtmHalfFov - ((_t - 1.6) / 1.6) * (_gtmHalfFov * 2)
        };

        private _colIdx = ((floor ((_scanBearingAzi + _gtmHalfFov) / _aziStepD)) min (_aziSteps - 1)) max 0;

        // Lock heading to _dir at each phase flip to prevent misalignment mid-turn
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
        if (!_hardClear && _lastColIdx >= 0) then {
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

                private _prevTerrainZ = getTerrainHeightASL [_heliX + _sinAzi * (_startRange max _stepSize), _heliY + _cosAzi * (_startRange max _stepSize), 0];
                private _colLevels    = [];
                private _horizonSlope = if (_isNearPhase) then { -9999 } else { _savedSlopes param [_ci, -9999] };

                for "_ri" from 0 to (_stepCount - 1) do {
                    private _range      = _startRange + (_ri + 0.5) * _stepSize;
                    private _cellX      = _heliX + _sinAzi * _range;
                    private _cellY      = _heliY + _cosAzi * _range;
                    private _terrainASL = getTerrainHeightASL [_cellX, _cellY, 0];
                    private _level      = 0;

                    if (_terrainASL > -1000) then {
                        private _cellSlope = (_terrainASL + 1 - _FCRposZ) / _range;

                        if (_cellSlope > _horizonSlope) then {
                            _horizonSlope = _cellSlope;
                            // tan thresholds avoid atan: tan(1°)=0.0175 tan(5°)=0.0875 tan(15°)=0.268 tan(25°)=0.466 tan(35°)=0.700
                            private _slope = abs(_terrainASL - _prevTerrainZ) / _stepSize;
                            _level = if (_slope < 0.0175) then { 1 }
                                else { if (_slope < 0.0875) then { 2 }
                                else { if (_slope < 0.268)  then { 3 }
                                else { if (_slope < 0.466)  then { 4 }
                                else { [6, 5] select (_slope < 0.700) } } } };
                            private _surfType = surfaceType [_cellX, _cellY];
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
                    };

                    _prevTerrainZ = _terrainASL;
                    _colLevels pushBack _level;
                };

                // Accumulate near-phase horizon slopes locally — flushed once after column loop
                if (_isNearPhase) then {
                    while {count _newSlopes <= _ci} do { _newSlopes pushBack -9999; };
                    _newSlopes set [_ci, _horizonSlope];
                };

                _sampledCols pushBack format ["{""i"":%1,""near"":%2,""d"":[%3]}", _ci, _isNearStr, _colLevels joinString ","];
            };

            if (_isNearPhase && count _newSlopes > 0) then {
                _heli setVariable ["fza_ah64_fcrRMAPHorizonSlopes", _newSlopes];
            };

            if (_sampledCols isNotEqualTo []) then {
                _colJson = "[" + (_sampledCols joinString ",") + "]";
            };
        };
    };

    _heli setVariable ["fza_ah64_fcrRMAPFrameCache", [CBA_missionTime, _hardClear, _colJson]];
};

// ---- FCR targets / shot-at markers → HTML canvas (shared builder) ----

private _ntsIndex  = if (!isNull _nts) then { _displayTargets findIf {_x # 3 == _nts} } else { -1 };
private _antsIndex = -1;
if (count _displayTargets > 1 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (count _displayTargets min 16);
};

// "a" normalised to -1..1 by halfFov — the RMAP B-scope x axis
([_heli, _displayTargets, _scanPos, _ntsIndex, _antsIndex, _wasState,
    _gtmHalfFov, _maxRange, _dir, _fcrAzBias, _gtmHalfFov, false
] call fza_mpd_fnc_buildFCRTargetsJson) params ["_tgtJson", "_shotJson"];

private _json = format[
    '{"mode":3,"halfFov":%1,"aziSteps":%2,"nearSteps":%3,"farSteps":%4,"hardClear":%5,"scanActive":%6,"video":%7,"targets":[%8],"shots":[%9]%10}',
    _gtmHalfFov,
    _aziSteps,
    _nearSteps,
    _farSteps,
    ["false","true"] select _hardClear,
    ["false","true"] select (_fcrScanState != FCR_MODE_OFF),
    ["false","true"] select _rmapVideo,
    _tgtJson,
    _shotJson,
    if (_colJson != "") then { format[',"columns":%1', _colJson] } else { "" }
];

private _uniqueId    = (_heli getVariable "fza_mpd_mpdState") # _mpdIndex # 9;
private _rmapDisplay = (uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap]) getOrDefault [_uniqueId, displayNull];
if (!isNull _rmapDisplay) then {
    // Skip push when unchanged; keyed on the control so the cache dies with the display
    private _browserCtrl = _rmapDisplay displayCtrl 369;
    if ((_browserCtrl getVariable ["fza_fcrRmapLastJson", ""]) != _json) then {
        _browserCtrl setVariable ["fza_fcrRmapLastJson", _json];
        [_browserCtrl, format ["fzaFCRRmap.update(%1)", _json]] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
    };
};

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_COUNT), str (_heli getVariable "fza_ah64_fcrDisplayCount")];
