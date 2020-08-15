#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

if(_control == "brt") then {
	if (isnil "fza_ah64_mpdbrightness") then {
        fza_ah64_mpdbrightness = 1;
    };
    if (fza_ah64_mpdbrightness == 0.2) exitwith {
        fza_ah64_mpdbrightness = 1;
        _heli setobjecttexture [SEL_MPD_BRT, ""];
    };
    if (fza_ah64_mpdbrightness == 0.4) exitwith {
        fza_ah64_mpdbrightness = 0.2;
        _heli setobjecttexture [SEL_MPD_BRT, "\fza_ah64_US\tex\MPD\Brt1.paa"];
    };
    if (fza_ah64_mpdbrightness == 0.6) exitwith {
        fza_ah64_mpdbrightness = 0.4;
        _heli setobjecttexture [SEL_MPD_BRT, "\fza_ah64_US\tex\MPD\Brt2.paa"];
    };
    if (fza_ah64_mpdbrightness == 1) exitwith {
        fza_ah64_mpdbrightness = 0.6;
        _heli setobjecttexture [SEL_MPD_BRT, "\fza_ah64_US\tex\MPD\Brt3.paa"];
    };
	["fza_ah64_knob", 0.1] spawn fza_fnc_playAudio;
};

if(_system == "lmpd") then {
	switch([_heli, 0] call fza_fnc_mpdGetCurrentDisplay) do {
		case "dms": {
			[_heli, _system, _control] call fza_fnc_mpdLDMSHandleControl;
		};
		case "flt": {
			[_heli, _system, _control] call fza_fnc_mpdLFLTHandleControl
		};
		case "fuel": {
			[_heli, _system, _control] call fza_fnc_mpdLFUELHandleControl;
		};
		case "wca": {
			[_heli, _system, _control] call fza_fnc_mpdLWCAHandleControl;
		};
		case "wpn": {
			[_heli, _system, _control] call fza_fnc_mpdLWPNHandleControl;
		};
		case "wca": {
			[_heli, _system, _control] call fza_fnc_mpdWCAHandleControl;
		};
	};
};
if(_system == "rmpd") then {
	switch([_heli, 1] call fza_fnc_mpdGetCurrentDisplay) do {
		case "ase": {
			[_heli, _system, _control] call fza_fnc_mpdRASEHandleControl;
		};
		case "dms": {
			[_heli, _system, _control] call fza_fnc_mpdRDMSHandleControl;
		};
		case "eng": {
			[_heli, _system, _control] call fza_fnc_mpdRENGHandleControl;
		};
		case "fcr": {
			[_heli, _system, _control] call fza_fnc_mpdRFCRHandleControl;
		};
		case "tsd": {
			[_heli, _system, _control] call fza_fnc_mpdRTSDHandleControl;
		};
		case "wca": {
			[_heli, _system, _control] call fza_fnc_mpdWCAHandleControl;
		};
	};
};