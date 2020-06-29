[
	"fza_ah64_enableCustomControls",
	"CHECKBOX",
	"Enable Custom Controls",
	"AH64D Apache",
	[true]
] call CBA_fnc_addSetting;

[
	"fza_ah64_rearmTime",
	"List",
	"Time taken to rearm",
	"AH64D Apache",
	[
		[0, 15, 30, 60, 120, 240],
		["Instant", "15 seconds", "30 seconds", "1 minute", "2 minutes", "4 minutes"],
		5
	]
] call CBA_fnc_addSetting;

