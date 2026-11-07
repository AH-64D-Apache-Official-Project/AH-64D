#include "\fza_ah64_dms\headers\constants.h"
// What the TSD draws of the zones, areas and lines:
// [world points, closed, line colour, dash (0 solid, 1 dashed, 2 alternating), label, label position, label class,
// label ID, more label positions]
params ["_heli", "_state", "_persistState", "_phase"];

private _onZn = (_state get "subPageVarPage") # 0 == 6;
private _znType = [-1, _persistState getOrDefault ["znType", ZONE_KIND_PF]] select _onZn;
private _inactive = _heli getVariable "fza_mpd_tsdShowInactiveZones" select _phase;
private _showAreas = _heli getVariable "fza_mpd_tsdShowAreas" select _phase;
private _showLines = _heli getVariable "fza_mpd_tsdShowLines" select _phase;
private _pf = _heli getVariable ["fza_dms_pfZones", []];
private _nf = _heli getVariable ["fza_dms_nfZones", []];
private _areas = _heli getVariable ["fza_dms_areas", []];
private _lines = _heli getVariable ["fza_dms_lines", []];
private _zoneState = _heli getVariable ["fza_dms_zoneState", ZONE_STATE_DEFAULT];

private _key = [_pf, _nf, _areas, _lines, _zoneState, _znType, _inactive, _showAreas, _showLines];
private _cache = _state getOrDefault ["zoneItemsKey", []];
private _same = count _cache == count _key;
{
    if (!_same) exitWith {};
    private _c = _cache # _forEachIndex;
    _same = [_x isEqualTo _c, _x isEqualRef _c] select (_x isEqualType [] && {_c isEqualType []});
} forEach _key;
if (_same) exitWith {_state get "zoneItems"};

private _items = [];
if (_showLines) then {
    {
        if (_x isEqualTo -1) then {continue};
        _x params ["_ident", "_pts"];
        // By the ident: FLOT blue, FLET red, FSCL white, phase and boundary lines green. Only a phase line has its ident,
        // at both ends: ending at the western one and running west, starting at the eastern one and running east
        private _kind = ["", "FLOT", "FLET", "FSCL"] find (_ident select [0, 4]);
        private _colour = [[0, 1, 0, 1], [0.4, 0.6, 1, 1], [1, 0, 0, 1], [1, 1, 1, 1]] select (_kind max 0);
        private _ends = [_pts # 0, _pts # (count _pts - 1)];
        if (_ends # 0 # 0 > _ends # 1 # 0) then {reverse _ends};
        private _label = ["", _ident] select (_ident select [0, 2] == "PL");
        _items pushBack [_pts, false, _colour, 0, _label, _ends # 1, "TSD_LINE_LABEL_EAST", [POINT_TYPE_LINE, _forEachIndex], [[_ends # 0, "TSD_LINE_LABEL_WEST"]]];
    } forEach _lines;
};
if (_showAreas) then {
    {
        if (_x isEqualTo -1) then {continue};
        _x params ["", "_pts"];
        // Labelled by its number, EA01-EA12, not its ident
        _items pushBack [_pts, true, [1, 0, 0.2, 1], 0, "EA" + ([_forEachIndex + 1, 2] call CBA_fnc_formatNumber), [_pts] call fza_dms_fnc_zoneCentroid, "TSD_AREA_LABEL", [POINT_TYPE_AREA, _forEachIndex]];
    } forEach _areas;
};

// PF zones white, NF zones yellow; the active ones alternate their dashes, the others are dashed
private _activePf = _zoneState # ZONE_STATE_ACTIVE_PF;
private _ownPf = _zoneState # ZONE_STATE_OWN_PF;
{
    if (_x isEqualTo -1) then {continue};
    private _active = _forEachIndex == _activePf;
    if (!_active && {!_inactive} && {_znType != ZONE_KIND_PF}) then {continue};
    private _label = ["PF" + str (_forEachIndex + 1), ""] select _active;
    if (_forEachIndex == _ownPf) then {_label = "OWN"};
    _items pushBack [_x, true, [1, 1, 1, 1], [1, 2] select _active, _label, [_x] call fza_dms_fnc_zoneCentroid, "TSD_ZONE_LABEL_WHITE", [POINT_TYPE_ZONE, _forEachIndex]];
} forEach _pf;

private _nfActive = _zoneState # ZONE_STATE_NF_ACTIVE;
{
    if (_x isEqualTo -1) then {continue};
    private _active = _nfActive param [_forEachIndex, false];
    if (!_active && {!_inactive} && {_znType != ZONE_KIND_NF}) then {continue};
    _items pushBack [_x, true, [1, 1, 0, 1], [1, 2] select _active, "NF" + str (_forEachIndex + 1), [_x] call fza_dms_fnc_zoneCentroid, "TSD_ZONE_LABEL_YELLOW", [POINT_TYPE_ZONE, ZONE_COUNT_PF + _forEachIndex]];
} forEach _nf;

_state set ["zoneItemsKey", _key];
_state set ["zoneItems", _items];
_items
