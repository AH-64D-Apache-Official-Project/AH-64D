params ["_heli"];
if !(isNil "fza_ku_keyDownEvent") then {
    [] call fza_ku_fnc_stopInput;
}