/* ----------------------------------------------------------------------------
Function: fza_fnc_mpdcycleL
Description:
Parameters:
Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_mpdcycleL;
Author:
---------------------------------------------------------------------------- */
params["_heli"];

if ([_heli, 0] call fza_fnc_mpdGetCurrentDisplay == "fuel") exitwith {
    [_heli, 0, "wpn"] call fza_fnc_mpdSetDisplay;
};
if ([_heli, 0] call fza_fnc_mpdGetCurrentDisplay == "wpn") exitwith {
    [_heli, 0, "wca"] call fza_fnc_mpdSetDisplay;
};
if ([_heli, 0] call fza_fnc_mpdGetCurrentDisplay == "wca") exitwith {
    [_heli, 0, "flt"] call fza_fnc_mpdSetDisplay;
};
if ([_heli, 0] call fza_fnc_mpdGetCurrentDisplay == "flt") exitwith {
    [_heli, 0, "fuel"] call fza_fnc_mpdSetDisplay;
};