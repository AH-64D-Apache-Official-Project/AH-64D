/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engineReset

Description:
    Resets critical variables on the engine when the engine is turned off.

Parameters:
    _heli   - The helicopter to get information from [Unit].
    _engNum - The engine to reset

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum"];

if (!local _heli) exitWith {};

[_heli, "fza_sfmplus_engPowerLeverState",  _engNum, "OFF", true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engState", 		   _engNum, "OFF", true] call fza_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engFF", 	 	 _engNum, 0.0, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engBaseNG", 	 _engNum, 0.0, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctNG",  	 _engNum, 0.0, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engBaseNP", 	 _engNum, 0.0, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctNP",  	 _engNum, 0.0, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctTQ",   	 _engNum, 0.0, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engBaseTGT", 	 _engNum, 0.0, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engTGT",		 _engNum, 0.0, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engBaseOilPSI", _engNum, 0.0, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engOilPSI", 	 _engNum, 0.0, true] call fza_fnc_setArrayVariable;
