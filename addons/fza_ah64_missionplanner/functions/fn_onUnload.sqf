// The planner's map data cleared, and Hatchet's interaction and cursor back if the planner stopped them (fza_mplanner_fnc_onLoad)
uiNamespace setVariable ["fza_mplanner_display", displayNull];
{uiNamespace setVariable [_x, nil]} forEach ["fza_mplanner_dtcDraw", "fza_mplanner_dtcDraft", "fza_mplanner_dtcPoints", "fza_mplanner_dtcRoute"];
if (uiNamespace getVariable ["fza_mplanner_hidHatchet", false]) then {
    uiNamespace setVariable ["BIS_fnc_camera_display", nil];
    uiNamespace setVariable ["fza_mplanner_hidHatchet", nil];
};
