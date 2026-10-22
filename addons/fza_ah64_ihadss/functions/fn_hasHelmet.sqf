/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_hasHelmet

Description:
    True when the unit wears the IHADSS helmet (fza_ah64_ihadss, or headgear
    that inherits from it). The HDU and the head tracking are the helmet's:
    without it there is no monocle, and no head LOS for the HMD sight, the
    acquisition sources and the NVS sensors to follow.

Parameters:
    _unit - The unit

Returns:
    Boolean

Examples:
    --- Code
    [player] call fza_ihadss_fnc_hasHelmet
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_unit", objNull, [objNull]]];

(headgear _unit) isKindOf ["fza_ah64_ihadss", configFile >> "CfgWeapons"]
