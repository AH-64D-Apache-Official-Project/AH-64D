params ["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

private _variant = (_state get "subPageVarPage") # 1;
private _type = _persistState getOrDefault ["znType", ZONE_KIND_PF];
private _opt = _persistState getOrDefault ["znOpt", 0];
private _need = [_persistState] call fza_mpd_fnc_tsdZNNeed;
_state set ["znNeed", _need];

private _entries = (_state getOrDefault ["znDraft", []]) param [0, []];
private _edit = [[1, 2] select (_type == ZONE_KIND_NF && {count _entries >= _need}), 0] select (_entries isEqualTo []);

// With the FCR powered the FCR's capability sets MULTI
private _fcrPower = _heli animationPhase "fcr_enable" == 1 && {((_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF]]) # 0) != FCR_MODE_OFF};
private _zoneState = _heli getVariable ["fza_dms_zoneState", ZONE_STATE_DEFAULT];
if (_fcrPower && {_zoneState # ZONE_STATE_NF_SINGLE}) then {
    _zoneState = +_zoneState;
    _zoneState set [ZONE_STATE_NF_SINGLE, false];
    [_heli, _zoneState] call fza_dms_fnc_zoneSetState;
};

private _zones = _heli getVariable (["fza_dms_pfZones", "fza_dms_nfZones"] select _type);
private _activePf = _zoneState # ZONE_STATE_ACTIVE_PF;
private _nfActive = _zoneState # ZONE_STATE_NF_ACTIVE;
private _isActive = {
    params ["_slot"];
    [_activePf == _slot, _nfActive param [_slot, false]] select (_type == ZONE_KIND_NF)
};
private _nfSel = _persistState getOrDefault ["znNfSel", 0];
private _pfSel = _persistState getOrDefault ["znPfSel", 0];

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_VARIANT), _variant];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_TYPE), _type];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_EDIT), _edit];

if (_variant == 0) exitWith {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_OPT), _opt];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_DRAW), _persistState getOrDefault ["znDraw", 0]];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_NF_SINGLE), BOOLTONUM(_zoneState # ZONE_STATE_NF_SINGLE)];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_FCR_POWER), BOOLTONUM(_fcrPower)];
    private _count = [_persistState getOrDefault ["znCount", 1], _persistState getOrDefault ["znKm", 2]] select (_opt == 2);
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ZN_COUNT), str _count];
    if (_type == ZONE_KIND_PF) then {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_ANY), BOOLTONUM(_zones findIf {_x isNotEqualTo -1} != -1)];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ZN_SEL), ["", "PF" + str (_activePf + 1)] select (_activePf >= 0)];
    } else {
        private _drawn = (_zones param [_nfSel, -1]) isNotEqualTo -1;
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_ANY), BOOLTONUM(_drawn)];
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_SEL), [0, [1, 2] select ([_nfSel] call _isActive)] select _drawn];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ZN_SEL), "NF" + str (_nfSel + 1)];
    };
};

if (_variant == 2) exitWith {
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ZN_DEL), ["ALL PF", "NF" + str (_nfSel + 1)] select (_type == ZONE_KIND_NF)];
};

// NF SEL and ASN: the eight zones
private _prefix = ["PF", "NF"] select (_variant == 1);
if (_variant == 1) then {
    _zones = _heli getVariable "fza_dms_nfZones";
    _type = ZONE_KIND_NF;
} else {
    _zones = _heli getVariable "fza_dms_pfZones";
    _type = ZONE_KIND_PF;
};
{
    private _drawn = (_zones param [_forEachIndex, -1]) isNotEqualTo -1;
    private _active = _drawn && {[_forEachIndex] call _isActive};
    _heli setUserMFDValue [MFD_INDEX_OFFSET(_x), [0, [1, 2] select _active] select _drawn];
    private _label = _prefix + str (_forEachIndex + 1) + (["?", ""] select _drawn) + (["", "<"] select _active);
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ZN_SLOT_1 + _forEachIndex), _label];
} forEach MFD_IND_TSD_ZN_SLOTS;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_SEL), 1 + ([_pfSel, _nfSel] select (_variant == 1))];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ZN_ANY), BOOLTONUM((_zones param [[_pfSel, _nfSel] select (_variant == 1), -1]) isNotEqualTo -1)];
