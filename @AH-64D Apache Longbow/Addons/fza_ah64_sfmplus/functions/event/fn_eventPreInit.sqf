fza_sfmplus_keyboardCollective         = true;
fza_sfmplus_keyboardCollectivePrevious = true;

private _eventTypes = ["Activate", "Deactivate", "Analog"];

{
    addUserActionEventHandler ["HeliCollectiveRaise", _x, {fza_sfmplus_keyboardCollective = true;}];
    addUserActionEventHandler ["HeliCollectiveLower", _x, {fza_sfmplus_keyboardCollective = true;}];
} forEach _eventTypes;

{
    addUserActionEventHandler ["HeliCollectiveRaiseCont", _x, {fza_sfmplus_keyboardCollective = false;}];
    addUserActionEventHandler ["HeliCollectiveLowerCont", _x, {fza_sfmplus_keyboardCollective = false;}];
} forEach _eventTypes;