/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrRfiJson

Description:
    The RFI threat symbols round the FCR format for scope.js, in display units. GTM: along the wide sector's
    outline, the arc at the true bearing from the centerline, down each edge from 45 deg at its corner through 90 deg
    at the RFI tic to 180 deg at the ownship. ATM: outside the 8 km ring, at the bearing from the nose.

Parameters:
    _heli - the helicopter
    _mode - 1 GTM, 2 ATM
    _seat - "plt" or "cpg", whose selected emitter is shown

Returns:
    [JSON array, [[x, y, emitter index], ...]]

Examples:
    [_heli, 1, "plt"] call fza_mpd_fnc_fcrRfiJson

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
// GTM geometry (pages\fcr\gtm.hpp): ownship, 8 km radius, the RFI tic's share of the edge, symbols' distance out
#define GTM_CX  0.5
#define GTM_CY  0.87
#define GTM_R   0.65
#define GTM_TIC 0.6495
#define GTM_OUT_ARC  0.045
#define GTM_OUT_EDGE 0.035
#define ATM_R   0.37
params ["_heli", "_mode", "_seat"];

private _emitters = _heli getVariable ["fza_ah64_ase_rfiEmitters", []];
if (_emitters isEqualTo []) exitWith {["[]", []]};

private _ref = getDir _heli + ([_heli getVariable ["fza_ah64_fcrAzBias", 0], 0] select (_mode == 2));
// Further out as tuned (fza_mpd_fnc_threatSymbolTune)
private _out = (fza_mpd_threatTune getOrDefault ["fcr", MPD_THREAT_TUNE_FCR]) # 3;
private _selected = _heli getVariable ["fza_ah64_ase_rfiSel_" + _seat, objNull];
private _blink = [] call fza_mpd_fnc_iconBlink;
// Emitters the FCR has merged with a target are shown as that target instead (fza_fcr_fnc_update)
private _merged = _heli getVariable ["fza_ah64_fcrRfiMerged", []];

private _parts = [];
private _picks = [];
{
    private _obj = _x # ASE_RFI_OBJ;
    if (!isNull _obj && {_obj in _merged}) then {continue;};
    private _bearing = [_heli, _x] call fza_ase_fnc_rfiBearing;
    if (_bearing isEqualTo []) then {continue;};
    private _rel = [(_bearing # 0) - _ref] call CBA_fnc_simplifyAngle180;

    private _pos = if (_mode == 2) then {
        [0.5 + (ATM_R + _out) * sin _rel, 0.5 - (ATM_R + _out) * cos _rel]
    } else {
        private _abs = abs _rel;
        if (_abs <= 45) then {
            [GTM_CX + (GTM_R + GTM_OUT_ARC + _out) * sin _rel, GTM_CY - (GTM_R + GTM_OUT_ARC + _out) * cos _rel]
        } else {
            private _side  = [1, -1] select (_rel < 0);
            private _share = [linearConversion [90, 180, _abs, GTM_TIC, 0, true], linearConversion [45, 90, _abs, 1, GTM_TIC, true]] select (_abs <= 90);
            [GTM_CX + _side * (GTM_R * _share + GTM_OUT_EDGE + _out) * sin 45, GTM_CY - GTM_R * _share * cos 45 + (GTM_OUT_EDGE + _out) * sin 45]
        };
    };
    _pos params ["_px", "_py"];
    // Kept on the page, overlapping the outline near its corners
    _px = 0.07 max _px min 0.93;
    _py = 0.17 max _py min 0.93;

    ([_x, _forEachIndex == 0, !isNull _selected && {_obj isEqualTo _selected}, _blink] call fza_mpd_fnc_rfiSymbol)
        params ["_chars", "_glyph", "_frame", "_colorKey"];
    _parts pushBack format ['{"x":%1,"y":%2,"l":%3,"r":%4,"g":"%5","fm":"%6","c":"%7"}',
        _px toFixed 4, _py toFixed 4, str (_chars # 0), str (_chars # 1), _glyph, _frame, _colorKey];
    _picks pushBack [_px, _py, _forEachIndex];
} forEach _emitters;

["[" + (_parts joinString ",") + "]", _picks]
