params [["_heli", objNull, [objNull]]];

if (isNull _heli || {!(_heli isKindOf "Helicopter")}) then {
    _heli = vehicle player;
    if (isNull _heli || {!(_heli isKindOf "Helicopter")}) then { _heli = objNull };
};

// Must be on the ground and stationary
if (!isNull _heli) then {
    if ((getPosATL _heli select 2 > 3) || {vectorMagnitude (velocity _heli) > 1.5}) exitWith {
        hint "Mission Planner: Aircraft must be on the ground and stationary.";
    };

    private _existingDisplay = uiNamespace getVariable ["fza_mplanner_display", displayNull];
    if (!isNull _existingDisplay) then {
        _existingDisplay closeDisplay 0;
    } else {
        uiNamespace setVariable ["fza_mplanner_target", _heli];
        createDialog "RscFzaMissionPlanner";
    };
};
