params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

if (currentPilot _heli != player || !local _heli) exitWith {};

//Cyclic pitch trim
private _curCyclicFwdAft  = (_heli getVariable "fza_sfmplus_cyclicFwdAft");
private _prevCyclicFwdAft = _heli getVariable "fza_ah64_forceTrimPosPitch";
private _pitchTrimVal     = [_curCyclicFwdAft, _prevCyclicFwdAft] call fza_sfmplus_fnc_getInterpInput;
if (fza_ah64_sfmPlusSpringlessCyclic || fza_ah64_sfmPlusKeyboardStickyPitch) then {
    _heli setVariable ["fza_ah64_forceTrimPosPitch", 0.0];
} else {
    _heli setVariable ["fza_ah64_forceTrimPosPitch", _pitchTrimVal, true];
};
//Cyclic roll trim
private _curCyclicLeftRight  = (_heli getVariable "fza_sfmplus_cyclicLeftRight");
private _prevCyclicLeftRight = _heli getVariable "fza_ah64_forceTrimPosRoll";
private _rollTrimVal         = [_curCyclicLeftRight, _prevCyclicLeftRight] call fza_sfmplus_fnc_getInterpInput;
if (fza_ah64_sfmPlusSpringlessCyclic || fza_ah64_sfmPlusKeyboardStickyRoll) then {
    _heli setVariable ["fza_ah64_forceTrimPosRoll",  0.0];
} else {
    _heli setVariable ["fza_ah64_forceTrimPosRoll", _rollTrimVal, true];
};
//Pedal trim
private _curPedalLeftRight  = (_heli getVariable "fza_sfmplus_pedalLeftRight");
private _prevPedalLeftRight = _heli getVariable "fza_ah64_forceTrimPosYaw";
private _pedalTrimVal       = [_curPedalLeftRight, _prevPedalLeftRight] call fza_sfmplus_fnc_getInterpInput;
if (fza_ah64_sfmplusSpringlessPedals || fza_ah64_sfmPlusKeyboardStickyYaw) then {
    _heli setVariable ["fza_ah64_forceTrimPosYaw", 0.0];
} else {
    _heli setVariable ["fza_ah64_forceTrimPosYaw", _pedalTrimVal, true];
};
