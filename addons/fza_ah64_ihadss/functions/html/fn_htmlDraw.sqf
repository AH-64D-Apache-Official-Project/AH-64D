/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_htmlDraw

Description:
    Shows and updates the HTML IHADSS. The page holds the symbols fixed to the
    format; the virtual symbols are native controls on a layer above it, so
    head movement and zoom never wait on the browser.

    Heads up the format covers 40x30 deg at the seat's default FOV and keeps
    that size while zoomed. Heads down it fills the TADS view.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_htmlDraw
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_ihadss\headers\hdu.h"
disableSerialization;
params ["_heli"];

private _iconLayer   = "fza_ah64_ihadssIcons" call BIS_fnc_rscLayer;
private _iconDisplay = uiNamespace getVariable ["fza_ah64_ihadssIcons", displayNull];
private _crew        = player == driver _heli || player == gunner _heli;
private _isPilot     = player == driver _heli;
private _headsDown   = cameraView == "GUNNER" && !_isPilot;

// One browser per format size, each created at that size and never resized: after a resize CEF at times showed the
// page enlarged and cropped. The pilot has only the heads up page; the CPG keeps both loaded and uses the one in view.
// A browser's config position reads its rect variable; a new size (resolution, FOV) reopens its layer.
private _ctrl = controlNull;
private _rect = [];
{
    _x params ["_name", "_rectVar", "_down"];
    private _layer   = _name call BIS_fnc_rscLayer;
    private _display = uiNamespace getVariable [_name, displayNull];
    if (!_crew || {_down && _isPilot}) then {
        if (!isNull _display) then {_layer cutText ["", "PLAIN"]};
        continue;
    };
    private _pageRect = [_heli, _down] call fza_ihadss_fnc_formatRect;
    _pageRect params ["_rectX", "_rectY", "_rectW", "_rectH"];
    private _marginX = IHADSS_PAGE_MARGIN / 640 * _rectW;
    private _marginY = IHADSS_PAGE_MARGIN / 480 * _rectH;
    private _browserRect = [_rectX - _marginX, _rectY - _marginY, _rectW + 2 * _marginX, _rectH + 2 * _marginY];
    if (isNull _display || {(_display getVariable ["fza_ihadss_browserRect", []]) isNotEqualTo _browserRect}) then {
        if (!isNull _display) then {_layer cutText ["", "PLAIN"]};
        uiNamespace setVariable [_rectVar, _browserRect];
        _layer cutRsc [_name, "PLAIN", 0, false];
        continue;
    };
    private _pageCtrl = _display displayCtrl 960;
    if (_down isEqualTo _headsDown) then {
        _ctrl = _pageCtrl;
        _rect = _pageRect;
    } else {
        // The page not in view stays loaded but blank
        if (_pageCtrl getVariable ["fza_ihadss_shown", false]) then {
            _pageCtrl setVariable ["fza_ihadss_shown", false];
            _pageCtrl setVariable ["fza_ihadss_last", ["", -10]];
            [_pageCtrl, "if(window.fzaIhadss){fzaIhadss.clear()}"] call fza_ihadss_fnc_htmlExecJs;
        };
    };
} forEach [["fza_ah64_ihadssHtml", "fza_ihadss_browserRect", false], ["fza_ah64_ihadssHtmlDown", "fza_ihadss_browserRectDown", true]];

if !_crew exitWith {
    if (!isNull _iconDisplay) then {_iconLayer cutText ["", "PLAIN"]};
};
// The page in view is opening this frame
if (isNull _ctrl) exitWith {};

private _powerOn   = (_heli getVariable ["bmkhs_acBusOn", false]) && (_heli getVariable ["bmkhs_dcBusOn", false]);
private _show      = _powerOn && (_headsDown || (cameraView == "INTERNAL" && !(_heli getVariable ["fza_ah64_monocleinbox", true])));

// The page stays loaded while hidden, reloading it on every monocle toggle would blank it for a moment
if !_show exitWith {
    if (!isNull _iconDisplay) then {_iconLayer cutText ["", "PLAIN"]};
    if (_ctrl getVariable ["fza_ihadss_shown", false]) then {
        _ctrl setVariable ["fza_ihadss_shown", false];
        _ctrl setVariable ["fza_ihadss_last", ["", -10]];
        [_ctrl, "if(window.fzaIhadss){fzaIhadss.clear()}"] call fza_ihadss_fnc_htmlExecJs;
    };
};
_ctrl setVariable ["fza_ihadss_shown", true];

if (isNull _iconDisplay) then {
    _iconLayer cutRsc ["fza_ah64_ihadssIcons", "PLAIN", 0, false];
    _iconDisplay = uiNamespace getVariable ["fza_ah64_ihadssIcons", displayNull];
};

private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (isNil "_sight") then {_sight = SIGHT_HMD};
// The CPG gets the weapon format on the TADS, or on the HMD with TADS/FCR selected and NVS off; flight symbology whenever
// the CPG's NVS MODE is NORM or FIXED, and with the FCR in TPM, a pilotage mode
private _tpm          = (_heli getVariable ["fza_ah64_fcrMode", 0]) == FCR_DISP_MODE_TPM;
private _weaponFormat = !_isPilot && {_headsDown || {(_sight == SIGHT_TADS || {_sight == SIGHT_FCR && !_tpm}) && {(([_heli] call fza_ihadss_fnc_nvsState) # 0) == NVS_MODE_OFF}}};
private _tadsVideo    = !_headsDown && {missionNamespace getVariable ["fza_ihadss_tadsVideo", false]};

if (!isNull _iconDisplay) then {
    [_heli, _iconDisplay, _rect, _headsDown, _weaponFormat, _tadsVideo] call fza_ihadss_fnc_htmlIcons;
};

private _json = [_heli, _headsDown, _weaponFormat, _tadsVideo] call fza_ihadss_fnc_htmlModel;

// Identical frames are skipped, apart from a once-a-second resend in case a push was dropped while the page loaded
(_ctrl getVariable ["fza_ihadss_last", ["", -10]]) params ["_lastJson", "_lastTick"];
if (_json isNotEqualTo _lastJson || {diag_tickTime - _lastTick > 1}) then {
    _ctrl setVariable ["fza_ihadss_last", [_json, diag_tickTime]];
    [_ctrl, "if(window.fzaIhadss){fzaIhadss.update(" + _json + ")}"] call fza_ihadss_fnc_htmlExecJs;
};
