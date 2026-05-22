params [];

private _existingDisplay = uiNamespace getVariable ["fza_mplanner_display", displayNull];
if (!isNull _existingDisplay) then {
    _existingDisplay closeDisplay 0;
} else {
    createDialog "RscFzaMissionPlanner";
};
