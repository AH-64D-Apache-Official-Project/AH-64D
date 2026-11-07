/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatBounds

Description:
    The bounding box the IAT gates fit: of the object's fire geometry, which
    follows its hull or body, not the visual LOD's with its mirrors, antennas
    and room for animation. The whole model's for an object without one.

Parameters:
    _obj - The object

Returns:
    [min corner, max corner], model space

Examples:
    --- Code
    ([_obj] call fza_ihadss_fnc_iatBounds) params ["_p1", "_p2"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_obj"];

private _box = boundingBoxReal [_obj, "FireGeometry"];
if ((_box param [0, []]) isEqualTo (_box param [1, []])) then {_box = boundingBoxReal _obj};
[_box # 0, _box # 1]
