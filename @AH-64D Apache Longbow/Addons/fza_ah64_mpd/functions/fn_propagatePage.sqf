/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_propagatePage

Description:
    Propagate current page over the network

Parameters:
    _heli - the helicopter to modify

Returns:
    Nothing

Examples:

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

[_heli, "fza_mpd_page", 
    [ [_heli, 0] call fza_mpd_fnc_currentPage
    , [_heli, 1] call fza_mpd_fnc_currentPage
    ]] call fza_fnc_setSeatVariable;