/* ----------------------------------------------------------------------------
Function: fza_fnc_Ufd

Description:
    handles the ufd textures
    
Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_Ufd;

Author:
    Unknown
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\selections.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
if (!(isNil "fza_ah64_noufd")) exitwith {};
_heli = _this select 0;

_wcacall = {
    _heli = _this select 0;
    _start = _this select 1;
    _end = _this select 2;
    _list = _this select 3;
    _counter = count _list - 1;
    _selection = _start;
    while {
        (_counter >= 0 && _selection <= _end)
    }
    do {
        _heli setobjecttexture[_selection, (_list select _counter)];
        _selection = _selection + 1;
        _counter = _counter - 1;
        sleep 0.03;
    };
    if (count _list < 5) then {
        _selection = _end;
        while {
            (_selection >= (count _list + _start))
        }
        do {
            _heli setobjecttexture[_selection, ""];
            _selection = _selection - 1;
            sleep 0.03;
        };
    };
};

while {
    (time > -1)
}
do {
    waituntil {
        (vehicle player) iskindof "fza_ah64base"
    };
    _heli = vehicle player;
    waitUntil {
        ((driver(vehicle player) == player || gunner(vehicle player) == player))
    };

    ///////NAV///////
    if (!(isnil "fza_ah64_waypointdata")) then {
        if (_heli getVariable "fza_ah64_curwpnum" > (count (_heli getVariable "fza_ah64_waypointdata") - 1)) then {
            _heli setVariable ["fza_ah64_curwpnum", 0, true];
        };
        _waypoint = (_heli getVariable "fza_ah64_waypointdata") select (_heli getVariable "fza_ah64_curwpnum");
        if ([(getposasl _heli select 0), (getposasl _heli select 1), 0] distance _waypoint < 50) then {
            [_heli] call fza_fnc_controlHandleNextWaypoint;
        };
    };
    /////////////////

    _hour = round(floor daytime);
    _min = round(floor((daytime - floor(daytime)) * 60));
    _sec = floor((((daytime - floor daytime) * 60) - floor((daytime - floor daytime) * 60)) * 60);
    
    ///WCA///
    _mags = _heli magazinesturret[-1];
    _magsg = magazines _heli;

    ///end gunner weapon damage//
    if (_heli animationphase "plt_apu" > 0.5) then {
        _heli setobjecttexture [SEL_IN_LT_APU, "\fza_ah64_us\tex\in\pushbut.paa"];
    } else {
        _heli setobjecttexture [SEL_IN_LT_APU, ""];
    };
    if (_heli getVariable "fza_ah64_rdp_fail" && !(_heli getVariable "fza_ah64_ldp_fail") && [_heli, 0] call fza_fnc_mpdGetCurrentDisplay != "fail") then {
        [_heli, 1, "fail"] call fza_fnc_mpdSetDisplay;
    };
    if (_heli getVariable "fza_ah64_ldp_fail" && !(_heli getVariable "fza_ah64_rdp_fail") && [_heli, 1] call fza_fnc_mpdGetCurrentDisplay != "fail") then {
        [_heli, 0, "fail"] call fza_fnc_mpdSetDisplay;
    };
    if (_heli getVariable "fza_ah64_e1_fire") then {
        _heli setobjecttexture [SEL_IN_LT_FIRE1, "\fza_ah64_us\tex\in\pushbut.paa"];
    } else {
        _heli setobjecttexture [SEL_IN_LT_FIRE1, ""];
    };
    if (_heli getVariable "fza_ah64_e2_fire") then {
        _heli setobjecttexture [SEL_IN_LT_FIRE2, "\fza_ah64_us\tex\in\pushbut.paa"];
    } else {
        _heli setobjecttexture [SEL_IN_LT_FIRE2, ""];
    };
    if (_heli getVariable "fza_ah64_apu_fire") then {
        _heli setobjecttexture [SEL_IN_LT_FIREAPU, "\fza_ah64_us\tex\in\pushbut.paa"];
    } else {
        _heli setobjecttexture [SEL_IN_LT_FIREAPU, ""];
    };
    if (_heli getVariable "fza_ah64_firepdisch") then {
        _heli setobjecttexture [SEL_IN_LT_FIREPDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
    } else {
        _heli setobjecttexture [SEL_IN_LT_FIREPDIS, ""];
    };
    if (_heli getVariable "fza_ah64_firerdisch") then {
        _heli setobjecttexture [SEL_IN_LT_FIRERDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
    } else {
        _heli setobjecttexture [SEL_IN_LT_FIRERDIS, ""];
    };

    ///EWCA//
    //pilot
    if (_heli animationphase "plt_batt" > 0.5) then {
        _heli setobjecttexture [SEL_UFD_BACK, "\fza_ah64_us\tex\in\ufdon.paa"];
        [_heli, fuel _heli * 2538, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_G_UFD_FL] call fza_fnc_drawNumberSelections;
        [_heli, fuel _heli * 2538, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_P_UFD_FL] call fza_fnc_drawNumberSelections;
        [_heli, _hour, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_G_UFD_HR] call fza_fnc_drawNumberSelections;
        [_heli, _min, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_G_UFD_MIN] call fza_fnc_drawNumberSelections;
        [_heli, _sec, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_G_UFD_MIN] call fza_fnc_drawNumberSelections;
        [_heli, _hour, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_P_UFD_HR] call fza_fnc_drawNumberSelections;
        [_heli, _min, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_P_UFD_MIN] call fza_fnc_drawNumberSelections;
        [_heli, _sec, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_P_UFD_MIN] call fza_fnc_drawNumberSelections;

        _wcas = ([_heli] call fza_fnc_coreGetWCAs) select {_x # 2 != ""}; //Removes any WCAs that shouldn't be shown on the EUFD
        _warnings = (_wcas select {_x # 0 == WCA_WARNING}) apply {_x # 2};
        _cautions = (_wcas select {_x # 0 == WCA_CAUTION}) apply {_x # 2};
        _advisories = (_wcas select {_x # 0 == WCA_ADVISORY}) apply {_x # 2};
        //advisories//
        _a = [_heli, 1028, 1032, _advisories] call _wcacall;
        //cautions//
        _c = [_heli, 1033, 1037, _cautions] call _wcacall;
        //warnings//
        _w = [_heli, 1038, 1042, _warnings] call _wcacall;
        //advisories//
        _a = [_heli, 1053, 1057, _advisories] call _wcacall;
        //cautions//
        _c = [_heli, 1058, 1062, _cautions] call _wcacall;
        //warnings//
        _w = [_heli, 1063, 1067, _warnings] call _wcacall;
    } else {
        _heli setobjecttexture [SEL_UFD_BACK, ""];
        _heli setobjecttexture [SEL_P_UFD_CLK1, ""];
        _heli setobjecttexture [SEL_P_UFD_CLK2, ""];
        _heli setobjecttexture [SEL_P_UFD_CLK3, ""];
        _heli setobjecttexture [SEL_P_UFD_CLK4, ""];
        _heli setobjecttexture [SEL_P_UFD_CLK5, ""];
        _heli setobjecttexture [SEL_P_UFD_CLK6, ""];
        _heli setobjecttexture [SEL_P_UFD_FL1, ""];
        _heli setobjecttexture [SEL_P_UFD_FL2, ""];
        _heli setobjecttexture [SEL_P_UFD_FL3, ""];
        _heli setobjecttexture [SEL_P_UFD_FL4, ""];
        //advisories//
        _a = [_heli, 1028, 1032, []] call _wcacall;
        //cautions//
        _c = [_heli, 1033, 1037, []] call _wcacall;
        //warnings//
        _w = [_heli, 1038, 1042, []] call _wcacall;
        //gunner
        _heli setobjecttexture [SEL_G_UFD_CLK1, ""];
        _heli setobjecttexture [SEL_G_UFD_CLK2, ""];
        _heli setobjecttexture [SEL_G_UFD_CLK3, ""];
        _heli setobjecttexture [SEL_G_UFD_CLK4, ""];
        _heli setobjecttexture [SEL_G_UFD_CLK5, ""];
        _heli setobjecttexture [SEL_G_UFD_CLK6, ""];
        _heli setobjecttexture [SEL_G_UFD_FL1, ""];
        _heli setobjecttexture [SEL_G_UFD_FL2, ""];
        _heli setobjecttexture [SEL_G_UFD_FL3, ""];
        _heli setobjecttexture [SEL_G_UFD_FL4, ""];
        //advisories//
        _a = [_heli, 1053, 1057, []] call _wcacall;
        //cautions//
        _c = [_heli, 1058, 1062, []] call _wcacall;
        //warnings//
        _w = [_heli, 1063, 1067, []] call _wcacall;
    };
    sleep 0.1;
};