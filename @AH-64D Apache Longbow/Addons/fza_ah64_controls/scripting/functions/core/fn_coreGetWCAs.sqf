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
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\E1Fire.paa", ""]
};
if (_heli getVariable "fza_ah64_e2_fire") then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\E2Fire.paa", ""]
};
if (_heli getVariable "fza_ah64_apu_fire") then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\APUF.paa", ""]
};
if (_heli getHitPointDamage "HitHRotor" >= 0.4 && _heli getHitPointDamage "HitHRotor" < 0.8) then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\HRTRRPM.paa", "\fza_ah64_us\tex\UFD\RTRRPMHI_W_co.paa"]
};
if ( _heli getHitPointDamage "HitHRotor" >= 0.8) then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\LRTRRPM.paa", "\fza_ah64_us\tex\UFD\RPMLOW_W_co.paa"]
};
if (_heli getHitPointDamage "HitVRotor" >= 0.8) then {
	_wcas pushBack [WCA_WARNING, "\fza_ah64_us\tex\MPD\TRTRHYD.paa", "\fza_ah64_us\tex\UFD\TAILRTRHYD_W_co.paa"]
};

// CAUTIONS

if (_heli getHitPointDamage "HitVRotor" >= 0.4 && _heli getHitPointDamage "HitVRotor" < 0.8) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\TRTRDEGR.paa", "\fza_ah64_us\tex\UFD\TAILRTRHYD_W_co.paa"];
};
if (_heli getHitPointDamage "HitEngine" >= 0.4 && _heli getHitPointDamage "HitEngine" < 0.8) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\XMSNDGRD.paa", "\fza_ah64_us\tex\UFD\MAINXMSN_C_co.paa"];
};
if (_heli getHitPointDamage "HitEngine" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\XMSNFAIL.paa", "\fza_ah64_us\tex\UFD\MAINXMSN_C_co.paa"];
};
if (fuel _heli < 0.05) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\FWDFUELLO.paa", "\fza_ah64_us\tex\UFD\FWDFUELLOW_C_co.paa"];
};
if (fuel _heli >= 0.05 && fuel _heli < 0.1) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\AFTFUEL.paa", "\fza_ah64_us\tex\UFD\AFTFUELLOW_C_co.paa"];
};
if (_heli animationphase "plt_apu" > 0.5 && getpos _heli # 2 >= 3) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\APUON.paa", "\fza_ah64_us\tex\UFD\APUON_A_co.paa"]
};
if (_heli getVariable "fza_ah64_irjamfail") then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\IRJAMFAIL.paa", "\fza_ah64_us\tex\UFD\IRJAMFAIL_C_co.paa"]
};
if (_heli getVariable "fza_ah64_rfjamfail") then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\RJAMFAIL.paa", "\fza_ah64_us\tex\UFD\RFJFAIL_C_co.paa"]
};
if (_heli getHit "radar" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\FCRFAIL.paa", ""]
};
if (_heli getHit "pnvs" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\PNVSFAIL.paa", ""]
};
if (_heli getHit "otochlaven" >= 0.9) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\GUNJAM.paa", ""]
};
if (_heli getHit "otocvez" >= 0.8) then {
	_wcas pushBack [WCA_CAUTION, "\fza_ah64_us\tex\MPD\GUNACTFAIL.paa", ""]
};

// ADVISORIES

if (_heli animationphase "gdoor" > 0 || _heli animationphase "pdoor" > 0) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\CANOPY.paa", "\fza_ah64_us\tex\UFD\CANOPYOPEN_A_co.paa"]
};
if (_heli animationphase "plt_apu" > 0.5 && getpos _heli # 2 < 3) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\APUON.paa", "\fza_ah64_us\tex\UFD\APUON_A_co.paa"]
};
if (_heli animationphase "plt_eng1_start" > 0 && _heli animationphase "plt_eng1_throttle" < 0.25) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\ENG1START.paa", "\fza_ah64_us\tex\UFD\ENG1START_A_co.paa"]
};
if (_heli animationphase "plt_eng2_start" > 0 && _heli animationphase "plt_eng2_throttle" < 0.25) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\ENG2START.paa", "\fza_ah64_us\tex\UFD\ENG2START_A_co.paa"]
};
if (isAutoHoverOn _heli) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\ATTHOLD.paa", "\fza_ah64_us\tex\UFD\ATTHLD_A_co.paa"]
};
if (_heli animationphase "plt_rtrbrake" == 1) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\RTRBRKON.paa", "\fza_ah64_us\tex\UFD\RTRBRKON_C_co.paa"]
};

if (_heli getVariable "fza_ah64_irjon" == 1 && fza_ah64_irjammer > 0) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\IRJAMOHEAT.paa", "\fza_ah64_us\tex\UFD\IRJOHEAT_A_co.paa"]
};
if (_heli getVariable "fza_ah64_rfjon" == 1 && fza_ah64_rfjammer > 0) then {
	_wcas pushBack [WCA_ADVISORY, "\fza_ah64_us\tex\MPD\RFJAMOHEAT.paa", "\fza_ah64_us\tex\UFD\RFJOHEAT_A_co.paa"]
};

_wcas;