#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

//Collective to pitch - compensates for rotor downwash on stabilator <- Not currently used or simulated in helisim
//Collective to roll  - compensates for translating tendency (right rolling moment). Applies left cyclic w/ increased collective.
//Collective to yaw   - compensates for torque effect. Increase colletive, increases left pedal.
//Yaw to pitch        - not used in ah64, used in uh-60, compensates for canted tail rotor. Applies aft cyclic with left pedal, and forward cyclic with right pedal
//Collective airspeed to yaw - helps compensate for torque effect in addition to collective to yaw mechanical mixing by increasing or decreasing tail rotor 
//                             pitch by the use of the yaw trim actuator. Is a function of the SAS/FPS computer. 0 to 40 knots 100% tail rotor mixing, from 
//                             40 to 100 knots goes from 100% to 0% tail rotor mixing
//Yaw to Roll          - compensates for fuselage roll when pedal is applied. This is a keboard only function.
private _gndSpeed   = (_heli getVariable "fza_sfmplus_gndSpeed") * KNOTS_TO_MPS;
private _pedalInput = _heli getVariable "fza_sfmplus_pedalLeftRight";
private _pedalTrim  = _heli getVariable "fza_ah64_forceTrimPosPedal";
private _pedalOut   = _pedalInput + _pedalTrim;
private _collOut    = _heli getVariable "fza_sfmplus_collectiveOutput";
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective To Pitch  /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _collToPitchTable = //move to config!
[
 [0.0, 0.000]
,[0.1, 0.009]
,[0.2, 0.018]
,[0.3, 0.027]
,[0.4, 0.036]
,[0.5, 0.045]
,[0.6, 0.054]
,[0.7, 0.063]
,[0.8, 0.072]
,[0.9, 0.081]
,[1.0, 0.090]
];
private _collToPitch = [_collToPitchTable, _collOut] call fza_fnc_linearInterp select 1;
_collToPitch         = linearConversion [0, 20.58, _gndSpeed, _collToPitch, 0.0, true];
//systemChat format ["_collToPitch = %1", _collToPitch];
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective To Roll   /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _collToRollTable = //move to config!
[
 [0.0, 0.000]
,[0.1, 0.009]
,[0.2, 0.018]
,[0.3, 0.026]
,[0.4, 0.035]
,[0.5, 0.044]
,[0.6, 0.053]
,[0.7, 0.062]
,[0.8, 0.070]
,[0.9, 0.079]
,[1.0, 0.088]
];
private _collToRoll = [_collToRollTable, _collOut] call fza_fnc_linearInterp select 1;
/*
SPD_TBL = 
[ 
 [  0.00, 1.00] //0kts
,[ 20.58, 1.00] //40kts
,[ 51.44, 0.54] //100kts 
,[ 66.88, 0.66] //130kts
,[ 77.17, 0.66] //150kts
];
*/
private _speedToRollTable = //move to config!
[ 
 [  0.00, 1.00] //0kts
,[ 20.58, 1.00] //40kts
,[ 51.44, 0.54] //100kts 
,[ 66.88, 0.66] //130kts
,[ 77.17, 0.66] //150kts
];
_collToRoll = _collToRoll * ([_speedToRollTable, _gndSpeed] call fza_fnc_linearInterp select 1);
//systemChat format ["_collToRoll = %1", _collToRoll];
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective To Yaw    /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _collToYaw = 0.0;
/////////////////////////////////////////////////////////////////////////////////////////////
// Yaw To Pitch         /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _yawToPitchTable = //move to config!
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
private _yawToPitch = [_yawToPitchTable, _pedalOut] call fza_fnc_linearInterp select 1;
//systemChat format ["_yawToPitch = %1", _yawToPitch];
/////////////////////////////////////////////////////////////////////////////////////////////
// Yaw To Roll         /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _yawToRollTable = //move to config!
[
 [-1.0,  0.244]
,[-0.9,  0.220]
,[-0.8,  0.195]
,[-0.7,  0.171]
,[-0.6,  0.146]
,[-0.5,  0.122]
,[-0.4,  0.098]
,[-0.3,  0.073]
,[-0.2,  0.049]
,[-0.1,  0.024]
,[ 0.0,  0.000]
,[ 0.1, -0.024]
,[ 0.2, -0.049]
,[ 0.3, -0.073]
,[ 0.4, -0.098]
,[ 0.5, -0.122]
,[ 0.6, -0.146]
,[ 0.7, -0.171]
,[ 0.8, -0.195]
,[ 0.9, -0.220]
,[ 1.0, -0.244]
];
private _yawToRoll = 0.0;

if (fza_ah64_sfmPlusAutoPedal) then {
    _yawToRoll = [_yawToRollTable, _pedalOut] call fza_fnc_linearInterp select 1;
};

//systemChat format ["_yawToRoll = %1", _yawToRoll];
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective Airspeed to Yaw ///////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _collAirspeedToYaw = 0.0;

[_collToPitch, _collToRoll, _collToYaw, _yawToPitch, _yawToRoll, _collAirspeedToYaw];