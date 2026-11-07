#include "\fza_ah64_dms\headers\constants.h"
// The active zones for scope.js, in MPD units: [{"c":0 PF or 1 NF,"p":[x1,y1,x2,y2,...]}]
params ["_heli", "_origin", "_heading", "_scale", "_ctr"];

([_heli] call fza_dms_fnc_zoneActive) params ["_pf", "_nf"];
if (_pf isEqualTo [] && {_nf isEqualTo []}) exitWith {"[]"};
private _poly = {
    params ["_pts", "_class"];
    private _xy = [];
    {
        ([_origin, _heading, _scale, _ctr, _x] call fza_mpd_fnc_tsdWorldToScreen) params ["_sx", "_sy"];
        _xy pushBack (_sx toFixed 4);
        _xy pushBack (_sy toFixed 4);
    } forEach _pts;
    format ['{"c":%1,"p":[%2]}', _class, _xy joinString ","]
};
private _out = [];
if (_pf isNotEqualTo []) then {_out pushBack ([_pf, 0] call _poly)};
{_out pushBack ([_x, 1] call _poly)} forEach _nf;
"[" + (_out joinString ",") + "]"
