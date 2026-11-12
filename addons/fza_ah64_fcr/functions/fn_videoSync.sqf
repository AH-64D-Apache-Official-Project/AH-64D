/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_videoSync

Description:
    What an HTML page drawing the RMAP or TPM picture is sent this frame: the
    columns sampled since it was last sent some (fza_fcr_fnc_rmapSample,
    fza_fcr_fnc_tpmSample), or the whole picture with a clear when it missed
    any, the picture was restarted, or the page has loaded since.

Parameters:
    _heli  - The helicopter
    _ctrl  - The page's browser control
    _storeVar - "fza_ah64_fcrRMAPStore" or "fza_ah64_fcrTPMStore"

Returns:
    The payload's JSON members, without braces: the picture's geometry,
    hardClear and any columns

Examples:
    --- Code
    private _members = [_heli, _ctrl, "fza_ah64_fcrRMAPStore"] call fza_fcr_fnc_videoSync
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_ctrl", "_storeVar"];

private _store = _heli getVariable [_storeVar, []];
if (_store isEqualTo []) exitWith {'"hardClear":false'};
_store params ["_key", "_seq", "_slots", "_delta", "_header", "_aziSteps", "_rmap"];

(_ctrl getVariable [_storeVar, [[], -1, -1]]) params ["_seenKey", "_seenSeq", "_seenTick"];
private _clear = true;
private _cols  = "";
if (_seenKey isEqualTo _key && {(_ctrl getVariable ["fza_mpd_htmlReadyAt", -1]) <= _seenTick}) then {
    if (_seenSeq == _seq) exitWith {_clear = false};
    if (_seenSeq == _seq - 1) exitWith {_clear = false; _cols = _delta};
};
if (_clear) then {
    private _parts = [];
    if (_rmap) then {
        {
            if (_x != "") then {
                _parts pushBack format ['{"i":%1,"near":%2,"d":"%3"}', _forEachIndex % _aziSteps, ["false", "true"] select (_forEachIndex < _aziSteps), _x];
            };
        } forEach _slots;
    } else {
        {
            if (_x != "") then {_parts pushBack format ['{"i":%1,"d":"%2"}', _forEachIndex, _x]};
        } forEach _slots;
    };
    if (_parts isNotEqualTo []) then {_cols = "[" + (_parts joinString ",") + "]"};
};
if (_clear || {_seenSeq != _seq}) then {
    _ctrl setVariable [_storeVar, [_key, _seq, diag_tickTime]];
};

_header + ',"hardClear":' + (["false", "true"] select _clear) + (["", ',"columns":' + _cols] select (_cols != ""))
