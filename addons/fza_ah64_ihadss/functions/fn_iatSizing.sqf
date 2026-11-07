/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatSizing

Description:
    The size of the IAT gates while the IAT switch is held: near the reticle
    from the press, then once held IAT_HOLD out to half the field of view
    across and back down again, over and over.

Parameters:
    _pressedAt - When the switch was pressed (CBA_missionTime)

Returns:
    Gate half size, a fraction of the field of view's half width

Examples:
    --- Code
    private _size = [_pressedAt] call fza_ihadss_fnc_iatSizing;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_pressedAt"];

private _held = CBA_missionTime - _pressedAt - IAT_HOLD;
if (_held < 0) exitWith {IAT_MIN_SIZE};
private _phase = (_held / IAT_SIZE_TIME) mod 2;
IAT_MIN_SIZE + (IAT_GATE_MAX - IAT_MIN_SIZE) * ([_phase, 2 - _phase] select (_phase > 1))
