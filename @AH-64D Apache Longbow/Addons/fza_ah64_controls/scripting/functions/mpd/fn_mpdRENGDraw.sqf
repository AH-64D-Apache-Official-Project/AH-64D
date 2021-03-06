#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

private _tgtTapeScaler = [[0,   0.00],
						  [400, 0.10],
						  [810, 0.60],
						  [811, 0.70],
						  [999, 1.00]
];
private _npTapeScaler  = [[0,   0.00],
    					  [96,  0.43],
    				 	  [99,  0.50],
    					  [100, 0.55],
    					  [102, 0.61],
    					  [105, 0.89],
    					  [120, 1.00]
];

private _isSingleEng = _heli getVariable "fza_ah64_isSingleEng";

// #region ENGINE 1
private _e1percent = (_heli getVariable "fza_sfmplus_engPctNP" select 0) * 100;
private _e1ng      = (_heli getVariable "fza_sfmplus_engPctNG" select 0) * 1000;
private _e1tgt     = _heli getVariable "fza_sfmplus_engTGT" select 0;
private _e1trq     = (_heli getVariable "fza_sfmplus_engPctTQ" select 0) * 100;
private _e1opsi    = (_heli getVariable "fza_sfmplus_engOilPSI" select 0) * 100;
if (_e1percent <= (0.37 * 100)) then {
	_e1trq = 0;
};

// #region TORQUE
private _e1trqChar = "\fza_ah64_us\tex\char\g";
private _e1trqTape = "\fza_ah64_us\tex\mpd\Gtape.paa";

if (_e1trq > 100 && _e1trq <= 115) then {
	_e1trqChar = "\fza_ah64_us\tex\char\y";
	_e1trqTape = "\fza_ah64_us\tex\mpd\Ytape.paa";
};
if (_e1trq > 115) then {
	_e1trqChar = "\fza_ah64_us\tex\char\r";
	_e1trqTape = "\fza_ah64_us\tex\mpd\Rtape.paa";
};
[_heli, _e1trq, _e1trqChar, SEL_DIGITS_MPD_PR_ENG_1TRQ] call fza_fnc_drawNumberSelections;
_heli setObjectTexture [SEL_MPD_PR_ENG_1TRQB, _e1trqTape];
// #endregion

// #region RPM
private _e1percentChar = "\fza_ah64_us\tex\char\g";
private _e1percentTape = "\fza_ah64_us\tex\mpd\Gtape.paa";

if (_e1percent >= 106 && _e1percent < 110) then {
	_e1percentChar = "\fza_ah64_us\tex\char\y";
	_e1percentTape = "\fza_ah64_us\tex\mpd\Ytape.paa";
};
if (_e1percent < 94 || _e1percent >= 110) then {
	_e1percentChar = "\fza_ah64_us\tex\char\g";
	_e1percentTape = "\fza_ah64_us\tex\mpd\Rtape.paa";
};
[_heli, _e1percent, _e1percentChar, SEL_DIGITS_MPD_PR_ENG_1NP] call fza_fnc_drawNumberSelections;
_heli setObjectTexture [SEL_MPD_PR_ENG_1NPB, _e1percentTape];
// #endregion

// #region TGT
private _e1tgtChar = "\fza_ah64_us\tex\char\g";
private _e1tgtTape = "\fza_ah64_us\tex\mpd\Gtape.paa";

if (_e1tgt > 810 && _e1tgt < 949) then {
	_e1tgtChar = "\fza_ah64_us\tex\char\y";
    _e1tgtTape = "\fza_ah64_us\tex\mpd\Ytape.paa";
};
if (_e1tgt >= 940) then {
	_e1tgtChar = "\fza_ah64_us\tex\char\r";
    _e1tgtTape = "\fza_ah64_us\tex\mpd\Rtape.paa";
};

[_heli, _e1tgt, _e1tgtChar, SEL_DIGITS_MPD_PR_ENG_1TGT] call fza_fnc_drawNumberSelections;
_heli setObjectTexture [SEL_MPD_PR_ENG_1TGTB, _e1tgtTape];
// #endregion

// #region NG
private _e1ngchar = "\fza_ah64_us\tex\char\g";
if (_e1ng > 1023 && _e1ng < 1051) then {
	_e1ngchar = "\fza_ah64_us\tex\char\y";
};
if (_e1ng < 630 || _e1ng > 1051) then {
	_e1ngchar = "\fza_ah64_us\tex\char\r";
};

[_heli, _e1ng, _e1ngchar, SEL_DIGITS_MPD_PR_ENG_E1NG] call fza_fnc_drawNumberSelections;

// #region animations
_heli animateSource["mpd_pr_eng_e1trq", _e1trq / 130.0];
_heli animateSource["mpd_pr_eng_1tgt", ([_tgtTapeScaler, _e1tgt] call fza_fnc_linearInterp)# 1];
_heli animateSource["mpd_pr_eng_e1np", ([_npTapeScaler, _e1percent] call fza_fnc_linearInterp)# 1];
// #endregion

// #endregion

// #endregion

// #region ENGINE 2
private _e2percent = (_heli getVariable "fza_sfmplus_engPctNP" select 1) * 100;
private _e2ng      = (_heli getVariable "fza_sfmplus_engPctNG" select 1) * 1000;
private _e2tgt     = _heli getVariable "fza_sfmplus_engTGT" select 1;
private _e2trq     = (_heli getVariable "fza_sfmplus_engPctTQ" select 1) * 100;
private _e2opsi    = (_heli getVariable "fza_sfmplus_engOilPSI" select 1) * 100;
if (_e2percent <= (0.37 * 100)) then {
	_e2trq = 0;
};

// #region TORQUE
private _e2trqChar = "\fza_ah64_us\tex\char\g";
private _e2trqTape = "\fza_ah64_us\tex\mpd\Gtape.paa";

if (_e2trq > 100 && _e2trq <= 115) then {
	_e2trqChar = "\fza_ah64_us\tex\char\y";
	_e2trqTape = "\fza_ah64_us\tex\mpd\Ytape.paa";
};
if (_e2trq > 115) then {
	_e2trqChar = "\fza_ah64_us\tex\char\r";
	_e2trqTape = "\fza_ah64_us\tex\mpd\Rtape.paa";
};
[_heli, _e2trq, _e2trqChar, SEL_DIGITS_MPD_PR_ENG_2TRQ] call fza_fnc_drawNumberSelections;
_heli setObjectTexture [SEL_MPD_PR_ENG_2TRQB, _e2trqTape];
// #endregion

// #region RPM
private _e2percentChar = "\fza_ah64_us\tex\char\g";
private _e2percentTape = "\fza_ah64_us\tex\mpd\Gtape.paa";

if (_e2percent >= 106 && _e2percent < 110) then {
	_e2percentChar = "\fza_ah64_us\tex\char\y";
	_e2percentTape = "\fza_ah64_us\tex\mpd\Ytape.paa";
};
if (_e2percent < 94 || _e2percent >= 110) then {
	_e2percentChar = "\fza_ah64_us\tex\char\g";
	_e2percentTape = "\fza_ah64_us\tex\mpd\Rtape.paa";
};
[_heli, _e2percent, _e2percentChar, SEL_DIGITS_MPD_PR_ENG_2NP] call fza_fnc_drawNumberSelections;
_heli setObjectTexture [SEL_MPD_PR_ENG_2NPB, _e2percentTape];
// #endregion

// #region TGT
private _e2tgtChar = "\fza_ah64_us\tex\char\g";
private _e2tgtTape = "\fza_ah64_us\tex\mpd\Gtape.paa";

if (_e2tgt > 810 && _e2tgt < 949) then {
	_e2tgtChar = "\fza_ah64_us\tex\char\y";
    _e2tgtTape = "\fza_ah64_us\tex\mpd\Ytape.paa";
};
if (_e2tgt >= 940) then {
	_e2tgtChar = "\fza_ah64_us\tex\char\r";
    _e2tgtTape = "\fza_ah64_us\tex\mpd\Rtape.paa";
};

[_heli, _e2tgt, _e2tgtChar, SEL_DIGITS_MPD_PR_ENG_2TGT] call fza_fnc_drawNumberSelections;
_heli setObjectTexture [SEL_MPD_PR_ENG_2TGTB, _e2tgtTape];
// #endregion

// #region NG
private _e2ngchar = "\fza_ah64_us\tex\char\g";
if (_e2ng > 1023 && _e2ng < 1051) then {
	_e2ngchar = "\fza_ah64_us\tex\char\y";
};
if (_e2ng < 630 || _e2ng > 1051) then {
	_e2ngchar = "\fza_ah64_us\tex\char\r";
};

[_heli, _e2ng, _e2ngchar, SEL_DIGITS_MPD_PR_ENG_E2NG] call fza_fnc_drawNumberSelections;
// #endregion

// #region animations
_heli animateSource["mpd_pr_eng_e2trq", _e2trq / 130.0];
_heli animateSource["mpd_pr_eng_2tgt", ([_tgtTapeScaler, _e2tgt] call fza_fnc_linearInterp)# 1];
_heli animateSource["mpd_pr_eng_e2np", ([_npTapeScaler, _e2percent] call fza_fnc_linearInterp)# 1];
// #endregion

// #region ROTORS
 
private _rotorRpm = _e1percent max _e2percent;

private _rotorRpmChar = "\fza_ah64_us\tex\char\g";
private _rotorRpmTape = "\fza_ah64_us\tex\mpd\Gtape.paa";

if (_rotorRpm >= 106 && _rotorRpm < 110) then {
	_rotorRpmChar = "\fza_ah64_us\tex\char\Y";
	_rotorRpmTape = "\fza_ah64_us\tex\mpd\Ytape.paa";
};
if (_rotorRpm < 94 || _rotorRpm >= 110) then {
	_rotorRpmChar = "\fza_ah64_us\tex\char\g";
	_rotorRpmTape = "\fza_ah64_us\tex\mpd\Rtape.paa";
};

//TODO: Change so sound occurs even if not in engine page
if (_rotorRpm > 110 && isengineon _heli && (getpos _heli select 2) > 5 && !fza_ah64_warnHighRpm) then {
    ["fza_ah64_bt_rotorrpm", 1.7, "fza_ah64_bt_high", 1] spawn fza_fnc_playAudio;
	fza_ah64_warnHighRpm = true;
};
if !(_rotorRpm > 110 && isengineon _heli && (getpos _heli select 2) > 5) then {
	fza_ah64_warnHighRpm = false;
};

[_heli, _rotorRpm, _rotorRpmChar, SEL_DIGITS_MPD_PR_ENG_RRPM] call fza_fnc_drawNumberSelections;
_heli setObjectTexture [SEL_MPD_PR_ENG_RTRRPMB, _rotorRpmTape];

// #region animations
_heli animateSource["mpd_pr_eng_rtrrpm", ([_npTapeScaler, _rotorRpm] call fza_fnc_linearInterp)# 1];
// #endregion

// #endregion

if (getpos _heli select 2 > 1) then {
	_heli setobjecttexture [SEL_MPD_PR_ENG_IFB, "\fza_ah64_us\tex\mpd\ifbox.paa"];
	_heli setobjecttexture [SEL_MPD_PR_ENG_OFB, ""];
	_heli setObjectTexture [SEL_MPD_PR_ENG_OIL1PSI1, ""];
	_heli setObjectTexture [SEL_MPD_PR_ENG_OIL1PSI2, ""];
	_heli setObjectTexture [SEL_MPD_PR_ENG_OIL1PSI3, ""];
	_heli setObjectTexture [SEL_MPD_PR_ENG_OIL2PSI1, ""];
	_heli setObjectTexture [SEL_MPD_PR_ENG_OIL2PSI2, ""];
	_heli setObjectTexture [SEL_MPD_PR_ENG_OIL2PSI3, ""];

	[_heli, 2970, "\fza_ah64_us\tex\char\g", SEL_DIGITS_MPD_PR_ENG_1PRIPSI] call fza_fnc_drawNumberSelections;
	[_heli, 2970, "\fza_ah64_us\tex\char\g", SEL_DIGITS_MPD_PR_ENG_1UTIPSI] call fza_fnc_drawNumberSelections;
	[_heli, 3000, "\fza_ah64_us\tex\char\g", SEL_DIGITS_MPD_PR_ENG_1ACCPSI] call fza_fnc_drawNumberSelections;
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_ENG_PRIPSI);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_ENG_UTIPSI);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_ENG_ACCPSI);
} else {
	_heli setobjecttexture [SEL_MPD_PR_ENG_IFB, ""];
	_heli setobjecttexture [SEL_MPD_PR_ENG_OFB, "\fza_ah64_us\tex\mpd\eng.paa"];
	
	// #region ENGINE 1 OIL PSI
	private _e1opsiChar = "\fza_ah64_us\tex\char\g";
	if (_e1opsi < 20 || _e1opsi > 95) then {
		_e1opsiChar = "\fza_ah64_us\tex\char\r";
	};
	[_heli, _e1opsi, _e1opsiChar, SEL_DIGITS_MPD_PR_ENG_OIL1PSI] call fza_fnc_drawNumberSelections;
	// #endregion

	// #region ENGINE 2 OIL PSI
	private _e2opsiChar = "\fza_ah64_us\tex\char\g";
	if (_e2opsi < 20 || _e2opsi > 95) then {
		_e2opsiChar = "\fza_ah64_us\tex\char\r";
	};
	[_heli, _e2opsi, _e2opsiChar, SEL_DIGITS_MPD_PR_ENG_OIL2PSI] call fza_fnc_drawNumberSelections;
	// #endregion

	[_heli, 2970, "\fza_ah64_us\tex\char\g", SEL_DIGITS_MPD_PR_ENG_PRIPSI] call fza_fnc_drawNumberSelections;
	[_heli, 2970, "\fza_ah64_us\tex\char\g", SEL_DIGITS_MPD_PR_ENG_UTIPSI] call fza_fnc_drawNumberSelections;
	[_heli, 3000 , "\fza_ah64_us\tex\char\g", SEL_DIGITS_MPD_PR_ENG_ACCPSI] call fza_fnc_drawNumberSelections;
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_ENG_1PRIPSI);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_ENG_1UTIPSI);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_ENG_1ACCPSI);
};
