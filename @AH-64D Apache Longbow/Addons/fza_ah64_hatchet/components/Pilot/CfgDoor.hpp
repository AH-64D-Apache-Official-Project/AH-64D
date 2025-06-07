class PilotDoor {
    positionType = "anim";
    position = "ctrlref_p_doorhandle";
    label = "Pilot Door Handle";
    animation = "Pdoor";
    animStates[] = {1,0};
    animLabels[] = {"OPEN", "CLOSE"};
    radius = 0.1;
    animspeed = 1;
    animend = "if (_this#3 == 0) then {playsound ""fza_ah64_rh_doorclose1"";};";
    animStart = "if (_this#3 == 1) then {playsound ""fza_ah64_rh_dooropen1"";};";
};