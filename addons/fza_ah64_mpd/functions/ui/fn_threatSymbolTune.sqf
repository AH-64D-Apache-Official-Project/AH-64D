/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_threatSymbolTune

Description:
    Sets how the RLWR and RFI threat symbols are drawn on one format, live, to tune them. The defaults are
    MPD_THREAT_TUNE_ASE, _TSD and _FCR in mfdConstants.h.

Parameters:
    _format - "ase", "tsd" or "fcr"
    _values - (optional) [size, text height, characters in, RFI place], any left out or nil keep their value now:
              size and text height are multipliers; characters in moves the characters at the symbol's edges in, as a
              share of the symbol; RFI place is the ASE ring radius, the TSD square's distance from the page edge, or
              the FCR's extra distance out from the scan sector. [] puts back the defaults.

Returns:
    The format's values now

Examples:
    ["ase", [1.1, 0.9, 0.03, 0.355]] call fza_mpd_fnc_threatSymbolTune
    ["tsd", [nil, nil, 0.1]] call fza_mpd_fnc_threatSymbolTune
    ["fcr", []] call fza_mpd_fnc_threatSymbolTune

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params [["_format", "", [""]], ["_values", [], [[]]]];

_format = toLower _format;
private _defaults = createHashMapFromArray [["ase", MPD_THREAT_TUNE_ASE], ["tsd", MPD_THREAT_TUNE_TSD], ["fcr", MPD_THREAT_TUNE_FCR]];
if !(_format in _defaults) exitWith {
    systemChat "fza_mpd_fnc_threatSymbolTune: the format is ""ase"", ""tsd"" or ""fcr""";
    []
};

private _now = +(fza_mpd_threatTune getOrDefault [_format, _defaults get _format]);
{
    if (!isNil "_x" && {_x isEqualType 0} && {finite _x}) then {_now set [_forEachIndex, _x];};
} forEach (_values select [0, 4]);
if (_values isEqualTo []) then {fza_mpd_threatTune deleteAt _format} else {fza_mpd_threatTune set [_format, _now]};
// The TSD rebuilds its icon definitions (fza_mpd_fnc_tsdHtmlDraw)
fza_mpd_threatTuneVersion = (missionNamespace getVariable ["fza_mpd_threatTuneVersion", 0]) + 1;
_now
