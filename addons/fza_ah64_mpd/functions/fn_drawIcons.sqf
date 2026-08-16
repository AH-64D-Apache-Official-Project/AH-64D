params
    [ "_heli"
    , "_dmsPoints"
    , "_displayIdx"
    , "_scale"
    , ["_center", [0.5, 0.75]]
    , ["_heading", direction (_this # 0)]
    , ["_heliPos", getPosASL (_this # 0)]
    ];

private _displaySide = ["left", "right"] select _displayIdx;
private _display = uiNamespace getVariable "fza_mpd_display" get _displaySide;

private _ctrlPoints = _display getVariable "fza_points";

{_y set ["updated", false]} forEach _ctrlPoints;

{
    if !(_forEachIndex in _ctrlPoints) then {_ctrlPoints set [_forEachIndex, createHashMap]};
    [_heli, _display, _x, _ctrlPoints get _forEachIndex, _scale, _center, _heading, _heliPos] call fza_mpd_fnc_uiDrawPoint;
    (_ctrlPoints get _forEachIndex) set ["updated", true];
} forEach _dmsPoints;

{
    if (_y get "updated") then {continue;};
    {if (typeName _y == "CONTROL") then {ctrlDelete _y;};} forEach _y;
} forEach _ctrlPoints;
displayUpdate _display;
