/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_tsdFrame

Description:
    Where the TSD map is drawn from: the place shown at the ownship position and
    the heading up the map. The aircraft's own while the map is live, the frozen
    ones while it is frozen (FRZ, CAQ or PAN).

Parameters:
    _heli - The helicopter
    _tsd  - The TSD's persistent state on that MPD

Returns:
    [position ASL, heading, frozen]

Examples:
    --- Code
    ([_heli, _persistState get "tsd"] call fza_mpd_fnc_tsdFrame) params ["_pos", "_heading", "_frozen"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_tsd"];

private _frozen = _tsd getOrDefault ["frozen", []];
if (_frozen isEqualTo []) exitWith {[getPosASL _heli, direction _heli, false]};
_frozen + [true]
