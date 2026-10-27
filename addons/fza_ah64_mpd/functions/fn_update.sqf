/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_update

Description:
    Updates the MPDs inside the apache to show the correct visuals. Should be run regularly.

Parameters:
    _heli - the apache to show the correct values for.

Returns:
    Nothing.

Examples:
    --- Code
    [_heli] call fza_mpd_fnc_update
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _acBusOn = _heli getVariable "bmkhs_acBusOn";

// The screen's aspect for the sensor video (fza_ihadss_fnc_r2tTexture), measured here as the MPD displays cannot
fza_ihadss_screenAspect = (safeZoneW / pixelW) / (safeZoneH / pixelH);
[_heli] call fza_ihadss_fnc_dtvCamera;

private _lmpdCurr = [_heli, 0] call fza_mpd_fnc_currentPage;
private _rmpdCurr = [_heli, 1] call fza_mpd_fnc_currentPage;

if (_acBusOn && _lmpdCurr == "off") then {
    [_heli, 0, "eng"] call fza_mpd_fnc_setCurrentPage;
};
if (!_acBusOn && _lmpdCurr != "off") then {
    [_heli, 0, "off"] call fza_mpd_fnc_setCurrentPage;
};

if (_acBusOn && _rmpdCurr == "off") then {
    [_heli, 1, "dtu"] call fza_mpd_fnc_setCurrentPage;
};
if (!_acBusOn && _rmpdCurr != "off") then {
    [_heli, 1, "off"] call fza_mpd_fnc_setCurrentPage;
};

(_heli getVariable "fza_mpd_mpdState") # 0 params ["_lpage", "", "_ldrawFunc", "", "_lState", "_lPersistState"];
(_heli getVariable "fza_mpd_mpdState") # 1 params ["_rpage", "", "_rdrawFunc", "", "_rState", "_rPersistState"];

[_heli,0,_lState, _lPersistState get _lpage] call _ldrawFunc;
[_heli,1,_rState, _rPersistState get _rpage] call _rdrawFunc;

// The VIDEO page's underlay under a native page. A ui() display is not redrawn by itself: with the video shown, or just
// hidden, the display is redrawn so its video moves or clears (an HTML page's display is redrawn by fza_fcr_fnc_displayUiInit).
// The MPD's text boxes (its mask pass) are drawn only while there is video or map content under the page to hide.
{
    ((_heli getVariable "fza_mpd_mpdState") # _forEachIndex) params ["_page", "", "", "", "", "", "", "_usesIcons", "_htmlUrl"];
    private _video = false;
    if (_htmlUrl == "") then {
        private _display = (uiNamespace getVariable ["fza_mpd_display", createHashMap]) getOrDefault [_x, displayNull];
        if (isNull _display) exitWith {};
        private _wasShown = ctrlShown (_display displayCtrl 380);
        _video = [_heli, _forEachIndex, _display, _page != "off"] call fza_mpd_fnc_videoApply;
        if (_video || _wasShown) then {displayUpdate _display};
    } else {
        // An HTML page with an underlay applies it when drawn
        private _ctrl = [_heli, _forEachIndex] call fza_mpd_fnc_htmlCtrl;
        _video = !isNull _ctrl && {ctrlShown ((ctrlParent _ctrl) displayCtrl 380)};
    };
    _heli setUserMFDValue [[MFD_IND_MASK_L, MFD_IND_MASK_R] select _forEachIndex, BOOLTONUM (_video || _usesIcons == 1)];
} forEach ["left", "right"];
