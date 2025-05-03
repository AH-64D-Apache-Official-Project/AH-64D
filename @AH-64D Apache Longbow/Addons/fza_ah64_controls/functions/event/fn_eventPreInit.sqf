fza_ah64_sfmPlusKeyboardOnly = true;

private _eventTypes = ["Activate", "Deactivate", "Analog"];

{
    addUserActionEventHandler ["HeliCollectiveRaise", _x, {fza_ah64_sfmPlusKeyboardOnly = true;}];
    addUserActionEventHandler ["HeliCollectiveLower", _x, {fza_ah64_sfmPlusKeyboardOnly = true;}];
} forEach _eventTypes;

{
    addUserActionEventHandler ["HeliCollectiveRaiseCont", _x, {fza_ah64_sfmPlusKeyboardOnly = false;}];
    addUserActionEventHandler ["HeliCollectiveLowerCont", _x, {fza_ah64_sfmPlusKeyboardOnly = false;}];
} forEach _eventTypes;