/* ----------------------------------------------------------------------------
Function: fza_fnc_pfzRecive

Description:

Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_pfzRecive;
    
Author:
---------------------------------------------------------------------------- */
params["_heli"];
if (fza_ah64_pfzcache select 1 == "all" || fza_ah64_pfzcache select 1 == (name player)) then {
    _pfzIndex = _heli getVariable "fza_ah64_pfz_count";
    if(1 <= _pfzIndex && _pfzIndex <= 8) then {
    if(1 <= _pfzIndex && _pfzIndex < 9) then {
        _pfzs = _heli getVariable "fza_ah64_pfzs";
        _pfzs set [_pfzIndex - 1, (fza_ah64_pfzcache select 2)];
        _heli setVariable ["fza_ah64_pfzs", _pfzs, true];