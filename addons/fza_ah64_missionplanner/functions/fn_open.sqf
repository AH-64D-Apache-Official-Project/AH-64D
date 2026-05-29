params [["_heli", objNull, [objNull]]];

if (isNull _heli || {!(_heli isKindOf "Helicopter")}) then {
    _heli = vehicle player;
    if (isNull _heli || {!(_heli isKindOf "Helicopter")}) then { _heli = objNull };
};

private _existingDisplay = uiNamespace getVariable ["fza_mplanner_display", displayNull];
if (!isNull _existingDisplay) then {
    _existingDisplay closeDisplay 0;
} else {
    uiNamespace setVariable ["fza_mplanner_target", _heli];
    createDialog "RscFzaMissionPlanner";
};
