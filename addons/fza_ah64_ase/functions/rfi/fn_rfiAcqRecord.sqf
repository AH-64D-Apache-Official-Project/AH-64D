/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rfiAcqRecord

Description:
    The emitter ACQ RFI points at: the crew station's selected emitter while the RFI still reports it, else the
    No. 1 emitter

Parameters:
    _heli - the helicopter
    _seat - "plt" or "cpg"

Returns:
    fza_ah64_ase_rfiEmitters record, or [] with none

Examples:
    [_heli, "cpg"] call fza_ase_fnc_rfiAcqRecord

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_seat"];

private _emitters = _heli getVariable ["fza_ah64_ase_rfiEmitters", []];
private _selected = _heli getVariable ["fza_ah64_ase_rfiSel_" + _seat, objNull];
private _i = [-1, _emitters findIf {(_x # ASE_RFI_OBJ) isEqualTo _selected}] select !isNull _selected;
if (_i >= 0) exitWith {_emitters # _i};
_emitters param [0, []]
