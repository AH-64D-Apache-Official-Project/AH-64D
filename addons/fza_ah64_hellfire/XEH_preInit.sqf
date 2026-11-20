fza_hellfire_blastAmmo = createHashMap;

["fza_hellfire_blast", {
    _this call fza_hellfire_fnc_blastDetonate;
}] call CBA_fnc_addEventHandler;

["fza_hellfire_blastApply", {
    _this call fza_hellfire_fnc_blastApply;
}] call CBA_fnc_addEventHandler;
