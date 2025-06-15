
fza_sfmplus_keyboardCollective = true;

private _eventTypes = ["Activate", "Deactivate", "Analog"];

//{
//    addUserActionEventHandler ["fza_ah64_collectiveUp", _x, {if (_x != "Analog") then { fza_sfmplus_keyboardCollective = true;} else { fza_sfmplus_keyboardCollective = false; };}];
//    addUserActionEventHandler ["fza_ah64_collectiveDn", _x, {if (_x != "Analog") then { fza_sfmplus_keyboardCollective = true;} else { fza_sfmplus_keyboardCollective = false; };}];
//} forEach _eventTypes;


addUserActionEventHandler ["fza_ah64_collectiveUp", "Activate",   { fza_sfmplus_keyboardCollective = true;}];
addUserActionEventHandler ["fza_ah64_collectiveUp", "Deactivate", { fza_sfmplus_keyboardCollective = true;}];
addUserActionEventHandler ["fza_ah64_collectiveUp", "Analog",     { fza_sfmplus_keyboardCollective = false;}];

addUserActionEventHandler ["fza_ah64_collectiveDn", "Activate",   { fza_sfmplus_keyboardCollective = true;}];
addUserActionEventHandler ["fza_ah64_collectiveDn", "Deactivate", { fza_sfmplus_keyboardCollective = true;}];
addUserActionEventHandler ["fza_ah64_collectiveDn", "Analog",     { fza_sfmplus_keyboardCollective = false;}];