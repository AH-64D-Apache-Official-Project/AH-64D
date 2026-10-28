/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_pageENGProcedure

Description:
    The immediate action steps for the ENG page emergency format: those of the
    most urgent active warning that has them. HIGH ROTOR RPM has none. No
    brackets or commas: the MPD font draws them blank.

Parameters:
    _heli     - The helicopter
    _warnings - The MPD texts of the active warnings

Returns:
    [title, [step lines]], or [] when no active warning has steps

Examples:
    --- Code
    [_heli, ["ENGINE 1 FIRE"]] call fza_mpd_fnc_pageENGProcedure
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_warnings"];

private _onGnd     = [_heli] call bmkhs_fnc_stateOnGround;
private _condition = ["IN FLIGHT", "ON GROUND"] select _onGnd;
private _bottles   = [
    "PRI DISCH BUTTON - PRESS",
    "  IF FIRE BUTTON REMAINS ILLUMINATED",
    "RES DISCH BUTTON - PRESS"
];
private _engineFire = {
    params ["_engine"];
    [format ["ENGINE %1 FIRE %2", _engine, _condition], [
        [
            "AFFECTED ENGINE POWER LEVER -",
            "  OFF WHEN CONDITIONS PERMIT",
            "ILLUMINATED ENG FIRE BUTTON - PRESS"
        ] + _bottles + ["LAND AS SOON AS POSSIBLE"],
        [
            "EMER ENG SHUTDOWN",
            "ILLUMINATED ENG FIRE BUTTON - PRESS"
        ] + _bottles
    ] select _onGnd]
};
private _overspeed = {
    params ["_engine"];
    [format ["ENGINE %1 OVERSPEED - NP FAILED HIGH", _engine], [
        "COLLECTIVE - MAINTAIN NR WITHIN LIMITS",
        "  IF CONDITION PERSISTS",
        "AFFECTED ENGINE POWER LEVER -",
        "  RETARD TO EQUALIZE TORQUE",
        "LAND AS SOON AS PRACTICABLE"
    ]]
};

private _procedure = switch (true) do {
    case ("ENGINE 1 FIRE" in _warnings): {[1] call _engineFire};
    case ("ENGINE 2 FIRE" in _warnings): {[2] call _engineFire};
    case ("APU FIRE" in _warnings): {
        [format ["APU FIRE %1", _condition], [
            ["ILLUMINATED APU FIRE BUTTON - PRESS"] + _bottles + ["LAND AS SOON AS POSSIBLE"],
            ["APU - OFF", "ILLUMINATED APU FIRE BUTTON - PRESS"] + _bottles
        ] select _onGnd]
    };
    case ("AFT DECK FIRE" in _warnings): {
        ["AFT DECK FIRE", ["LAND AS SOON AS POSSIBLE"]]
    };
    case ("ENGINE 1 OUT" in _warnings && {"ENGINE 2 OUT" in _warnings}): {
        ["DUAL ENGINE FAILURE", ["AUTOROTATE", "WING STORES JETTISON - AS APPROPRIATE"]]
    };
    case ("ENGINE 1 OUT" in _warnings || {"ENGINE 2 OUT" in _warnings}): {
        ["SINGLE ENGINE FAILURE", ["WING STORES JETTISON - AS APPROPRIATE", "LAND AS SOON AS PRACTICABLE"]]
    };
    case ("LOW ROTOR RPM" in _warnings): {
        ["LOW ROTOR RPM - NP FAILED LOW", [
            "COLLECTIVE - MAINTAIN NR WITHIN LIMITS",
            "  IF CONDITION PERSISTS",
            "AFFECTED ENGINE POWER LEVER -",
            "  LOCKOUT THEN RETARD TO EQUALIZE TORQUE",
            "  IF MANUAL CONTROL IS NOT POSSIBLE",
            "AFFECTED ENGINE POWER LEVER - IDLE",
            "LAND AS SOON AS PRACTICABLE"
        ]]
    };
    case ("ENG1 OVSP" in _warnings): {[1] call _overspeed};
    case ("ENG2 OVSP" in _warnings): {[2] call _overspeed};
    case ("HYD FAILURE" in _warnings): {
        ["HYDRAULIC FAILURE", ["EMERG HYD BUTTON - PRESS ON", "LAND WITHOUT DELAY", "EMER ENG SHUTDOWN"]]
    };
    case ("TAIL ROTOR HYD" in _warnings): {
        ["TAIL ROTOR HYDRAULIC FAILURE", ["LAND AS SOON AS POSSIBLE"]]
    };
    default {[]};
};
if (_procedure isEqualTo []) exitWith {[]};

//Steps are numbered; an indented line continues or conditions the step above it
_procedure params ["_title", "_lines"];
private _step = 0;
[_title, _lines apply {
    if (_x select [0, 2] == "  ") then {_x} else {_step = _step + 1; format ["%1 %2", _step, _x]}
}]
