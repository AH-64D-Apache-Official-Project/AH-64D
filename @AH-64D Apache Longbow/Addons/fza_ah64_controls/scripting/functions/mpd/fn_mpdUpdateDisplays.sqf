/* ----------------------------------------------------------------------------
Function: fza_fnc_mpdUpdateDisplays

Description:
	Updates the MPDs inside the apache to show the correct visuals. Should be run regularly.

Parameters:
	_heli - the apache to show the correct values for.

Returns:
	Nothing.

Examples:
    --- Code
	[_heli] call fza_fnc_mpdUpdateDisplays
    ---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

(_heli getVariable "fza_ah64_mpdPage") params ["_lmpdNext", "_rmpdNext"];
(_heli getVariable "fza_ah64_mpdCurrPage") params ["_lmpdCurr", "_rmpdCurr"];

if (!(_heli getVariable "fza_ah64_battery") && (_lmpdCurr != "OFF" || _rmpdCurr != "OFF")) then {
	[_heli, 1, "off"] call fza_fnc_mpdSetDisplay;
	[_heli, 0, "off"] call fza_fnc_mpdSetDisplay;
};
if (_heli getVariable "fza_ah64_battery" && (_lmpdCurr == "OFF" || _rmpdCurr == "OFF")) then {
	[_heli, 0, "fuel"] call fza_fnc_mpdSetDisplay;
	[_heli, 1, "eng"] call fza_fnc_mpdSetDisplay;
};

// Left MPD checks

if (_lmpdNext != _lmpdCurr) then {
	// If the page has been changed since the last update.
	switch (_lmpdCurr) do {
		case "dms" : { [_heli] call fza_fnc_mpdLDMSDestruct; };
		case "flt" : { [_heli] call fza_fnc_mpdLFLTDestruct; };
		case "fuel" : { [_heli] call fza_fnc_mpdLFUELDestruct; };
		case "wca" : { [_heli] call fza_fnc_mpdLWCADestruct; };
		case "wpn" : { [_heli] call fza_fnc_mpdLWPNDestruct; };
	};
	switch (_lmpdNext) do {
		case "dms" : { [_heli] call fza_fnc_mpdLDMSInit; };
		case "flt" : { [_heli] call fza_fnc_mpdLFLTInit; };
		case "fuel" : { [_heli] call fza_fnc_mpdLFUELInit; };
		case "wca" : { [_heli] call fza_fnc_mpdLWCAInit; };
		case "wpn" : { [_heli] call fza_fnc_mpdLWPNInit; };
	};
	_lmpdCurr = _lmpdNext;
};

switch (_lmpdCurr) do {
	case "dms" : { [_heli] call fza_fnc_mpdLDMSDraw; };
	case "flt" : { [_heli] call fza_fnc_mpdLFLTDraw; };
	case "fuel" : { [_heli] call fza_fnc_mpdLFUELDraw; };
	case "wca" : { [_heli] call fza_fnc_mpdLWCADraw; };
	case "wpn" : { [_heli] call fza_fnc_mpdLWPNDraw; };
};

// Right MPD checks

if (_rmpdNext != _rmpdCurr) then {
	// If the page has been changed since the last update.
	switch (_rmpdCurr) do {
		case "ase" : { [_heli] call fza_fnc_mpdRASEDestruct; };
		case "dms" : { [_heli] call fza_fnc_mpdRDMSDestruct; };
		case "eng" : { [_heli] call fza_fnc_mpdRENGDestruct; };
		case "fcr" : { [_heli] call fza_fnc_mpdRFCRDestruct; };
		case "tsd" : { [_heli] call fza_fnc_mpdRTSDDestruct; };
		case "wca" : { [_heli] call fza_fnc_mpdRWCADestruct; };
	};
	switch (_rmpdNext) do {
		case "ase" : { [_heli] call fza_fnc_mpdRASEInit; };
		case "dms" : { [_heli] call fza_fnc_mpdRDMSInit; };
		case "eng" : { [_heli] call fza_fnc_mpdRENGInit; };
		case "fcr" : { [_heli] call fza_fnc_mpdRFCRInit; };
		case "tsd" : { [_heli] call fza_fnc_mpdRTSDInit; };
		case "wca" : { [_heli] call fza_fnc_mpdRWCAInit; };
	};
	_rmpdCurr = _rmpdNext;
};

switch (_rmpdCurr) do {
	case "ase" : { [_heli] call fza_fnc_mpdRASEDraw; };
	case "dms" : { [_heli] call fza_fnc_mpdRDMSDraw; };
	case "eng" : { [_heli] call fza_fnc_mpdRENGDraw; };
	case "fcr" : { [_heli] call fza_fnc_mpdRFCRDraw; };
	case "tsd" : { [_heli] call fza_fnc_mpdRTSDDraw; };
	case "wca" : { [_heli] call fza_fnc_mpdRWCADraw; };
};

_heli setVariable ["fza_ah64_mpdCurrPage", [_lmpdCurr, _rmpdCurr]];