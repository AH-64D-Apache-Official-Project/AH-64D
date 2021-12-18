if (isNil "fza_ku_keyDownEvent") then {
    fza_ku_keyDownEvent = ["KeyDown","_this call fza_ku_fnc_handleInput"] call CBA_fnc_addDisplayHandler
} else {
    ["KeyDown",fza_ku_keyDownEvent] call CBA_fnc_removeDisplayHandler;
    fza_ku_keyDownEvent = nil;
}