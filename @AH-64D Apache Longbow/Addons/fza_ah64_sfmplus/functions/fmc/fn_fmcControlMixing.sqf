#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

private _gndSpeed = (_heli getVariable "fza_sfmplus_gndSpeed") * KNOTS_TO_MPS;

//Collective to pitch - compensates for rotor downwash on stabilator <- Not currently used or simulated in helisim
//Collective to roll  - compensates for translating tendency (right rolling moment). Applies left cyclic w/ increased collective.
//Collective to yaw   - compensates for torque effect. Increase colletive, increases left pedal.
//Yaw to pitch        - not used in ah64, used in uh-60, compensates for canted tail rotor. Applies aft cyclic with left pedal, and forward cyclic with right pedal
//Collective airspeed to yaw - helps compensate for torque effect in addition to collective to yaw mechanical mixing by increasing or decreasing tail rotor 
//                             pitch by the use of the yaw trim actuator. Is a function of the SAS/FPS computer. 0 to 40 knots 100% tail rotor mixing, from 
//                             40 to 100 knots goes from 100% to 0% tail rotor mixing
//Yaw to Roll          - compensates for fuselage roll when pedal is applied. 
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective To Pitch  /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////
// Collective To Roll   /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _collToRollTable = 
[
 [0.0, 0.00]
,[0.1, 0.01]
,[0.2, 0.02]
,[0.3, 0.03]
,[0.4, 0.04]
,[0.5, 0.05]
,[0.6, 0.06]
,[0.7, 0.07]
,[0.8, 0.08]
,[0.9, 0.09]
,[1.0, 0.10]
];
private _collOut    = _heli getVariable "fza_sfmplus_collectiveOutput";
private _collToRoll = [_collToRollTable, _collOut] call fza_fnc_linearInterp select 1;
_collToRoll         = linearConversion [0, 40, _gndSpeed, _collToRoll, 0.0, true];

//systemChat format ["_collToRoll = %1", _collToRoll];
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective To Yaw    /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////
// Yaw To Pitch         /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _yawToPitchTable = 
[
 [-1.0, -0.060]
,[-0.9, -0.054]
,[-0.8, -0.048]
,[-0.7, -0.042]
,[-0.6, -0.036]
,[-0.5, -0.030]
,[-0.4, -0.024]
,[-0.3, -0.018]
,[-0.2, -0.012]
,[-0.1, -0.006]
,[ 0.0,  0.000]
,[ 0.1,  0.006]
,[ 0.2,  0.012]
,[ 0.3,  0.018]
,[ 0.4,  0.024]
,[ 0.5,  0.030]
,[ 0.6,  0.036]
,[ 0.7,  0.042]
,[ 0.8,  0.048]
,[ 0.9,  0.054]
,[ 1.0,  0.060]
];
private _pedalOut   = _heli getVariable "fza_sfmplus_pedalLeftRight";
private _yawToPitch = [_yawToPitchTable, _pedalOut] call fza_fnc_linearInterp select 1;

//systemChat format ["_yawToPitch = %1", _yawToPitch];
/////////////////////////////////////////////////////////////////////////////////////////////
// Yaw To Roll         /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _yawToRollTable = 
[
 [-1.0,  0.167,  0.270]
,[-0.9,  0.150,  0.240]
,[-0.8,  0.133,  0.220]
,[-0.7,  0.117,  0.190]
,[-0.6,  0.100,  0.160]
,[-0.5,  0.083,  0.140]
,[-0.4,  0.067,  0.110]
,[-0.3,  0.050,  0.080]
,[-0.2,  0.033,  0.050]
,[-0.1,  0.017,  0.030]
,[ 0.0,  0.000,  0.000]
,[ 0.1, -0.017, -0.036]
,[ 0.2, -0.033, -0.072]
,[ 0.3, -0.050, -0.108]
,[ 0.4, -0.067, -0.144]
,[ 0.5, -0.083, -0.180]
,[ 0.6, -0.100, -0.216]
,[ 0.7, -0.117, -0.252]
,[ 0.8, -0.133, -0.288]
,[ 0.9, -0.150, -0.324]
,[ 1.0, -0.167, -0.360]
];
private _pedalOut  = _heli getVariable "fza_sfmplus_pedalLeftRight";
private _yawToRoll = 0.0;

if (fza_ah64_sfmPlusAutoPedal) then {
    _yawToRoll = [_yawToRollTable, _pedalOut] call fza_fnc_linearInterp select 2;
} else {
    _yawToRoll = [_yawToRollTable, _pedalOut] call fza_fnc_linearInterp select 1;
};

//systemChat format ["_yawToRoll = %1", _yawToRoll];
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective Airspeed to Yaw ///////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

[_collToPitch, _collToRoll, _collToYaw, _yawToPitch, _yawToRoll, _collAirspeedToYaw];