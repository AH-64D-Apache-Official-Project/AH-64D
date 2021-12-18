params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _phase = BOOLTONUM(_heli getVariable "fza_mpd_tsdMode" == "atk");
switch (_control) do {
    case "t1": {
        private _val = (_heli getVariable "fza_mpd_tsdShowHsi") ;
        _val set [_phase, !(_val # _phase)];
    };
    case "r1": {
        private _val = (_heli getVariable "fza_mpd_tsdShowCtrlMeasures") ;
        _val set [_phase, !(_val # _phase)];
    };
    case "r2": {
        private _val = (_heli getVariable "fza_mpd_tsdShowEnemy") ;
        _val set [_phase, !(_val # _phase)];
    };
    case "r3": {
        private _val = (_heli getVariable "fza_mpd_tsdShowFriendly") ;
        _val set [_phase, !(_val # _phase)];
    };
    case "r5": {
        private _val = (_heli getVariable "fza_mpd_tsdShowRlwr") ;
        _val set [_phase, !(_val # _phase)];
    };
    case "b6": {
        if (_heli getVariable "fza_mpd_tsdMode" == "atk") then {
            private _val = !(_heli getVariable "fza_mpd_tsdShowAtkHazard") ;
            _heli setVariable ["fza_mpd_tsdShowAtkHazard", _val];
        };
    };
    case "b5": {
        private _val = (_heli getVariable "fza_mpd_tsdShowWind") ;
        _val set [_phase, !(_val # _phase)];
    };
    case "b4": {
        if (_heli getVariable "fza_mpd_tsdMode" == "atk") then {
            private _val = !(_heli getVariable "fza_mpd_tsdShowAtkShot") ;
            _heli setVariable ["fza_mpd_tsdShowAtkShot", _val];
        };
    };
    case "b3": {
        private _val = (_heli getVariable "fza_mpd_tsdShowEndr") ;
        _val set [_phase, !(_val # _phase)];
    };
    case "l6": {
        _state set ["subPageVarPage", [0, 0]];
    };
    case "l5": {
        private _val = (_heli getVariable "fza_mpd_tsdShowPlanTgts") ;
        _val set [_phase, !(_val # _phase)];
    };
    case "l4": {
        if (_heli getVariable "fza_mpd_tsdMode" == "atk") then {
            private _val = !(_heli getVariable "fza_mpd_tsdShowAtkCurrRoute") ;
            _heli setVariable ["fza_mpd_tsdShowAtkCurrRoute", _val];
        } else {
            private _val = !(_heli getVariable "fza_mpd_tsdShowNavWptData") ;
            _heli setVariable ["fza_mpd_tsdShowNavWptData", _val];
        };
    };
}
