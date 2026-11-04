/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrCursorHover

Description:
    The FCR target symbol the MPD cursor is on, on this MPD, if the cursor can
    choose it: with FCR as the crew station's sight, to store it while TGT is
    selected, else as the NTS, owning the FCR. The symbol is drawn over a black
    circle in the cursor's centre (scope.js, rmap.js), and the cursor leaves out
    its ring (MFD_IND_FCR_CURSOR_TARGET).

Parameters:
    _heli          - The helicopter
    _mpdIndex      - 0 left MPD, 1 right
    _state         - The FCR page's state
    _cursorTargets - The symbols as fza_mpd_fnc_fcrGTMDraw stores them: [x, y, target, position, symbol index]

Returns:
    The symbol's index in the page's target list, -1 for none

Examples:
    --- Code
    private _hover = [_heli, _mpdIndex, _state, _cursorTargets] call fza_mpd_fnc_fcrCursorHover;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\cursor.h"
params ["_heli", "_mpdIndex", "_state", "_cursorTargets"];

private _hover = -1;
private _cursor = _heli getVariable ["fza_mpd_cursor", []];
if (_cursor param [0, -1] == _mpdIndex
    && {_cursor param [6, 0] == 0}
    && {[_heli, _mpdIndex, _cursor # 1, _cursor # 2] call fza_mpd_fnc_cursorInArea}
    && {_state getOrDefault ["zoom", 0] != 1}
    && {_state getOrDefault ["tgt", 0] == 1 || {FCR_OWNER(_heli) == ([_heli] call fza_fnc_getSeat)}}
    && {([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) == SIGHT_FCR}) then {
    _cursor params ["", "_posX", "_posY"];
    private _bestDistance = MPD_CURSOR_TARGET_REACH ^ 2;
    {
        private _distance = [_x # 0, _x # 1] distanceSqr [_posX, _posY];
        if (_distance < _bestDistance) then {
            _bestDistance = _distance;
            _hover = _x # 4;
        };
    } forEach _cursorTargets;
};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CURSOR_TARGET), BOOLTONUM(_hover >= 0)];
_hover
