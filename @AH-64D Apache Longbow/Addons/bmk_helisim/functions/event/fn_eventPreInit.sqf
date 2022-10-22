bmk_helisim_keyboardOnly = true;

private _eventTypes = ["Activate", "Deactivate", "Analog"];

//Keyboard
{
    addUserActionEventHandler ["HeliCollectiveRaise", _x, {bmk_helisim_keyboardOnly = true;}];
    addUserActionEventHandler ["HeliCollectiveLower", _x, {bmk_helisim_keyboardOnly = true;}];
} forEach _eventTypes;

//HOTAS
{
    addUserActionEventHandler ["HeliCollectiveRaiseCont", _x, {bmk_helisim_keyboardOnly = false;}];
    addUserActionEventHandler ["HeliCollectiveLowerCont", _x, {bmk_helisim_keyboardOnly = false;}];
} forEach _eventTypes;