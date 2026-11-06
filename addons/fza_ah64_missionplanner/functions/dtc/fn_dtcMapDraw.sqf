// The DTC map's lines, areas and zones (fza_mplanner_fnc_dtcMap "sync"), and the one being drawn out to the mouse
params ["_map"];

private _colours = [[0, 0.5, 0, 1], [0, 0.3, 0.85, 1], [0.15, 0.15, 0.15, 1], [0.95, 0.55, 0, 1], [0.6, 0, 0.7, 1]];
private _w0 = _map ctrlMapScreenToWorld [0, 0];
private _halfWidth = (_w0 distance2D (_map ctrlMapScreenToWorld [0.004, 0])) / 2;
if (_halfWidth <= 0) exitWith {};

private _segment = {
    params ["_a", "_b", "_colour"];
    private _length = _a distance2D _b;
    if (_length <= 0) exitWith {};
    private _mid = [((_a # 0) + (_b # 0)) / 2, ((_a # 1) + (_b # 1)) / 2];
    _map drawRectangle [_mid, _halfWidth, _length / 2, _a getDir _b, _colour, format (["#(rgb,8,8,3)color(%1,%2,%3,%4)"] + _colour)];
};
private _shape = {
    params ["_pts", "_closed", "_colour"];
    private _pts2 = _pts apply {[_x # 0, _x # 1]};
    for "_i" from 1 to count _pts2 - 1 do {[_pts2 # (_i - 1), _pts2 # _i, _colour] call _segment};
    if (_closed && {count _pts2 > 2}) then {[_pts2 # (count _pts2 - 1), _pts2 # 0, _colour] call _segment};
};

{
    _x params [["_pts", []], ["_closed", false], ["_colourIndex", 0], ["_label", ""]];
    if (count _pts < 2) then {continue};
    private _colour = _colours param [_colourIndex, _colours # 0];
    [_pts, _closed, _colour] call _shape;
    if (_label != "") then {
        private _sum = [0, 0];
        {_sum = [(_sum # 0) + (_x # 0), (_sum # 1) + (_x # 1)]} forEach _pts;
        private _at = [[(_sum # 0) / count _pts, (_sum # 1) / count _pts], _pts # (count _pts - 1)] select !_closed;
        _map drawIcon ["#(argb,8,8,3)color(0,0,0,0)", _colour, [_at # 0, _at # 1], 0, 0, 0, _label, 2, 0.045, "PuristaBold", "center"];
    };
} forEach (uiNamespace getVariable ["fza_mplanner_dtcDraw", []]);

// The route chosen on the Routes tab, then the points, as the TSD draws them
private _route = (uiNamespace getVariable ["fza_mplanner_dtcRoute", []]) apply {[_x # 0, _x # 1]};
if (count _route > 1) then {[_route, false, _colours # 4] call _shape};
{
    _x params [["_pos", []], ["_label", ""], ["_ident", ""]];
    if (count _pos < 2) then {continue};
    private _details = [_ident] call fza_dms_fnc_pointGetIdentDetails;
    if (isNil "_details") then {_details = []};
    _details params [["_tex", ""], ["_tex2", ""], "", ["_colour", [0, 0, 0, 1]]];
    if (_colour isEqualTo []) then {_colour = [0, 0, 0, 1]};
    private _at = [_pos # 0, _pos # 1];
    if (_tex != "") then {_map drawIcon [_tex, _colour, _at, 26, 26, 0]};
    if (_tex2 != "") then {_map drawIcon [_tex2, _colour, _at, 26, 26, 0]};
    _map drawIcon ["#(argb,8,8,3)color(0,0,0,0)", [0, 0, 0, 1], _at, 22, 22, 0, _label, 2, 0.04, "PuristaBold", "right"];
} forEach (uiNamespace getVariable ["fza_mplanner_dtcPoints", []]);

// The shape being drawn: its points so far, out to the mouse; a box from its corner
private _draft = uiNamespace getVariable ["fza_mplanner_dtcDraft", 0];
if !(_draft isEqualType createHashMap) exitWith {};
private _verts = (_draft getOrDefault ["pts", []]) apply {[_x # 0, _x # 1]};
private _colour = _colours param [_draft getOrDefault ["c", 0], _colours # 0];
private _box = _draft getOrDefault ["box", false];
getMousePosition params ["_mx", "_my"];
(ctrlPosition _map) params ["_cx", "_cy", "_cw", "_ch"];
private _mouse = [];
if (_mx > _cx && {_mx < _cx + _cw} && {_my > _cy} && {_my < _cy + _ch}) then {
    private _w = _map ctrlMapScreenToWorld [_mx, _my];
    _mouse = [_w # 0, _w # 1];
};
{_map drawIcon ["\A3\ui_f\data\map\markers\military\dot_CA.paa", _colour, _x, 12, 12, 0]} forEach _verts;
if (_mouse isEqualTo []) exitWith {
    if (count _verts > 1) then {[_verts, false, _colour] call _shape};
};
if (_box && {count _verts == 1}) exitWith {
    (_verts # 0) params ["_ax", "_ay"];
    _mouse params ["_bx", "_by"];
    [[[_ax, _ay], [_ax, _by], [_bx, _by], [_bx, _ay]], true, _colour] call _shape;
};
if (_verts isNotEqualTo []) then {
    [_verts + [_mouse], (count _verts > 1) && {_draft getOrDefault ["closed", false]}, _colour] call _shape;
};
