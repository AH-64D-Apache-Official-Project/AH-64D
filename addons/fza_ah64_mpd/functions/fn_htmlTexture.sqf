/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_htmlTexture

Description:
    The procedural texture of an HTML page's display on an MPD, and the display's
    unique id. The engine shares one display per texture text, so a page shown
    on the MPD and a page loaded ahead of time (fza_mpd_fnc_htmlPreload) must use
    exactly this.

Parameters:
    _side      - 0 left MPD, 1 right MPD
    _htmlClass - The page's display class

Returns:
    [texture, unique id]

Examples:
    --- Code
    ([0, "RscFzaMPDTsd"] call fza_mpd_fnc_htmlTexture) params ["_texture", "_uniqueId"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_side", "_htmlClass"];

private _uniqueId = (["left", "right"] select _side) + "Game_" + _htmlClass;
["#(rgb,1024,1024,1)ui(" + _htmlClass + "," + _uniqueId + ")", _uniqueId]
