#include "\fza_ah64_ase\headers\ase.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

private _hidas = ASE_HIDAS(_heli);

//Chaff + Flares
private _chaffState = BOOLTONUM(_heli getVariable "fza_ah64_ase_chaffState" == ASE_CHAFF_STATE_ARM);
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
    private _aseCount = count (_heli getVariable ["fza_ah64_ase_objects", []]);
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_COUNT),    "ASE " + str _aseCount];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_COUNT_WIDE),    BOOLTONUM(_aseCount > 9)];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_CMDS_MODE), _heli getVariable ["fza_ah64_ase_cmdsMode", ASE_CMDS_MAN]];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_VOICE),     _heli getVariable ["fza_ah64_ase_voiceLevel", ASE_AUTOPAGE_SRH]];
};

//IR Jammer
private _irJamPwr   = BOOLTONUM(_heli getVariable "fza_ah64_ase_msnEquipPwr" == ASE_MSNEQUIP_STATE_OFF);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_IRJAM_PWR), _irJamPwr];
_heli getVariable "fza_ah64_ase_irJamState" params ["_irJamState"];
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
private _autopage = _heli getVariable "fza_ah64_ase_autopage";
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_AUTOPAGE), _autopage];

//RLWR
private _rlwrPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_rlwrPwr" == ASE_RLWR_STATE_OFF);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_RLWR_PWR), _rlwrPwr];
private _rlwrCount = _heli getVariable "fza_ah64_ase_rlwrcount";
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_RLWR_COUNT), _rlwrCount toFixed 0];

//Mission equipment 
_msn_equip_British = _heli animationPhase "msn_equip_british";
_heli setUserMFDValue  [MFD_INDEX_OFFSET(MFD_IND_ASE_BRITISH), _msn_equip_British];

_msn_equip_american = _heli animationPhase "msn_equip_American";
_heli setUserMFDValue  [MFD_INDEX_OFFSET(MFD_IND_ASE_AMERICAN), _msn_equip_american];

//ASE Points
private _pointsArray = [];
private _linesArray  = [];
private _aseObjects  = _heli getVariable "fza_ah64_ase_objects";
// HIDAS: each state inside its ring, between it and the next ring in (outside the outer ring is for RFI threats).
// By state: search, acquisition, track, launch, missile, laser designating
private _bandSrh = (MPD_ASE_RING_OUTER + MPD_ASE_RING_3) / 2;
private _bandAcq = (MPD_ASE_RING_3 + MPD_ASE_RING_2) / 2;
private _bandTrk = (MPD_ASE_RING_2 + MPD_ASE_RING_1) / 2;
private _bandLnc = (MPD_ASE_RING_1 + MPD_ASE_OWNSHIP) / 2;
private _rings  = [_bandSrh, _bandAcq, _bandTrk, _bandLnc, _bandLnc, _bandTrk];
private _placed = [];
{
    _x params ["_state", "_object","_iconClass"];
    private _index   = _forEachIndex;
    private _bearing = _heli getRelDir _object;
    private _radius  = 0.27;
    private _iconBearing = _bearing;
    if (_hidas) then {
        _radius = _rings # _state;
        // Icons on one ring are spread apart
        {
            _x params ["_placedRadius", "_placedBearing"];
            if (_placedRadius == _radius && {abs ((_iconBearing - _placedBearing + 540) % 360 - 180) < 10}) then {_iconBearing = _placedBearing + 10;};
        } forEach _placed;
        _placed pushBack [_radius, _iconBearing];
    };
    if (([] call fza_mpd_fnc_iconBlink) && (_state >= ASE_LNC && _state != ASE_LSR)) then {continue;};
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_radius * sin _iconBearing + 0.5, -_radius * cos _iconBearing + 0.5, 0.0], "", POINT_TYPE_ASE, _index, _iconClass];
    // HIDAS shows the threat level by ring, without the track lines
    if (_hidas || {_state <= ASE_ACQ}) then {continue;};
    _linesArray pushBack [_bearing];
} forEach _aseObjects;

for "_i" from 0 to 6 do {
    if (_i >= count _linesArray) then {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_01_AZ + _i), -1];
    } else {
        (_linesArray select _i) params ["_azimuth"];
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ASE_01_AZ + _i), _azimuth];
    };
};

[_heli, _pointsArray, _mpdIndex, 1, [0.5, 0.5]] call fza_mpd_fnc_drawIcons;
