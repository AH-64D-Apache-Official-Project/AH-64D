/* ----------------------------------------------------------------------------
Function: fza_fnc_mpdcycleR

Description:
    cycles through the right mpds
    
Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_mpdcycleR;

Author:
    Unknown
---------------------------------------------------------------------------- */
_heli = _this select 0;

if ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "tsd") exitwith {
    [_heli, 1, "fcr"] call fza_fnc_mpdSetDisplay;
};
if ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "fcr") exitwith {
    [_heli, 1, "wca"] call fza_fnc_mpdSetDisplay;
};
if ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "wca") exitwith {
    [_heli, 1, "ase"] call fza_fnc_mpdSetDisplay;
};
if ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "ase") exitwith {
    [_heli, 1, "eng"] call fza_fnc_mpdSetDisplay;
};
if ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "eng") exitwith {
    [_heli, 1, "tsd"] call fza_fnc_mpdSetDisplay;
};