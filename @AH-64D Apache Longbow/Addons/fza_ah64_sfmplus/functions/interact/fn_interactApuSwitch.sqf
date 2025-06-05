
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\engineConstants.h"
params ["_heli"];

private _apuBtnOn = _heli getVariable "fza_systems_apuBtnOn";
private _battBusOn = _heli getVariable "fza_systems_battBusOn";

if (!_apuBtnOn && _battBusOn) exitwith {
    [_heli] call fza_systems_fnc_interactAPUButton;
    playsound "fza_ah64_apubutton";
    [_heli] spawn fza_fnc_fxLoops;
    [_heli, ["fza_ah64_apustart_3D", 200]] remoteExec["say3d"];
};

if (_apuBtnOn) then {
    [_heli] call fza_systems_fnc_interactAPUButton;
    _heliData = _heli getVariable "fza_ah64_engineStates";
    (_heliData # 0) params ["_e1state"];
    (_heliData # 1) params ["_e2state"];
    if (_e1state in ENGINE_STATE_USING_STARTER) then {
        [_heli, 0, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
    };
    if (_e2state in ENGINE_STATE_USING_STARTER) then {
        [_heli, 1, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
    };
    [_heli, ["fza_ah64_apustop_3D", 100]] remoteExec["say3d"];
};