params ["_display"];

uiNamespace setVariable ["fza_docs_display", displayNull];
if (uiNamespace getVariable ["fza_docs_hidHatchet", false]) then {
    uiNamespace setVariable ["BIS_fnc_camera_display", nil];
    uiNamespace setVariable ["fza_docs_hidHatchet", nil];
};
