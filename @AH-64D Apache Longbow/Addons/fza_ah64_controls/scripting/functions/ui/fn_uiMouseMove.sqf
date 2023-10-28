/* ----------------------------------------------------------------------------
Function: fza_fnc_uiMouseMove
Description:
    Handles repetitive ASE targeting information management. Should be run regularly.
Parameters:
    (onMouseMoving display event handler schema)
    _display - Unused
    _mousex - the delta in x of movement
    _mousey - the delta in y of movement
Returns:
    Nothing
Examples:
    --- Code
    [_heli] call fza_fnc_uiMouseMove
    ---
Author:
    Unknown
---------------------------------------------------------------------------- */
params ["", "_mousex", "_mousey"];

private _heli              = vehicle player;
private _freeCursorEnabled = _heli getVariable "fza_ah64_freeCursorEnabled";
private _horizontalPos     = _heli getVariable "fza_ah64_freeCursorHpos";
private _verticalpos       = _heli getVariable "fza_ah64_freeCursorVpos";

if (_heli iskindof "fza_ah64base" && _freeCursorEnabled && !(freelook && fza_ah64_freeCursorfreelooklock)) then {
    _horizontalPos = [_horizontalPos + _mousex * fza_ah64_freeCursorSensitivity, safezoneXabs, (safezoneXabs + safezonew)] call BIS_fnc_clamp;
    _verticalpos = [_verticalpos + _mousey * fza_ah64_freeCursorSensitivity, safezoneY, (safezoneY + safezoneH)] call BIS_fnc_clamp;
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601) ctrlSetPosition[_horizontalPos - 0.005, _verticalpos - 0.009];
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 602) ctrlSetPosition[_horizontalPos - 0.25, _verticalpos + 0.02];
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601) ctrlCommit 0.01;
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 602) ctrlCommit 0.01;
    _heli setVariable ["fza_ah64_freeCursorHpos", _horizontalPos];
    _heli setVariable ["fza_ah64_freeCursorVpos", _verticalpos];
};