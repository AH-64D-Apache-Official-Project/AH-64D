/* ----------------------------------------------------------------------------
Function: fza_fnc_coreGetWCAs

Description:
    Retrieves a list of the warnings, cautions and advisories for the helicopter returned

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:
	2d array, an array for each active WCA entry in thee format
	    [_type, _mpd]
	
	* _type - either WCA_CAUTION, WCA_WARNING or WCA_ADVISORY
	* _mpd - the texture to be used by the MPD

Examples:
	(begin example)
	// Helicopter without any issues
    _data = [_heli] call fza_fnc_coreGetWCAs
	// _data = []

	// Helicoper with an engine fire and the rotor brake on
    _data = [_heli] call fza_fnc_coreGetWCAs
	// _data = [[WCA_WARNING, "\fza_ah64_us\tex\MPD\E1Fire.paa"], 
	(end)

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\wcaConstants.h"

params ["_heli"];

private _mags = _heli weaponsTurret [-1];

private _wcas = [];

// WARNINGS

if ("fza_ah64_e1_fire" in _mags) then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\E1Fire.paa"]
}
if ("fza_ah64_e2_fire" in _mags) then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\E2Fire.paa"]
}
if ("fza_ah64_rotor_dam" in _mags && !("fza_ah64_rotor_fail" in _mags)) then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\HRTRRPM.paa"]
}
if ("fza_ah64_rotor_fail" in _mags) then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\LRTRRPM.paa"]
}
if ("fza_ah64_tailrotor_fail" in _mags) then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\TRTRHYD.paa"]
}

// CAUTIONS

if (_heli animationphase "plt_rtrbrake" == 1) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\RTRBRKON.paa"]
}
if ("fza_ah64_tailrotor_dam" in _mags && _trdam == 0) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\TRTRDEGR.paa"];
};
if ("fza_ah64_trans_dam" in _mags && !("fza_ah64_trans_fail" in _mags)) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\XMSNDGRD.paa"];
};
if ("fza_ah64_trans_fail" in _mags) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\XMSNFAIL.paa"];
};
if (fuel _heli < 0.05) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\FWDFUELLO.paa"];
};
if (fuel _heli >= 0.05 && fuel _heli < 0.1) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\AFTFUELLO.paa"];
};

// ADVISORIES

if (_heli animationphase "gdoor" > 0 || _heli animationphase "pdoor" > 0) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\CANOPY.paa"]
}