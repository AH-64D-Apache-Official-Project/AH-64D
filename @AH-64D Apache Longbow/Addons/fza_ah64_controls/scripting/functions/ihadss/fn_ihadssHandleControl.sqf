#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\engineConstants.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "brt": {
		if (player == driver _heli) then {
			_clicksound = ["fza_ah64_knob", 0.1];
		} else {
			_clicksound = ["fza_ah64_switch_flip2", 0.1];
		};

		if (_heli animationphase "cpg_ihadss_brt" < 1 && player == gunner _heli) then {
			_heli animate["cpg_ihadss_brt", 1];
		} else {
			_heli animate["cpg_ihadss_brt", 0];
		};
		[_heli] exec "\fza_ah64_controls\scripting\ihadss.sqs";
	};
	case "stow": {
		_clicksound = ["fza_ah64_monoclebox", 0.1];
		[_heli] exec "\fza_ah64_controls\scripting\monocle.sqs";
	};
};