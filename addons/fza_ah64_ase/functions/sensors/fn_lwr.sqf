/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_lwr


Description:
    Proccessor function for the LASER WARNING RECIEVER. A laser designating the aircraft
    shows at its source's bearing. A beam rider, taken as an incoming command-guided
    missile, shows at its launcher as a launch. Laser ranging can't be detected.

Parameters:
    heli: Object - Vehicle the event handler is assigned to
    munitions: Array - missiles and rockets within ASE_MWS_RANGE (fza_ase_fnc_aseManager)
    mwsShown: Array - missiles the MWS shows, which aren't shown again as launches

Returns:
    [_lwrObjects, _lwrAudio]

Examples:
    [_heli, _munitions, _mwsShown] call fza_ase_fnc_lwr

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", ["_munitions", []], ["_mwsShown", []]];

[] params [["_lwrObjects",[]],["_LwrAudio",[]]];

private _icon = "RLWR_LSR_DES";

nearestObjects [_heli, ["lasertarget"], 15, false, true] apply {
    private _modelPos = vectorDir _x vectorMultiply -99999999;
    private _Worldpos = (getPos _heli) vectorAdd _modelPos;
    // The laser's elevation in the aircraft's frame, so it holds when the aircraft is pitched or banked
    (_heli vectorWorldToModelVisual _modelPos) call CBA_fnc_vect2Polar params ["_magnitude", "_azimuth", "_elevation"];
    if (abs(_elevation) < 45) then {
        _lwrObjects pushBack [ASE_LSR, _Worldpos, _icon];
        _LwrAudio pushBack [_x, "designating", "laser", _Worldpos];
    };
};

if (isNil "fza_ase_beamRider") then {fza_ase_beamRider = createHashMap;};
_munitions apply {
    private _type  = typeOf _x;
    private _rider = fza_ase_beamRider get _type;
    if (isNil "_rider") then {
        _rider = getNumber (configOf _x >> "manualControl") > 0;
        fza_ase_beamRider set [_type, _rider];
    };
    if (!_rider || {_x in _mwsShown}) then {continue;};
    private _launcher = vehicle ((getShotParents _x) param [0, objNull]);
    if (isNull _launcher || {_launcher == _heli}) then {continue;};
    if !([_heli, _x] call fza_ase_fnc_incoming) then {continue;};
    _lwrObjects pushBack [ASE_LNC, _launcher, _icon];
};

[_lwrObjects, _LwrAudio]
