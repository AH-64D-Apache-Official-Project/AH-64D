#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\engineConstants.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "brt": {
		if (player == driver _heli) then {
			["fza_ah64_knob", 0.1] spawn fza_fnc_playAudio;
		} else {
			["fza_ah64_switch_flip2", 0.1] spawn fza_fnc_playAudio;
		};

		if (_heli animationphase "cpg_ihadss_brt" < 1 && player == gunner _heli) then {
			_heli animate["cpg_ihadss_brt", 1];
		} else {
			_heli animate["cpg_ihadss_brt", 0];
		};
		[_heli] exec "\fza_ah64_controls\scripting\ihadss.sqs";
	};
	case "stow": {
		["fza_ah64_monoclebox", 0.1] spawn fza_fnc_playAudio;
		[_heli] exec "\fza_ah64_controls\scripting\monocle.sqs";
	};
};