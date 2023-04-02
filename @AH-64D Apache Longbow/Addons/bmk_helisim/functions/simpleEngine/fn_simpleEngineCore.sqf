params ["_heli", "_deltaTime", "_engNum", "_engInput", "_altitude", "_temperature", "_controlInputs"];

private _config = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";

_engInput
    params ["_refTq", "_gndIdleTq", "_fltIdleTq", "_flyTq", "_startNg", "_idleNg", "_flyNg", "_maxNg", "_gndIdleNp", "_fltIdleNp", "_flyNp"];

_controlInputs
    params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal", "_pedalVal", "_engineThrottleVal"];


systemChat format ["Eng %1 core simulation is running", _engNum];

private _engThrottleSetPoint = _heli getVariable "bmk_helisim_engThrottleSetPoint" select _engNum;
private _engOutputNg         = _heli getVariable "bmk_helisim_engOutputNg" select _engNum;

private _intEngBaseTable = [getArray (_config >> "engBaseTable"), _engOutputNg] call fza_fnc_linearInterp;
//Base TGT
private _engBaseTGT      = _intEngBaseTable select 1;
//Base Oil
private _engBaseOilPSI   = _intEngBaseTable select 4;

hintSilent format ["Eng %1
                    \nRPM = %2
                    \nTGT = %3
                    \nOil PSI = %4
                    \Ng = %5", _engNum, _engBaseTGT, _engBaseOilPSI, _engOutputNg];

[_heli, "bmk_helisim_engOutputTGT",         _engNum, _engBaseTGT] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engOutputOilPSI",      _engNum, _engBaseOilPSI] call fza_sfmplus_fnc_setArrayVariable;