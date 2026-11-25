params["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_ase\headers\ase.h"
#include "\bmkhs_helisim\functions\core\core.hpp"

private _phase        = BOOLTONUM(_persistState get "mode" == "atk");
private _rangesetting = _persistState get "tsdScale";
private _tsdScale     = [_persistState] call fza_mpd_fnc_tsdScale;
private _ctrX         = 0.5;
private _ctrY         = 0.75 - 0.25 * (_persistState get "ctr");

// The map's frame, live or frozen; while frozen the live ownship moves over it
([_heli, _persistState] call fza_mpd_fnc_tsdFrame) params ["_framePos", "_frameHeading", "_frozen"];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_FROZEN), BOOLTONUM(_frozen)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_HSI_HDG), _frameHeading];
// The heading behind, in the box at the foot of the map, as the ASE page's
private _recip = round ((getDir _heli + 180) % 360);
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_HDG_RECIP), str ([_recip, 360] select (_recip == 0))];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_CAQ), _state getOrDefault ["caq", 0]];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZOOM), _persistState getOrDefault ["zoom", 0]];
// Whether the MPD cursor is over the map, where it chooses points and pans
private _cursorOn = _heli getVariable ["fza_mpd_cursor", []];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_CURSOR_MAP), BOOLTONUM(_cursorOn param [0, -1] == _mpdIndex && {[_heli, _mpdIndex, _cursorOn # 1, _cursorOn # 2] call fza_mpd_fnc_cursorInArea})];
if (_frozen) then {
    ([_framePos, _frameHeading, _tsdScale, [_ctrX, _ctrY], getPosASL _heli] call fza_mpd_fnc_tsdWorldToScreen) params ["_ownX", "_ownY"];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_OWNSHIP_X), _ownX];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_OWNSHIP_Y), _ownY];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_OWNSHIP_ROT), ((direction _heli - _frameHeading) + 360) mod 360];
};

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_PHASE), _phase];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SUBPAGE), _state get "subPageVarPage" select 0];

//Show options
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SCALE_BOXES), _rangesetting];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_HSI),  BOOLTONUM(_heli getVariable "fza_mpd_tsdShowHsi" select _phase)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WIND), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowWind" select _phase)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_ENDR), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowEndr" select _phase)];

// Wind Data
private _windDir = _heli getVariable "bmkhs_windDirFrom";
private _windVel = round ((_heli getVariable "bmkhs_windSpeed") * MPS_TO_KNOTS); //067°/15
private _wind_text = format["%1° /%2", [_windDir, 3] call CBA_fnc_formatNumber, [_windVel, 2] call CBA_fnc_formatNumber];
if (_windvel < 5) then {_wind_text = "  CALM  ";};

//ASE footprint
private _rlwrPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_rlwrPwr" == ASE_RLWR_STATE_OFF);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ASE_FOOTPRINT), _rlwrPwr];

//TSD Centering
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_CTR), _persistState get "ctr"];

//TSD phase
if (_persistState get "mode" == "atk") then {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowAtkCurrRoute")];
} else {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowNavWptData")];
};
switch (_state get "subPageVarPage" select 0) do {
    case 0: { //Root
        [_heli, true] call fza_mpd_fnc_tsdWaypointStatusText params ["_waypointId", "_groundspeed", "_waypointDist", "_waypointEta"];

        [_heli] call fza_mpd_fnc_fuelGetData params [ ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , ""
                                                    , "_totalEnduranceNumber"
                                                    ];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WPDEST), _waypointId];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WPDIST), _waypointDist];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WPETA),  _waypointEta];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_GROUNDSPEED), _groundSpeed];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_ENDR), _totalEnduranceNumber];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WIND), _wind_text];
        private _rJamState = _heli getVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF];
        if (_rJamState != ASE_RJAM_STATE_OFF && {ASE_RJAM_WARMING(_heli)}) then {
            _rJamState = [ASE_RJAM_STATE_WARM_STBY, ASE_RJAM_STATE_WARM_OPER] select (_rJamState == ASE_RJAM_STATE_OPER);
        };
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ROOT_RJAM), _rJamState];
    };
    case 1: {   //SHOW
        _this call fza_mpd_fnc_tsdShowDraw;
    };
    case 2: {   //WPT
        _this call fza_mpd_fnc_tsdWptDraw;
    };
    case 3: {   //RTE
        _this call fza_mpd_fnc_tsdRteDraw;
    };
    case 4: {   //THRT
        _this call fza_mpd_fnc_tsdThrtDraw;
    };
    case 5: {   //PAN
        _this call fza_mpd_fnc_tsdPanDraw;
    };
    case 6: {   //ZN
        _this call fza_mpd_fnc_tsdZNDraw;
    };
};

// The route menu has no map
if ((_state get "subPageVarPage") isEqualTo TSD_RTE_RTM) exitWith {
    _state set ["cursorPoints", []];
    _state set ["cursorFcr", []];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_CURSOR_POINT), 0];
    [_heli, _mpdIndex, _state, _persistState] call fza_mpd_fnc_tsdHtmlDraw;
};

_this call fza_mpd_fnc_tsdScaleDraw;

//TSD Points
private _pointsArray      = [];
private _showEnemy        = _heli getVariable "fza_mpd_tsdShowEnemy" select _phase;
private _showFriendly     = _heli getVariable "fza_mpd_tsdShowFriendly" select _phase;
private _showPlanTgts     = _heli getVariable "fza_mpd_tsdShowPlanTgts" select _phase;
private _showCtrlmeasures = _heli getVariable "fza_mpd_tsdShowCtrlMeasures" select _phase;
private _showAtkShot      = _heli getVariable "fza_mpd_tsdShowAtkShot";
private _showAtkHazzard   = _heli getVariable "fza_mpd_tsdShowAtkHazard";

// The DMS's fixed slots, the empty ones -1, skipped before anything else is done with them
{
    {
        if (_x isEqualTo -1) then {continue;};
        private _type = _x # POINT_GET_TYPE;
        //Ctrl Measures, shown by their colour
        if (_type == POINT_TYPE_CM) then {
            private _details = [_x # POINT_GET_IDENT] call fza_dms_fnc_pointGetIdentDetails;
            private _color = if (isNil "_details") then {[]} else {_details param [3, []]};
            if (!_showEnemy && _color isEqualTo [1.0, 0.0, 0.2, 1]) then {continue;};
            if (!_showFriendly && _color isEqualTo [0.4, 0.6, 1.0, 1]) then {continue;};
            if (!_showCtrlmeasures && _color isEqualTo [0.0, 1.0, 0.5, 1]) then {continue;};
        };
        //Hazards
        if (_type == POINT_TYPE_HZ && !_showAtkHazzard && _phase == 1) then {continue;};
        //PLANNED TGT/THRT
        if (_type == POINT_TYPE_TG && !_showPlanTgts) then {continue;};

        _pointsArray pushBack (_x select [0,7]);
    } forEach (_heli getVariable [_x, []]);
} forEach (["fza_dms_waypointsHazards", "fza_dms_controlMeasures", "fza_dms_targetsThreats"]);
// The points the MPD cursor can choose (fza_mpd_fnc_cursorPoint): where each is, and its point ID
_state set ["cursorPoints", _pointsArray apply {[_x # 1, _x # 4]}];

// Zone, area and line labels; their lines are drawn by the page (fza_mpd_fnc_tsdHtmlDraw)
_pointsArray append ([[_heli, _state, _persistState, _phase] call fza_mpd_fnc_tsdZoneItems] call fza_mpd_fnc_tsdZoneLabels);

// Shot at, in one pass over the fixed slots: the ones before launch under the FCR targets, the rest over them. The
// slot is the point's ID.
private _shotUnder = [];
private _shotOver  = [];
if (_showAtkShot) then {
    {
        if (_x isEqualTo -1) then {continue;};
        private _shotPos = _x # 4;
        private _overlay = _x # 6;
        if (_overlay == 0 && {_rangesetting < 25000}) then {
            _shotUnder pushBack [MPD_POSMODE_WORLD, _shotPos, "", POINT_TYPE_SHOT, _forEachIndex, "FCR_TSD_SHOTAT"];
        };
        if (_overlay == 1) then {
            _shotOver pushBack [MPD_POSMODE_WORLD, _shotPos, "", POINT_TYPE_SHOT, _forEachIndex, ["FCR_TSD_SHOTAT", "FCR_TSD_SC25_50_GREEN"] select (_rangesetting >= 25000)];
        };
    } forEach (_heli getVariable ["fza_dms_shotAt", []]);
};
_pointsArray append _shotUnder;

//FCR obstacles from TPM, under the targets
private _showObstacles = _heli getVariable "fza_mpd_tsdShowObstacles" select _phase;
if (_showObstacles && _rangesetting < 25000) then {
    {
        _x params ["_ox", "_oy"];
        _pointsArray pushBack [MPD_POSMODE_WORLD, [_ox, _oy, 0], "", POINT_TYPE_SYSTEM, _forEachIndex, "TSD_FCR_OBSTACLE"];
    } forEach (_heli getVariable ["fza_ah64_fcrTPMObsDisplay", []]);
};

//FCR Points: the top targets, and in the attack phase with TOTAL TGTS/OBSTACLES the low priority ones as well
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];
private _displayTargets = (_heli getVariable "fza_ah64_fcrDisplayTargets") select [0, [FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS, FCR_TARGET_FILE] select (_phase == 1 && _showObstacles)];
private _systemWas      = _heli getVariable "fza_ah64_was";

private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _displayTargets findIf {_x # 3 == _nts};
private _antsIndex = [_displayTargets, _ntsIndex] call fza_fcr_fnc_antsIndex;

// The FCR targets drawn, for CAQ (fza_mpd_fnc_cursorPoint): where each is, an ID, and the target
private _cursorFcr = [];
{
    _x params ["_pos", "_type", "_moving", "_target"];
    private _ident = "";
    private _distance_m = _scanPos distance2D _pos;
    //Selection status
    private _selStatus = 0;
    if (_forEachIndex == _ntsIndex) then { _selStatus = 1; };
    if (_forEachIndex == _antsIndex) then { _selStatus = 2; };

    if (_rangesetting < 25000) then {
        _ident = [_type, _distance_m, _moving, _selStatus, _systemWas == WAS_WEAPON_NONE] call fza_mpd_fnc_buildFCRIdent;
        if (_ident == "") then {continue;};
    } else {
        _ident = "FCR_TSD_SC25_50_YELLOW";
    };
    // Low priority, unless it is the NTS or ANTS
    if (_forEachIndex >= FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS && _selStatus == 0) then {_ident = _ident + "_LOW";};
    // Merged with an RFI emitter (fza_fcr_fnc_update): its type characters over the symbol
    if (_rangesetting < 25000) then {
        private _chars = [_heli, _target] call fza_ase_fnc_rfiMergedChars;
        if (_chars isNotEqualTo []) then {_ident = [_ident, _chars] call fza_mpd_fnc_rfiMergedIdent};
    };

    _pointsArray pushBack [MPD_POSMODE_WORLD, _pos, "", POINT_TYPE_FCR, _forEachIndex, _ident];
    _cursorFcr pushBack [_pos, [POINT_TYPE_FCR, _forEachIndex], _target];
} forEach _displayTargets;
_state set ["cursorFcr", _cursorFcr];
// The FCR footprint is drawn with the TSD's lines (fza_mpd_fnc_tsdSegments)

// The points from here on move with the aircraft or other units
private _dynStart = count _pointsArray;

//Blue force tracker points, only looked for while shown
if (_showFriendly) then {
    private _icon = ["TSD_BLUEFORCE_TRACKER", "FCR_TSD_SC25_50_BLUE"] select (_rangesetting >= 25000);
    {
        private _object = _x # 0;
        if (_object isEqualTo _heli || {side _object != playerSide}) then {continue;};
        if !(_object isKindOf "car" || {_object isKindOf "tank"} || {_object isKindOf "air"} || {_object isKindOf "ship"}) then {continue;};
        _pointsArray pushBack [MPD_POSMODE_WORLD, getPos _object, "", POINT_TYPE_BFT, _forEachIndex, _icon];
    } forEach (listRemoteTargets playerSide);
};

//Shot At Overlay
_pointsArray append _shotOver;

//ASE Points
private _ctrX       = 0.5;
private _ctrY       = 0.75 - 0.25 * (_persistState get "ctr");
private _aseObjects = _heli getVariable ["fza_ah64_ase_objects", []];
private _showRLWR = _heli getVariable "fza_mpd_tsdShowRlwr" select _phase;
if (_showRLWR) then {
    // Radar threats too far above or below for a bearing: uncorrelated, in a row just in front of the ownship
    private _uncorrelated = _aseObjects apply {(_x # 0) <= ASE_LNC && {count _x > 4} && {[_heli, _x # 1] call fza_ase_fnc_rlwrUncorrelated}};
    private _uncorrelatedCount = {_x} count _uncorrelated;
    // The rest relative to the map's heading, frozen or live, spread apart in bearing order
    private _correlated = [];
    {if !(_uncorrelated # _forEachIndex) then {_correlated pushBack _forEachIndex;};} forEach _aseObjects;
    private _rlwrBearings = [_correlated apply {(_heli getDir ((_aseObjects # _x) # 1)) - _frameHeading}, 12] call fza_mpd_fnc_spreadBearings;
    private _uncorrelatedAt = 0;
    {
        _x params ["_aseState", "_object", "_iconClass", ["_ghost", false], "", ["_bold", false]];
        if (_ghost) then {_iconClass = [_iconClass] call fza_mpd_fnc_ghostIdent;};
        private _screen = [];
        if (_uncorrelated # _forEachIndex) then {
            _screen = [_ctrX + (_uncorrelatedAt - (_uncorrelatedCount - 1) / 2) * MPD_ASE_ICON_GAP, _ctrY - MPD_ASE_UNCORRELATED];
            _uncorrelatedAt = _uncorrelatedAt + 1;
        } else {
            _screen = [_ctrX, _ctrY, 0.23, 0.77, 0.23, 0.77, _rlwrBearings # (_correlated find _forEachIndex)] call fza_mpd_fnc_bearingToScreen;
        };
        if (([] call fza_mpd_fnc_iconBlink) && (_aseState >= ASE_LNC && _aseState != ASE_LSR)) then {continue;};
        _pointsArray pushBack [MPD_POSMODE_SCREEN, [_screen # 0, _screen # 1, 0.0], "", POINT_TYPE_ASE, _forEachIndex, _iconClass, _bold];
    } forEach _aseObjects;
};

//RFI threats, outside the ASE footprint
private _rfiPicks = [];
if (_heli getVariable ["fza_mpd_tsdShowRfi", [true, true]] select _phase) then {
    private _seat = ["plt", "cpg"] select (([_heli] call fza_fnc_currentTurret) isEqualTo [0]);
    [_heli, _seat, {
        params ["_bearing"];
        // Between the map border (TSD_MAP_CLIP) and the ASE footprint (0.18-0.82), as tuned (fza_mpd_fnc_threatSymbolTune)
        private _edge = (fza_mpd_threatTune getOrDefault ["tsd", MPD_THREAT_TUNE_TSD]) # 3;
        [_ctrX, _ctrY, _edge, 1 - _edge, _edge, 1 - _edge, _bearing] call fza_mpd_fnc_bearingToScreen
    }, _frameHeading] call fza_mpd_fnc_rfiPoints params ["_rfiPoints", "_picks"];
    _pointsArray append _rfiPoints;
    _rfiPicks = _picks;
};
_state set ["cursorRfi", _rfiPicks];

//TSD Sensor line
private _sightCpg = [_heli, "fza_ah64_sight" , "cpg"] call fza_fnc_getSeatVariable;
_posTadsTgt = _heli getVariable ["fza_ah64_tadsTarget", [-1,-1,-1]];

if (_posTadsTgt isNotEqualTo [-1,-1,-1] && _sightCpg isEqualTo SIGHT_TADS) then {
    _pointsArray pushBack [MPD_POSMODE_WORLD, _posTadsTgt, "", POINT_TYPE_SYSTEM, 0, "TSD_TADS_CROSSHAIR"];
};


// Only the top level has the ACQ button: SHOW uses the ACQ list's slots
if ((_state get "subPageVarPage" select 0) == 0) then {
    [_heli, _mpdIndex, MFD_IND_TSD_ACQ_BOX, MFD_TEXT_IND_TSD_ACQ_SRC] call fza_mpd_fnc_acqDraw;
};

// The point the MPD cursor is on, if on this MPD
private _cursor = _heli getVariable ["fza_mpd_cursor", []];
private _highlight = [[], _cursor param [8, []]] select (_cursor param [0, -1] == _mpdIndex);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_CURSOR_POINT), BOOLTONUM(_highlight isNotEqualTo [])];

// The map's symbols and lines, drawn by the page
[_heli, _mpdIndex, _state, _persistState, _pointsArray, _dynStart, _highlight] call fza_mpd_fnc_tsdHtmlDraw;
