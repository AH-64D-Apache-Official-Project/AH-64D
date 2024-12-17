class rotorBrakeToggle {
    positionType="anim";
    position="ctrlref_p_rtrbrake";
    label="Rotor Brake";
    animation="plt_rtrbrake";
    animStates[] = {0, 1};
    animLabels[] = {"OFF", "LOCK"};
    radius=0.02;
    buttonDown="systemchat str _this#0#0; [_this#0, ""fza_ah64_rtrbrake"", _this#1] call fza_fnc_animSetValue;";
    buttonHold="systemchat str _this#0#0; [_this#0, ""fza_ah64_rtrbrake"", _this#1] call fza_fnc_animSetValue;";
    buttonUp="systemchat str _this#0#0; [_this#0, ""fza_ah64_rtrbrake"", _this#1] call fza_fnc_animSetValue;";
    dragStart="systemchat str _this#0#0; [_this#0, ""fza_ah64_rtrbrake"", _this#1] call fza_fnc_animSetValue;";
    dragging="systemchat str _this#0#0; [_this#0, ""fza_ah64_rtrbrake"", _this#1] call fza_fnc_animSetValue;";
    dragStop="systemchat str _this#0#0; [_this#0, ""fza_ah64_rtrbrake"", _this#1] call fza_fnc_animSetValue;";
};

