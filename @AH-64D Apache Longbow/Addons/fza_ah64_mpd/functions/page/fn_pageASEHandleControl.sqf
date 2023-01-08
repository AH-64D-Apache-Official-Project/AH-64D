#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_control"];

switch(_control) do {
	//Chaff
	case "t1": {
		private _newState = ["safe", "arm"] select (_heli getVariable "fza_ah64_ase_chaffState" == "safe");
        _heli setVariable ["fza_ah64_ase_chaffState", _newState];
	};
	//IR Jammer
	case "r1": {
		private _newState = ["off", "on"] select (_heli getVariable "fza_ah64_ase_irjamPwr" == "off");
        _heli setVariable ["fza_ah64_ase_irJamPwr", _newState];
	};
	//RLWR
	case "r6": {
		private _newState = ["off", "on"] select (_heli getVariable "fza_ah64_ase_rlwrPwr" == "off");
        _heli setVariable ["fza_ah64_ase_rlwrPwr", _newState];
		if (_newstate == "on") then {
			["fza_ah64_APR_39_Power_up", 1.8] spawn fza_fnc_playAudio;
		};
	};
	case "t2": {
		[_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
	};
	case "menu": {
		[_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
	};
	//RF Jammer
	case "b3": {
		_heli setVariable ["fza_ah64_ase_rfJamState", ASE_RFJAM_STATE_OFF];
	};
	case "b4": {
		_heli setVariable ["fza_ah64_ase_rfJamState", ASE_RFJAM_STATE_WARM_STBY];
	};
	case "b5": {
		_heli setVariable ["fza_ah64_ase_rfJamState", ASE_RFJAM_STATE_WARM_OPER];
	};
	//Autopage
	case "l3": {
		_heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_SRH];
	};
	case "l4": {
		_heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_ACQ];
	};
	case "l5": {
		_heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_TRK];
	};
	case "l6": {
		_heli setVariable ["fza_ah64_ase_autopage", ASE_AUTOPAGE_OFF];
	};
};