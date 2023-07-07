params ["_heli", "_mpdIndex", "_control", "_state", "_persistStage"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _showScale = _heli getVariable "fza_ah64_showScale";
private _subpage = _state get "subPageVarPage" select 0;

if !(_subpage in [0,2,4]) exitwith {};

switch (_control) do {
    case "r1": {
        if _showScale then {
            _heli setVariable ["fza_ah64_scaleRange", 50000];
            _heli setVariable ["fza_ah64_showScale", false];
        };
    };
    case "r2": { 
        if !_showScale then {
            _heli setVariable ["fza_ah64_showScale", true];
        } else {
            _heli setVariable ["fza_ah64_scaleRange", 25000];
            _heli setVariable ["fza_ah64_showScale", false];
        };
    };
    case "r3": {
        if _showScale then {
            _heli setVariable ["fza_ah64_scaleRange", 10000];
            _heli setVariable ["fza_ah64_showScale", false];
        };
    };
    case "r4": {
        if _showScale then {
            _heli setVariable ["fza_ah64_scaleRange", 5000];
            _heli setVariable ["fza_ah64_showScale", false];
        };
    };
};