#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

[_heli, direction _heli, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PR_TSD_HDG] call fza_fnc_drawNumberSelections;
[_heli, count fza_ah64_fcrlist, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PR_FCRAG_TNUM] call fza_fnc_drawNumberSelections;

if (fza_ah64_targlos == 0) then {
	_heli setobjecttexture [SEL_MPD_PR_MPD_HAD_MSG1, "\fza_ah64_us\tex\mpd\mpd_had_nolos.paa"];
} else {
	_heli setobjecttexture [SEL_MPD_PR_MPD_HAD_MSG1, ""];
};

if (fza_ah64_agmode == 1) then {
	_heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_US\tex\mpd\air.paa"];
	_heli setobjecttexture [SEL_MPD_PR_FCRAA_WIPER, "\fza_ah64_us\tex\mpd\air.paa"];
	_heli setobjecttexture [SEL_MPD_PR_FCRAG_WIPER, ""];
	_heli setobjecttexture [SEL_MPD_PR_MPD_HAD_APOS, ""];
	_heli setobjecttexture [SEL_MPD_PR_MPD_HAD_APOS2, ""];
} else {
	_heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_US\tex\mpd\grnd.paa"];
	_heli setobjecttexture [SEL_MPD_PR_FCRAA_WIPER, ""];
	_heli setobjecttexture [SEL_MPD_PR_FCRAG_WIPER, "fza_ah64_us\tex\mpd\grnd.paa"];
	_heli setobjecttexture [SEL_MPD_PR_MPD_HAD_APOS, "\fza_ah64_us\tex\mpd\gunlimit.paa"];
	_heli setobjecttexture [SEL_MPD_PR_MPD_HAD_APOS2, "\fza_ah64_us\tex\mpd\tads.paa"];
	_heli animate["mpd_pr_mpd_had_apos_v", (_heli animationphase "tads")];
	_heli animate["mpd_pr_mpd_had_apos_h", (_heli animationphase "tads_tur")];
};

private _targetsToDraw = fza_ah64_tsddisptargs apply {
	private _targetType = "gen";
	private _targetModifier = "";
	private _targetPriority = 0;

	if (_x isKindOf "helicopter") then {
		_targetType = "hc";
	};

	if (_x isKindOf "plane") then {
		_targicon = "ac";
	};

	if (_x isKindOf "tank") then {
		_targicon = "tnk";
	};

	if (_x isKindOf "car") then {
		_targicon = "whl";
	};

	if ([_x] call fza_fnc_targetIsADA) then {
		_targicon = "ada";
	};

	if (_x in fza_ah64_currentpfz) then {
		_targetModifier = "_pfz";
	};
	if (_x == fza_ah64_mycurrenttarget) then {
		_targetModifier = "_trk";
		_targetPriority = 1;
	};

	private _targIcon = format ["\fza_ah64_US\tex\ICONS\ah64_%1%2.paa", _targetType, _targetModifier];
	if (_x in fza_ah64_shotat_list) then {
		_targIcon = "\fza_ah64_US\tex\ICONS\ah64_shotat.paa";
	};

	[_x, _targicon, _targetPriority];
};

[_heli, _targetsToDraw, false] call fza_fnc_mpdUpdatePoints;