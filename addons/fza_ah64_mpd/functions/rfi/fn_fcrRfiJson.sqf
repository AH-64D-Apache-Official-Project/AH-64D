/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrRfiJson

Description:
    The RFI threat symbols round the FCR format for scope.js, as the points the MPD pages' shared point layer draws
    (ui\shared\mpd_points.js), their idents defined on the browser control (fza_mpd_fnc_htmlDefsJson). GTM: along the
    wide sector's outline, the arc at the true bearing from the centerline, down each edge from 45 deg at its corner
    through 90 deg at the RFI tic to 180 deg at the ownship. ATM: outside the 8 km ring, at the bearing from the nose.
    Symbols too close together are spread apart, in bearing order.

Parameters:
    _heli - the helicopter
    _mode - 1 GTM, 2 ATM
    _seat - "plt" or "cpg", whose selected emitter is shown
    _ctrl - the FCR page's browser control

Returns:
    [JSON array of points (fza_mpd_fnc_htmlPoints), [[x, y, emitter index], ...]]

Examples:
    [_heli, 1, "plt", _ctrl] call fza_mpd_fnc_fcrRfiJson

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
// Least distance between two symbols' centres, as on the ASE page
#define FCR_RFI_GAP MPD_ASE_ICON_GAP
params ["_heli", "_mode", "_seat", "_ctrl"];

private _emitters = _heli getVariable ["fza_ah64_ase_rfiEmitters", []];
if (_emitters isEqualTo []) exitWith {["[]", []]};

private _ref = getDir _heli + ([_heli getVariable ["fza_ah64_fcrAzBias", 0], 0] select (_mode == 2));
// Further out as tuned (fza_mpd_fnc_threatSymbolTune)
private _out = (fza_mpd_threatTune getOrDefault ["fcr", MPD_THREAT_TUNE_FCR]) # 3;
private _selected = _heli getVariable ["fza_ah64_ase_rfiSel_" + _seat, objNull];
private _blink = [] call fza_mpd_fnc_iconBlink;
// Emitters the FCR has merged with a target are shown as that target instead (fza_fcr_fnc_update)
private _merged = _heli getVariable ["fza_ah64_fcrRfiMerged", []];

// [bearing from the reference -180 to 180, emitter index]
private _items = [];
{
    private _obj = _x # ASE_RFI_OBJ;
    if (!isNull _obj && {_obj in _merged}) then {continue;};
    private _bearing = [_heli, _x] call fza_ase_fnc_rfiBearing;
    if (_bearing isEqualTo []) then {continue;};
    _items pushBack [[(_bearing # 0) - _ref] call CBA_fnc_simplifyAngle180, _forEachIndex];
} forEach _emitters;

// Symbols too close together are spread apart in bearing order, by distance round the ring or along the GTM outline:
// the arc either side of the centerline, then each edge down to the ownship, where the two sides meet. A distance
// along it is taken as an angle so it spreads as a ring does.
private _positions = [];
if (_mode == 2) then {
    private _radius = ATM_R + _out;
    private _drawn = [_items apply {_x # 0}, deg (FCR_RFI_GAP / _radius)] call fza_mpd_fnc_spreadBearings;
    _positions = _drawn apply {[0.5 + _radius * sin _x, 0.5 - _radius * cos _x]};
} else {
    private _arcR    = GTM_R + GTM_OUT_ARC + _out;
    private _arcLen  = _arcR * pi / 4;
    private _halfLen = _arcLen + GTM_R;
    private _angleOf = _items apply {
        private _rel = _x # 0;
        private _abs = abs _rel;
        private _len = if (_abs <= 45) then {_arcR * rad _abs} else {
            private _share = [linearConversion [90, 180, _abs, GTM_TIC, 0, true], linearConversion [45, 90, _abs, 1, GTM_TIC, true]] select (_abs <= 90);
            _arcLen + GTM_R * (1 - _share)
        };
        ([1, -1] select (_rel < 0)) * _len / _halfLen * 180
    };
    private _drawn = [_angleOf, FCR_RFI_GAP / _halfLen * 180] call fza_mpd_fnc_spreadBearings;
    _positions = _drawn apply {
        private _len  = abs _x / 180 * _halfLen;
        private _side = [1, -1] select (_x < 0);
        if (_len <= _arcLen) then {
            private _a = _side * deg (_len / _arcR);
            [GTM_CX + _arcR * sin _a, GTM_CY - _arcR * cos _a]
        } else {
            private _share = 0 max (1 - (_len - _arcLen) / GTM_R) min 1;
            [GTM_CX + _side * (GTM_R * _share + GTM_OUT_EDGE + _out) * sin 45, GTM_CY - GTM_R * _share * cos 45 + (GTM_OUT_EDGE + _out) * sin 45]
        };
    };
};

private _points = [];
private _picks  = [];
{
    _x params ["", "_index"];
    (_positions # _forEachIndex) params ["_px", "_py"];
    // Kept on the page, overlapping the outline near its corners
    _px = 0.07 max _px min 0.93;
    _py = 0.17 max _py min 0.93;

    private _record = _emitters # _index;
    private _obj = _record # ASE_RFI_OBJ;
    _points append ([_record, _index, !isNull _selected && {_obj isEqualTo _selected}, _blink, [_px, _py]] call fza_mpd_fnc_rfiSymbolPoints);
    _picks pushBack [_px, _py, _index];
} forEach _items;

// Drawn as the TSD and ASE page draw them, with the TSD's symbol size, text height and characters in
[toJSON ([_ctrl, _points, fza_mpd_threatTune getOrDefault ["tsd", MPD_THREAT_TUNE_TSD]] call fza_mpd_fnc_htmlPoints), _picks]
