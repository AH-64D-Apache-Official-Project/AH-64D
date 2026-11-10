params ["_display"];

uiNamespace setVariable ["fza_setup_display", displayNull];
if (uiNamespace getVariable ["fza_setup_hidHatchet", false]) then {
    uiNamespace setVariable ["BIS_fnc_camera_display", nil];
    uiNamespace setVariable ["fza_setup_hidHatchet", nil];
};

// Closed by the player rather than for another menu, it starts from the beginning next time
if !(uiNamespace getVariable ["fza_setup_reopen", false]) then {
    uiNamespace setVariable ["fza_setup_resume", nil];
};
if (uiNamespace getVariable ["fza_setup_dirty", false]) then {
    uiNamespace setVariable ["fza_setup_dirty", nil];
    saveProfileNamespace;
};
