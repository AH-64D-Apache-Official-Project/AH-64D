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

// The HTML pages that load ahead of being shown (fza_mpd_fnc_htmlPreload), until both MPDs have them
if !(_heli getVariable ["fza_mpd_htmlPreloaded", false]) then {
    _heli setVariable ["fza_mpd_htmlPreloaded", [_heli] call fza_mpd_fnc_htmlPreload];
};

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

// BRT and DAY/NIGHT/MONO, once a frame before the pages draw: per MPD [light let through, MONO] from the local crew
// station's knobs (fza_mpd_fnc_viewSettings); the video underlay reads it (fza_mpd_fnc_videoApply)
private _looks = [0, 1] apply {
    ([_heli, _x] call fza_mpd_fnc_viewSettings) params ["_level", "_mono"];
    [_level ^ MPD_LEVEL_GAMMA, _mono]
};
_heli setVariable ["fza_mpd_looks", _looks];

(_heli getVariable "fza_mpd_mpdState") # 0 params ["_lpage", "", "_ldrawFunc", "", "_lState", "_lPersistState"];
(_heli getVariable "fza_mpd_mpdState") # 1 params ["_rpage", "", "_rdrawFunc", "", "_rState", "_rPersistState"];

[_heli,0,_lState, _lPersistState get _lpage] call _ldrawFunc;
[_heli,1,_rState, _rPersistState get _rpage] call _rdrawFunc;

// The VIDEO page's underlay under a native page. A ui() display is not redrawn by itself: with the video shown, or just
// hidden, the display is redrawn so its video moves or clears (an HTML page's display is redrawn by fza_fcr_fnc_displayUiInit).
// The MPD's text boxes (its mask pass) are drawn only while there is video or map content under the page to hide.
// The weapon pylon pictures take the look of the MPD showing the WPN page, the right one's if both do.
private _pylon = [0, 0];
{
    ((_heli getVariable "fza_mpd_mpdState") # _forEachIndex) params ["_page", "", "", "", "", "", "", "_usesIcons", "_htmlUrl"];
    // The native colours scale by the light let through (mpd_defines.hpp); the displays' own controls and pages read the
    // look from the display
    (_looks # _forEachIndex) params ["_light", "_mono"];
    _heli setUserMFDValue [[MFD_IND_DIM_L, MFD_IND_DIM_R] select _forEachIndex, 1 - _light];
    _heli setUserMFDValue [[MFD_IND_MONO_L, MFD_IND_MONO_R] select _forEachIndex, BOOLTONUM _mono];
    if (_page == "wpn") then {_pylon = [1 - _light, BOOLTONUM _mono]};
    private _native = (uiNamespace getVariable ["fza_mpd_display", createHashMap]) getOrDefault [_x, displayNull];
    private _lookChanged = false;
    if (!isNull _native) then {
        _lookChanged = (_native getVariable ["fza_mpd_look", []]) isNotEqualTo [_light, _mono];
        _native setVariable ["fza_mpd_look", [_light, _mono]];
    };

    private _video = false;
    if (_htmlUrl == "") then {
        private _display = _native;
        if (isNull _display) exitWith {};
        private _wasShown = ctrlShown (_display displayCtrl 380);
        _video = [_heli, _forEachIndex, _display, _page != "off"] call fza_mpd_fnc_videoApply;
        if (_video || _wasShown || _lookChanged) then {displayUpdate _display};
    } else {
        // An HTML page with an underlay applies it when drawn
        private _ctrl = [_heli, _forEachIndex] call fza_mpd_fnc_htmlCtrl;
        _video = !isNull _ctrl && {ctrlShown ((ctrlParent _ctrl) displayCtrl 380)};
        if (!isNull _ctrl) then {
            (ctrlParent _ctrl) setVariable ["fza_mpd_look", [_light, _mono]];
            [_ctrl, _light, _mono] call fza_mpd_fnc_viewHtmlLook;
        };
    };
    _heli setUserMFDValue [[MFD_IND_MASK_L, MFD_IND_MASK_R] select _forEachIndex, BOOLTONUM (_video || _usesIcons == 1)];
} forEach ["left", "right"];
_heli setUserMFDValue [MFD_IND_PYLON_DIM, _pylon # 0];
_heli setUserMFDValue [MFD_IND_PYLON_MONO, _pylon # 1];

[_heli] call fza_mpd_fnc_cursorUpdate;
