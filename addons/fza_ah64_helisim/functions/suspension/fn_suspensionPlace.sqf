/* ----------------------------------------------------------------------------
Function: fza_suspension_fnc_suspensionPlace

Description:
    Sits the aircraft on its wheels at static compression, on the first frame the
    suspension runs. Arma places a helicopter by its collision hull, and the hull
    has no wheels, which starts the struts far past their stroke and launches the
    aircraft. Follows the ground under the three wheels, so it works on a slope.

    Leaves an airborne aircraft, or one rolling when its owner changes, alone.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_helisim\functions\suspension\suspension.hpp"

params ["_heli"];

//Not a tighter limit: the engine's drop at spawn already has it sliding at about 0.6 m/s.
(velocity _heli) params ["_velX", "_velY"];
if (vectorMagnitude [_velX, _velY, 0.0] > SUSP_PLACE_MAX_SPEED) exitWith {};

private _fnc_groundUnder = {
    params ["_pos", "_radius"];
    private _bottom = _heli modelToWorldWorld (_pos vectorAdd [0.0, 0.0, -_radius]);
    private _hits   = lineIntersectsSurfaces [
        _bottom vectorAdd [0.0, 0.0, SUSP_PLACE_RANGE],
        _bottom vectorAdd [0.0, 0.0, -SUSP_PLACE_RANGE],
        _heli, objNull, true, 1, "GEOM"
    ];
    [(_hits select 0) select 0, []] select (_hits isEqualTo [])
};
private _fnc_grounds = {
    [[SUSP_WHEEL_RIGHT, SUSP_MAIN_RADIUS], [SUSP_WHEEL_LEFT, SUSP_MAIN_RADIUS], [SUSP_WHEEL_TAIL, SUSP_TAIL_RADIUS]] apply {
        _x call _fnc_groundUnder
    }
};

private _grounds = call _fnc_grounds;
if (_grounds findIf {_x isEqualTo []} >= 0) exitWith {};

//The main wheels hang lower than the tail wheel, so the aircraft sits slightly nose up on flat ground.
private _drop = ((SUSP_WHEEL_TAIL select 2) - SUSP_TAIL_RADIUS) - ((SUSP_WHEEL_RIGHT select 2) - SUSP_MAIN_RADIUS);
private _nose = _drop atan2 ((SUSP_WHEEL_RIGHT select 1) - (SUSP_WHEEL_TAIL select 1));

//To the plane of the ground under the wheels, keeping the heading. Twice, because turning the
//aircraft moves its wheels over different ground.
for "_pass" from 1 to 2 do {
    _grounds params ["_right", "_left", "_tail"];
    private _mid    = (_right vectorAdd _left) vectorMultiply 0.5;
    private _across = vectorNormalized (_right vectorDiff _left);
    private _up     = vectorNormalized (_across vectorCrossProduct (_mid vectorDiff _tail));
    private _along  = vectorNormalized (_up vectorCrossProduct _across);
    _heli setVectorDirAndUp [
        (_along vectorMultiply (cos _nose)) vectorAdd (_up vectorMultiply (sin _nose)),
        (_up vectorMultiply (cos _nose)) vectorDiff (_along vectorMultiply (sin _nose))
    ];
    private _fresh = call _fnc_grounds;
    if (_fresh findIf {_x isEqualTo []} < 0) then { _grounds = _fresh; };
};

//Down or up, so the main wheels rest on the ground.
_grounds params ["_right", "_left"];
private _bottomR = _heli modelToWorldWorld (SUSP_WHEEL_RIGHT vectorAdd [0.0, 0.0, -SUSP_MAIN_RADIUS]);
private _bottomL = _heli modelToWorldWorld (SUSP_WHEEL_LEFT  vectorAdd [0.0, 0.0, -SUSP_MAIN_RADIUS]);
private _rise    = (((_right select 2) - (_bottomR select 2)) + ((_left select 2) - (_bottomL select 2))) * 0.5;
_heli setPosASL ((getPosASL _heli) vectorAdd [0.0, 0.0, _rise]);

_heli setVelocity [0.0, 0.0, 0.0];
_heli setAngularVelocity [0.0, 0.0, 0.0];

//At rest and at static compression, so the wheels take over with nothing to settle.
_heli setVariable ["fza_suspension_prevCompression", [SUSP_MAIN_SAG, SUSP_MAIN_SAG, SUSP_TAIL_SAG]];

//Held here until the mission's long frames have passed: see fza_suspension_fnc_suspensionUpdate.
_heli setVariable ["fza_suspension_heldPose", [getPosASL _heli, vectorDir _heli, vectorUp _heli]];
_heli setVariable ["fza_suspension_loadSteady", 0.0];
_heli setVariable ["fza_suspension_loadUntil", CBA_missionTime + SUSP_LOAD_MAX_TIME];
