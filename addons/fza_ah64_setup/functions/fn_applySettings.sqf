/* ----------------------------------------------------------------------------
Function: fza_setup_fnc_applySettings

Description:
    Sets the player's own (client) value of each CBA setting, saved to the
    profile as the Addon Options menu does.

Parameters:
    _values - Setting name -> value <HASHMAP>

Returns:
    Setting name -> "ok", "unchanged", "locked" (the mission or server sets it), "invalid" or "missing" <HASHMAP>

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_values"];

private _results = createHashMap;
{
    private _setting = _x;
    private _value = _y;
    private _default = [_setting, "default"] call CBA_settings_fnc_get;
    private _result = switch (true) do {
        case (isNil "_default"): {"missing"};
        case (isNil "_value" || {!([_setting, _value] call CBA_settings_fnc_check)}): {"invalid"};
        case ((_setting call CBA_settings_fnc_priority) != "client"): {"locked"};
        case ([_setting, _value, 0, "client", true] call CBA_settings_fnc_set): {"ok"};
        default {"unchanged"};
    };
    _results set [_setting, _result];
} forEach _values;

_results
