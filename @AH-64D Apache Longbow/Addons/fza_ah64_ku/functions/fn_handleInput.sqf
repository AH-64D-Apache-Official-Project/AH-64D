params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "\fza_ah64_ku\headers\constants.hpp"

disableSerialization;

if !(vehicle player isKindOf "fza_ah64base") exitwith {
    if (!isNil "fza_ku_keyDownEvent") then {
        ["KeyDown",fza_ku_keyDownEvent] call CBA_fnc_removeDisplayHandler;
        fza_ku_keyDownEvent = nil;
    };
};

private _heli = vehicle player;

if (_heli getVariable "fza_ku_state" == KU_STATE_OFF) exitWith {
    false
};

private _addChar = {
    params ["_heli", "_char"];
    private _currentInput = _heli getVariable "fza_ku_input";
    _heli setVariable ["fza_ku_state", KU_STATE_INPUT];
    if (count _currentInput < KU_MAX_CHARS) then {
        _heli setVariable ["fza_ku_input", _currentInput + _keyCode];
        [_heli] call fza_ku_fnc_update;
    };
};

if (_key == DIK_ESCAPE) exitwith {
    if (!isNil "fza_ku_keyDownEvent") then {
        ["KeyDown",fza_ku_keyDownEvent] call CBA_fnc_removeDisplayHandler;
        fza_ku_keyDownEvent = nil;
    };
};

if (_key == DIK_RETURN || _key == DIK_NUMPADENTER) exitwith {
    [_heli] call fza_ku_fnc_enter;
    true;
};

private _keyCode = _key call BIS_fnc_keyCode;

if (count _keyCode == 1) exitwith { // Is 0-9 A-Z
    [_heli, _keyCode] call _addChar;
    true;
};

private _otherKeys = createHashMapFromArray [
    [DIK_SLASH, "/"],
    [DIK_NUMPAD0, "0"],
    [DIK_NUMPAD0, "1"],
    [DIK_NUMPAD0, "2"],
    [DIK_NUMPAD0, "3"],
    [DIK_NUMPAD0, "4"],
    [DIK_NUMPAD0, "5"],
    [DIK_NUMPAD0, "6"],
    [DIK_NUMPAD0, "7"],
    [DIK_NUMPAD0, "8"],
    [DIK_NUMPAD0, "9"],
    [DIK_SPACE, " "],
    [DIK_MINUS, "-"],
    [DIK_EQUALS, "+"],
    [DIK_PERIOD, "."],
    [DIK_MULTIPLY, "*"],
    [DIK_NUMPADSTAR, "*"],
    [DIK_SUBTRACT, "-"],
    [DIK_ADD, "+"],
    [DIK_DECIMAL, "."],
    [DIK_NUMPADMINUS, "-"],
    [DIK_NUMPADPLUS, "+"],
    [DIK_NUMPADPERIOD, "."],
    [DIK_NUMPADSLASH, "/"],
    [DIK_DIVIDE, "/"]];

if (_otherKeys getOrDefault [_key, -1] isNotEqualTo -1) exitwith {
    private _keyCode = _otherKeys getOrDefault [_key, -1];
    [_heli, _keyCode] call _addChar;
    true;
};

if (_key == DIK_BACK || _key == DIK_BACKSPACE) exitwith {
    private _currentInput = _heli getVariable "fza_ku_input";
    private _newInput = _currentInput select [0, (count _currentInput - 1) max 0];
    _heli setVariable ["fza_ku_input", _newInput];
    _heli setVariable ["fza_ku_state", KU_STATE_INPUT];
    [_heli] call fza_ku_fnc_update;
    true;
};

false