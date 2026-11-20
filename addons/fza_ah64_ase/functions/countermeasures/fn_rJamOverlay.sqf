/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamOverlay

Description:
    On a player's machine, while the vehicle they're viewing (in it, remote controlling it,
    or through a UAV terminal) is jammed by the radar jammer: the vanilla SENS panel is
    tinted red with JAMMED across it. The panel's own colours are put back afterwards. Sent
    when a jam starts; the vehicle is only for the debug log.

Parameters:
    _vehicle: Object - The jammed vehicle

Returns:
    Nothing

Examples:
    [_emitter] remoteExec ["fza_ase_fnc_rJamOverlay", _viewers]

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_vehicle", objNull]];

if (missionNamespace getVariable ["fza_ase_rJamDebug", false]) then {
    diag_log format ["fza_ase_rJam overlay: %1, camera on %2, panel %3", typeOf _vehicle, typeOf vehicle cameraOn, uiNamespace getVariable ["RscCustomInfoSensors", displayNull]];
};
if (!hasInterface || {!isNil "fza_ase_rJamOverlayHandle"}) exitWith {};

fza_ase_rJamOverlayHandle = [{
    params ["", "_handle"];

    private _decorated = uiNamespace getVariable ["fza_ase_rJamOverlayDisplay", displayNull];
    private _jammed    = [vehicle player, vehicle cameraOn, getConnectedUAV player] findIf {
        CBA_missionTime < (_x getVariable ["fza_ah64_rJamUntil", -1])
    } >= 0;

    if (!_jammed) exitWith {
        if (!isNull _decorated) then {
            private _bcg = [
                profileNamespace getVariable ["IGUI_BCG_RGB_R", 0],
                profileNamespace getVariable ["IGUI_BCG_RGB_G", 1],
                profileNamespace getVariable ["IGUI_BCG_RGB_B", 1],
                profileNamespace getVariable ["IGUI_BCG_RGB_A", 0.8]
            ];
            (_decorated displayCtrl 15110) ctrlSetTextColor _bcg;
            (_decorated displayCtrl 15112) ctrlSetBackgroundColor _bcg;
            ctrlDelete (uiNamespace getVariable ["fza_ase_rJamOverlayText", controlNull]);
        };
        uiNamespace setVariable ["fza_ase_rJamOverlayDisplay", displayNull];
        fza_ase_rJamOverlayHandle = nil;
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    // The panel is made again each time it's opened
    private _display = uiNamespace getVariable ["RscCustomInfoSensors", displayNull];
    if (isNull _display || {_display isEqualTo _decorated}) exitWith {};

    (_display displayCtrl 15110) ctrlSetTextColor [0.7, 0, 0, 0.8];
    (_display displayCtrl 15112) ctrlSetBackgroundColor [0.7, 0, 0, 0.8];

    private _group = _display displayCtrl 15111;
    (ctrlPosition _group) params ["", "", "_width", "_height"];
    private _label  = localize "STR_FZA_AH64_RJAM_JAMMED";
    private _size   = (0.2 * _height) min (1.5 * _width / (count _label max 1));
    private _text   = _display ctrlCreate ["RscStructuredText", -1, _group];
    _text ctrlSetPosition [0, 0.5 * (_height - 1.25 * _size), _width, 1.25 * _size];
    _text ctrlSetFontHeight _size;
    _text ctrlSetStructuredText parseText format ["<t align='center' color='#ff0000' font='PuristaBold'>%1</t>", _label];
    _text ctrlCommit 0;

    uiNamespace setVariable ["fza_ase_rJamOverlayDisplay", _display];
    uiNamespace setVariable ["fza_ase_rJamOverlayText", _text];
}, 0, []] call CBA_fnc_addPerFrameHandler;
