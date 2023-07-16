params ["_heli", "_mpdIndex", "_control", "_state", "_persistStage"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _showScale = _state get "showScale";
private _subpage = _state get "subPageVarPage" select 0;
private _interactHandled = false;

if !(_subpage in [0,2,4]) exitwith {};

switch (_control) do {
    case "r1": {
        if (_showScale == 1) then {
            _persistState set ["tsdScale", 50000];
            _state set ["showScale", 0];
            _interactHandled = true;
        };
    };
    case "r2": { 
        if (_showScale == 0) then {
            _state set ["showScale", 1];
            _interactHandled = true;
        } else {
            _persistState set ["tsdScale", 25000];
            _state set ["showScale", 0];
            _interactHandled = true;
        };
    };
    case "r3": {
        if (_showScale == 1) then {
            _persistState set ["tsdScale", 10000];
            _state set ["showScale", 0];
            _interactHandled = true;
        };
    };
    case "r4": {
        if (_showScale == 1) then {
            _persistState set ["tsdScale", 5000];
            _state set ["showScale", 0];
            _interactHandled = true;
        };
    };
};

_interactHandled;