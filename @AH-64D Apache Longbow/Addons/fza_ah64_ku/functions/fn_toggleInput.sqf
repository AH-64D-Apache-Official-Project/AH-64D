if (isNil "fza_ku_keyDownEvent") then {
    fza_ku_keyDownEvent = ["KeyDown","_this call fza_ku_fnc_handleInput"] call CBA_fnc_addDisplayHandler
} else {
    [] call fza_ku_fnc_stopInput;
}