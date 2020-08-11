#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

switch (fza_ah64_cmsel) do {
	case 0;
	case 1: {;
		_heli setobjecttexture [SEL_MPD_PR_ASE_CSEL, "\fza_ah64_us\tex\mpd\chaff.paa"];
		[_heli, fza_ah64_chaffcount, SEL_DIGITS_MPD_PR_ASE_CC, "\fza_ah64_us\tex\char\g"] call fza_fnc_drawNumberSelections;
		_heli setobjecttexture [SEL_MPD_PR_ASE_CSEL, "\fza_ah64_us\tex\mpd\chaff.paa"];
		if (fza_ah64_cmsel == 1) then {
			_heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, "\fza_ah64_us\tex\char\g4_ca.paa"];
		} else {
			_heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, "\fza_ah64_us\tex\char\g1_ca.paa"];
		};
	};
	case 2;
	case 3:  {
		_heli setobjecttexture [SEL_MPD_PR_ASE_CSEL, "\fza_ah64_us\tex\mpd\chaff.paa"];
		[_heli, fza_ah64_flarecount, SEL_DIGITS_MPD_PR_ASE_CC, "\fza_ah64_us\tex\char\g"] call fza_fnc_drawNumberSelections;
		_heli setobjecttexture [SEL_MPD_PR_ASE_CSEL, ""];
		if (fza_ah64_cmsel == 3) then {
			_heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, "\fza_ah64_us\tex\char\g4_ca.paa"];
		} else {
			_heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, "\fza_ah64_us\tex\char\g1_ca.paa"];
		};
	};
};

[_heli, round getDir _heli, SEL_DIGITS_MPD_PR_TSD_HDG] call fza_fnc_drawNumberSelections;

private _aserange = (abs(1 / fza_ah64_rangesetting)) * 0.001;
[_heli, _aserange, SEL_DIGITS_MPD_PR_ASE_DIST, "\fza_ah64_us\tex\char\g"] call fza_fnc_drawNumberSelections;

_heli setObjectTexture [SEL_MPD_PR_ASE_AUTPG,
	switch (fza_ah64_aseautopage) do {
		case 0 : { "\fza_ah64_us\tex\mpd\ase_off.paa" };
		case 1 : { "\fza_ah64_us\tex\mpd\ase_track.paa" };
		case 2 : { "\fza_ah64_us\tex\mpd\ase_launch.paa" };
	}
];

_heli setObjectTexture [SEL_MPD_PR_ASE_RJOFF, if (fza_ah64_rfjon == 0) then {"\fza_ah64_us\tex\mpd\OFF.paa"} else {""}];
_heli setObjectTexture [SEL_MPD_PR_ASE_RJAUT, if (fza_ah64_rfjstate == 1) then {"\fza_ah64_us\tex\mpd\STBY.paa"} else {""}];
_heli setObjectTexture [SEL_MPD_PR_ASE_RJON, if (fza_ah64_rfjon == 1) then {"\fza_ah64_us\tex\mpd\OPER.paa"} else {""}];

_heli setObjectTexture [SEL_MPD_PR_ASE_IJOFF, if (fza_ah64_irjon == 0) then {"\fza_ah64_us\tex\mpd\OFF.paa"} else {""}];
_heli setObjectTexture [SEL_MPD_PR_ASE_IJAUT, if (fza_ah64_irjstate == 1) then {"\fza_ah64_us\tex\mpd\STBY.paa"} else {""}];
_heli setObjectTexture [SEL_MPD_PR_ASE_IJON, if (fza_ah64_irjon == 1) then {"\fza_ah64_us\tex\mpd\OPER.paa"} else {""}];

private _firstSelection = if (driver _heli == player) then {SEL_MPD_PL_OBJ1} else {SEL_MPD_GR_OBJ1};
private _lastSelection = if (driver _heli == player) then {SEL_MPD_PL_OBJ32} else {SEL_MPD_GR_OBJ32};

private ["_sel", "_iconPrefix", "_iconSuffix", "_heading", "_distance", "_x", "_y"];
private _seat = if (driver _heli == player) then {"pl"} else {"gr"};

private _objects = fza_ah64_asethreats apply {
	private _iconformat = "\fza_ah64_US\tex\ICONS\U";
	private _iconsuffix = "D.paa";
	private _priority = 0;

	if (_x iskindof "ZSU_Base") then {
		_iconformat = "\fza_ah64_US\tex\ICONS\23";
	};
	if (_x iskindof "2S6M_Tunguska") then {
		_iconformat = "\fza_ah64_US\tex\ICONS\19";
	};

	if (_heli == assignedTarget _x || _x AimedAtTarget[_heli] > 0.5) then {
		_iconsuffix = "T.paa";
	};
	if (_x in fza_ah64_threatfiring) then {
		_iconsuffix = "L.paa";
		_priority = 1;
	};

	[_x, _iconformat + _iconsuffix, _priority];
};

[_heli, _objects, true] call fza_fnc_mpdUpdatePoints;