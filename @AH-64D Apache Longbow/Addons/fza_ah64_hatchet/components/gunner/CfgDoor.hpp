class PilotDoor {
    positionType = "anim";
    position = "ctrlref_g_doorhandle";
    label = "$STR_FZA_AH64_DOOR_OPEN_CLOSE";
    animation = "Gdoor";
    animStates[] = {1,0};
    animLabels[] = {"$STR_FZA_AH64_DOOR_OPEN", "$STR_FZA_AH64_DOOR_CLOSE"};
    radius = 0.1;
    animspeed = 1;
    animend = "if (_this#3 == 0) then {playsound ""fza_ah64_rh_doorclose1"";};";
    animStart = "if (_this#3 == 1) then {playsound ""fza_ah64_rh_dooropen1"";};";
};