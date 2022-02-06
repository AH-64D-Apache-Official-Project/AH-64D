/* ----------------------------------------------------------------------------
Function: fza_fnc_coreGetWCAs

Description:
    Retrieves a list of the warnings, cautions and advisories for the helicopter returned

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:
	2d array, an array for each active WCA entry in thee format
	    [_type, _mpd, _ufd]
	
	* _type - either WCA_CAUTION, WCA_WARNING or WCA_ADVISORY
	* _mpd - the texture to be used by the MPD
	* _ufd - the texture to be used by the UFD

Examples:
	--- Code
	// Helicopter without any issues
    _data = [_heli] call fza_fnc_coreGetWCAs
	// _data = []

	// Helicoper with an engine fire and the rotor brake on
    _data = [_heli] call fza_fnc_coreGetWCAs
	// _data = [[WCA_WARNING, "\fza_ah64_us\tex\MPD\E1Fire.paa"], 
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\wcaConstants.h"

params ["_heli"];

private _mags = _heli weaponsTurret [-1];

private _wcas = [];

// WARNINGS

if (_heli getVariable "fza_ah64_e1_fire") then {
	_wcas pushBack [WCA_WARNING, "ENG1 FIRE", ""]
};
if (_heli getVariable "fza_ah64_e2_fire") then {
	_wcas pushBack [WCA_WARNING, "ENG2 FIRE", ""]
};
if (_heli getVariable "fza_ah64_apu_fire") then {
	_wcas pushBack [WCA_WARNING, "APU FIRE", ""]
};
if (_heli getHitPointDamage "HitHRotor" >= 0.4 && _heli getHitPointDamage "HitHRotor" < 0.8) then {
	_wcas pushBack [WCA_WARNING, "HIGH ROTOR RPM", "HIGH RTR  "]
};
if ( _heli getHitPointDamage "HitHRotor" >= 0.8) then {
	_wcas pushBack [WCA_WARNING, "LOW ROTOR RPM", "LOW RTR   "]
};
if (_heli getHitPointDamage "HitVRotor" >= 0.8) then {
	_wcas pushBack [WCA_WARNING, "TAIL ROTOR HYD", "TAIL RTR  "]
};
if (_heli getHitPointDamage "HitEngine" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "MAIN XMSN FAILURE", "MAIN XMSN  "];
};

// CAUTIONS

if (_heli getHitPointDamage "HitVRotor" >= 0.4 && _heli getHitPointDamage "HitVRotor" < 0.8) then {
	_wcas pushBack [WCA_CAUTION, "TROTOR DEGR", "TAIL RTR   "];
};
if (_heli getHitPointDamage "HitEngine" >= 0.4 && _heli getHitPointDamage "HitEngine" < 0.8) then {
	_wcas pushBack [WCA_CAUTION, "MAIN XMSN DEGRADED", "MAIN XMSN  "];
};
if (fuel _heli < 0.05) then {
	_wcas pushBack [WCA_CAUTION, "FORWARD FUEL LOW", "FWD FUEL LO"];
};
if (fuel _heli >= 0.05 && fuel _heli < 0.1) then {
	_wcas pushBack [WCA_CAUTION, "AFT FUEL LOW", "AFT FUEL LO"];
};
if (_heli getVariable "fza_ah64_apu" && getpos _heli # 2 >= 3) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\APUON.paa", "\fza_ah64_us\tex\UFD\APUON_A_co.paa"]
};
if (_heli getHitPointDamage "Hitlfab" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "IRJAM FAIL", "IRJAM FAIL "]
};
if (_heli getHitPointDamage "Hitrfab" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "RFJAM FAIL", "RFJAM FAIL "]
};
if (_heli getHit "radar" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "FCR FAIL", ""]
};
if (_heli getHit "pnvs" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "PNVS FAIL", ""]
};
if (_heli getHit "otochlaven" >= 0.9) then {
	_wcas pushBack [WCA_CAUTION, "GUN JAM", ""]
};
if (_heli getHit "otocvez" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "GUN ACTUATOR FAIL", ""]
};

// ADVISORIES

if (_heli animationphase "gdoor" > 0 || _heli animationphase "pdoor" > 0) then {
	_wcas pushBack [WCA_ADVISORY, "CANOPY OPEN", "CANOPY    "]
};
if (_heli getVariable "fza_ah64_apu" && getpos _heli # 2 < 3) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\APUON.paa", "\fza_ah64_us\tex\UFD\APUON_A_co.paa"]
};
if (_heli animationphase "plt_eng1_start" > 0 && _heli animationphase "plt_eng1_throttle" < 0.25) then {
	_wcas pushBack [WCA_ADVISORY, "ENGINE 1 START", "ENG 1 START"]
};
if (_heli animationphase "plt_eng2_start" > 0 && _heli animationphase "plt_eng2_throttle" < 0.25) then {
	_wcas pushBack [WCA_ADVISORY, "ENGINE 2 START", "ENG 2 START"]
};
if (isAutoHoverOn _heli) then {
	_wcas pushBack [WCA_ADVISORY, "ATTITUDE HOLD", "ATT HOLD   "]
};
if (_heli getVariable "fza_ah64_rtrbrake") then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\RTRBRKON.paa", "\fza_ah64_us\tex\UFD\RTRBRKON_C_co.paa"]
};

if (_heli getVariable "fza_ah64_irjon" == 1 && fza_ah64_irjammer > 40) then {
	_wcas pushBack [WCA_ADVISORY, "IRJAM OVERHEAT", "IR JAM OHT"]
};
if (_heli getVariable "fza_ah64_rfjon" == 1 && fza_ah64_rfjammer > 40) then {
	_wcas pushBack [WCA_ADVISORY, "RFJAM OVERHEAT", "RF JAM OHT"]
};

_wcas;