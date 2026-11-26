#include "\fza_ah64_ase\headers\ase.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

private _hidas = ASE_HIDAS(_heli);

//Chaff + Flares
private _chaffState = BOOLTONUM(_heli getVariable ["fza_ah64_ase_chaffState", ASE_CHAFF_STATE_SAFE] == ASE_CHAFF_STATE_ARM);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_CHAFF_STATE), _chaffState];
[_heli] call fza_ase_fnc_cmCounts params ["_flareL", "_flareR", "_chaff"];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_CMS_QTY), str _chaff];

//HIDAS
if (_hidas) then {
    private _qtyState = {
        params ["_count", "_full"];
        [[0, 1] select (_count <= _full / 2), 2] select (_count < 1)
    };
    private _qtyText = {
        params ["_label", "_count"];
        _label + ([" ", ""] select (_count > 9)) + str _count
    };
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_FLARE_L_QTY), [_flareL, ASE_CMDS_FLARES_SIDE] call _qtyState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_FLARE_R_QTY), [_flareR, ASE_CMDS_FLARES_SIDE] call _qtyState];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_CHAFF_QTY),   [_chaff, ASE_CMDS_CHAFF] call _qtyState];
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_FLARE_L),  ["FLARE ", _flareL] call _qtyText];
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_FLARE_R),  ["FLARE ", _flareR] call _qtyText];
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_CHAFF),    ["CHAFF ", _chaff] call _qtyText];
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_FL_TOTAL), "FL" + str (_flareL + _flareR)];
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_CH_TOTAL), "CH" + str _chaff];
    private _aseCount = {!(_x param [3, false])} count (_heli getVariable ["fza_ah64_ase_objects", []]);
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_COUNT),    "ASE " + str _aseCount];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_COUNT_WIDE),    BOOLTONUM(_aseCount > 9)];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_CMDS_MODE), _heli getVariable ["fza_ah64_ase_cmdsMode", ASE_CMDS_MAN]];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_VOICE),     _heli getVariable ["fza_ah64_ase_voiceLevel", ASE_AUTOPAGE_SRH]];
};

//IR Jammer
private _irJamPwr   = BOOLTONUM(_heli getVariable ["fza_ah64_ase_msnEquipPwr", ASE_MSNEQUIP_STATE_OFF] == ASE_MSNEQUIP_STATE_OFF);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_IRJAM_PWR), _irJamPwr];
_heli getVariable ["fza_ah64_ase_irJamState", [ASE_IRJAM_STATE_OFF, 0, 0]] params ["_irJamState"];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_IRJAM_STATE), _irJamState];

//Radar Jammer
private _rJamState = _heli getVariable ["fza_ah64_ase_rJamMode", ASE_RJAM_STATE_OFF];
if (_rJamState != ASE_RJAM_STATE_OFF && {ASE_RJAM_WARMING(_heli)}) then {
    _rJamState = [ASE_RJAM_STATE_WARM_STBY, ASE_RJAM_STATE_WARM_OPER] select (_rJamState == ASE_RJAM_STATE_OPER);
};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_RJAM_STATE), _rJamState];
private _rJamBolt = (_heli getVariable ["fza_ah64_ase_rJamXmit", false]) && {!([] call fza_mpd_fnc_iconBlink)};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_RJAM_XMIT), BOOLTONUM(_rJamBolt)];

//Autopage
private _autopage = _heli getVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_OFF];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_AUTOPAGE), _autopage];

//RLWR
private _rlwrPwr = BOOLTONUM(_heli getVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_OFF] == ASE_RLWR_STATE_OFF);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_RLWR_PWR), _rlwrPwr];
private _rlwrCount = _heli getVariable ["fza_ah64_ase_rlwrcount", 0];
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_RLWR_COUNT), _rlwrCount toFixed 0];

//The bearing to the active waypoint, in the box at the foot of the footprint
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_WPT_HDG), [_heli] call fza_mpd_fnc_wptBearingText];

//RFI
private _seat     = ["plt", "cpg"] select (([_heli] call fza_fnc_currentTurret) isEqualTo [0]);
private _rfiOn    = (_heli getVariable ["fza_ah64_ase_rfiPwr", ASE_RFI_STATE_ON]) == ASE_RFI_STATE_ON;
private _emitters = _heli getVariable ["fza_ah64_ase_rfiEmitters", []];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_RFI_PWR), [0, [1, 2] select _rfiOn] select (_heli animationPhase "fcr_enable" == 1)];
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_RFI_COUNT), str count _emitters];
private _caq = 0;
if (_rfiOn && {_heli animationPhase "fcr_enable" == 1} && {([_heli, "fza_ah64_sight", _seat] call fza_fnc_getSeatVariable) != SIGHT_FCR}) then {
    _caq = [1, 2] select ((_heli getVariable ["fza_mpd_aseCaq", [false, false]]) # _mpdIndex);
};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_CAQ), _caq];

//Mission equipment
_msn_equip_British = _heli animationPhase "msn_equip_british";
_heli setUserMFDValue  [MFD_INDEX_OFFSET(MFD_IND_ASE_BRITISH), _msn_equip_British];

_msn_equip_american = _heli animationPhase "msn_equip_American";
_heli setUserMFDValue  [MFD_INDEX_OFFSET(MFD_IND_ASE_AMERICAN), _msn_equip_american];

//ASE Points
private _pointsArray = [];
private _linesArray  = [];
private _aseObjects  = _heli getVariable ["fza_ah64_ase_objects", []];
// HIDAS: each state inside its ring, between it and the next ring in (outside the outer ring is for RFI threats).
// Launches and missiles share the track ring, told apart by flashing. By state: search, acquisition, track, launch,
// missile, laser designating
private _bandSrh = (MPD_ASE_RING_OUTER + MPD_ASE_RING_3) / 2;
private _bandAcq = (MPD_ASE_RING_3 + MPD_ASE_RING_2) / 2;
private _bandTrk = (MPD_ASE_RING_2 + MPD_ASE_RING_1) / 2;
private _rings  = [_bandSrh, _bandAcq, _bandTrk, _bandTrk, _bandTrk, _bandTrk];
// Each at its bearing, overlapping any others there
private _blink = [] call fza_mpd_fnc_iconBlink;
{
    _x params ["_state", "_object", "_iconClass", ["_ghost", false], "", ["_bold", false]];
    if (_ghost) then {_iconClass = [_iconClass] call fza_mpd_fnc_ghostIdent;};
    private _radius      = [0.27, _rings # _state] select _hidas;
    private _iconBearing = _heli getRelDir _object;
    private _iconPos     = [_radius * sin _iconBearing + 0.5, -_radius * cos _iconBearing + 0.5, 0.0];
    if (_blink && (_state >= ASE_LNC && _state != ASE_LSR)) then {continue;};
    _pointsArray pushBack [MPD_POSMODE_SCREEN, _iconPos, "", POINT_TYPE_ASE, _forEachIndex, _iconClass, _bold];
    // HIDAS shows the threat level by ring, without the track lines; a line runs to its icon, none once it has dimmed,
    // no longer detected
    if (_hidas || {_state <= ASE_ACQ} || {_ghost}) then {continue;};
    _linesArray pushBack [_iconBearing, MPD_ASE_LINE_RLWR];
} forEach _aseObjects;

// RFI threats outside the footprint, after the RLWR's so they draw over the ring, at the tuned radius
// (fza_mpd_fnc_threatSymbolTune)
private _rfiRadius = (fza_mpd_threatTune getOrDefault ["ase", MPD_THREAT_TUNE_ASE]) # 3;
[_heli, _seat, {
    params ["_bearing"];
    [0.5 + _rfiRadius * sin _bearing, 0.5 - _rfiRadius * cos _bearing]
}, getDir _heli] call fza_mpd_fnc_rfiPoints params ["_rfiPoints", "_rfiPicks", "_rfiTracks"];
_pointsArray append _rfiPoints;
_heli setVariable ["fza_mpd_aseRfiPicks_" + str _mpdIndex, _rfiPicks];
// One for each tracking emitter, US and HIDAS
_linesArray append (_rfiTracks apply {[_x, MPD_ASE_LINE_RFI]});

[_heli, _mpdIndex, _pointsArray, _linesArray] call fza_mpd_fnc_pageASEHtmlDraw;
