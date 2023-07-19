/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_drawIcons

Description:
    Draws the points inputted on the right hand MPD, performing all necessary positioning

Parameters:
    _heli - The helicopter to draw this on (the player must be in it)
    _points - the points to draw on the screen. An array with arrays in it that fit the following schema
        [_posMode, _pos, _tex, _color, _textMode, _text1, _text2]
        where:
            _posMode is how to read the position, either MPD_POSMODE_WORLD or MPD_POSMODE_SCREEN
            _pos is 2d position of the point, in the aforementioned mode
            _tex is the texture to apply to the centre of the point
            _color is the color to apply (MPD_ICON_COLOR_GREEN .. MPD_ICON_COLOR_YELLOW)
            _textMode is the text mode (MPD_ICON_TYPE_A .. G)
            _text1 is the first part of text
            _text2 is the second part of text, where applicable
    _display - 1 if right, 0 if left
    _scale - (optional) Ratio to apply to scale from the world's size to the MPD size. Defaults to *persist state "tsdScale" x 0.75*
    _center - (optional) Where in the screen should be where the "helicopter" should be when converting from world. Defaults to [0.5, 0.25]

Returns:
    Nothing

Examples:

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params
    [ "_heli"
    , "_dmsPoints"
    , "_displayIdx"
    , ["_scale", -1]
    , ["_center", [0.5, 0.75]]
    , ["_heading", direction (_this # 0)]
    , ["_heliPos", getPosASL (_this # 0)]
    ];

private _displaySide = ["left", "right"] select _displayIdx;
private _display = uiNamespace getVariable "fza_mpd_display" get _displaySide;

private _ctrlPoints = _display getVariable "fza_points";

if (_scale == -1) then {
    (_heli getVariable "fza_mpd_mpdState") # _displayIdx params ["","","","_state", "_persistState", ""];
    _scale = (0.125 * 5 / (_persistState get "tsdScale"));
};

//Set all current state to be not updated. This lets us know which ones can be removed
{_y set ["updated", false]} forEach _ctrlPoints;

//Draw each UI element
{
    if !(_forEachIndex in _ctrlPoints) then {_ctrlPoints set [_forEachIndex, createHashMap]};
    [_heli, _display, _x, _ctrlPoints get _forEachIndex, _scale, _center, _heading, _heliPos] call fza_mpd_fnc_uiDrawPoint;

    (_ctrlPoints get _forEachIndex) set ["updated", true];
} forEach _dmsPoints;

// Any un-updated (stale and no longer in the DMS) points should be removed from the ctrl
{
    if (_y get "updated") then {continue;};
    
    {if (typeName _y == "CONTROL") then {ctrlDelete _y;};} forEach _y;
} forEach _ctrlPoints;
displayUpdate _display;