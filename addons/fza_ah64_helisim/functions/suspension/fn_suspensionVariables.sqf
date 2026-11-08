/* ----------------------------------------------------------------------------
Function: fza_suspension_fnc_suspensionVariables

Description:
    Seeds the suspension's state, and on the owner sets the parking brake and the
    tail wheel lock.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

//All local: only the owner runs the wheels, and a new owner starts these from clean.
_heli setVariable ["fza_suspension_prevCompression", [-1.0, -1.0, -1.0]];
_heli setVariable ["fza_suspension_heldPose",        []];
_heli setVariable ["fza_suspension_restTime",        0.0];
_heli setVariable ["fza_suspension_castorAngle",     0.0];
_heli setVariable ["fza_suspension_castorAnimated",  0.0];
_heli setVariable ["fza_suspension_placed",          false];
_heli setVariable ["fza_suspension_loadSteady",      -1.0];
_heli setVariable ["fza_suspension_loadUntil",       0.0];
_heli setVariable ["fza_suspension_gripBend",        [[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]]];

//These publish, so only the owner sets them: a machine joining mid-flight must not reset them.
//Every reader of them defaults to true.
if (!local _heli) exitWith {};

//True: the main wheels brake. Toggled in fn_coreControlHandle.
_heli setVariable ["fza_ah64_toggleParkingBrake", true, true];

//True: the lock is selected, and the pin holds the tail wheel once it is near centre. Toggled in
//fn_coreControlHandle.
_heli setVariable ["fza_ah64_tailWheelLock", true, true];
