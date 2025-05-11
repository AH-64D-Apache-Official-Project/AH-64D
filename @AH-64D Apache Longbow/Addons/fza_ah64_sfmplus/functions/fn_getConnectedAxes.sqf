params ["_heli"];

/////////////////////////////////////////////////////////////////////////////////////////////
// Cyclic Pitch Input   /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _heliCyclicForwardDevices = [];
{ 
    if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
        _heliCyclicForwardDevices pushBackUnique _x;
    };
} forEach actionKeysEx "HeliCyclicForward";

private _heliCyclicBackDevices = [];
{ 
    if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
        _heliCyclicBackDevices pushBackUnique _x;
    };
} forEach actionKeysEx "HeliCyclicBack";

private _heliCyclicForwardOut   = if ((count _heliCyclicForwardDevices) == 0) then { 1.0; } else {1.0 / (count _heliCyclicForwardDevices); };
private _heliCyclicBackOut      = if ((count _heliCyclicBackDevices) == 0)    then { 1.0; } else {1.0 / (count _heliCyclicBackDevices); };

_heli setVariable ["fza_sfmplus_heliCyclicForwardOut", _heliCyclicForwardOut];
_heli setVariable ["fza_sfmplus_heliCyclicBackOut",    _heliCyclicBackOut];
/////////////////////////////////////////////////////////////////////////////////////////////
// Cyclic Roll Input    /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _heliCyclicRightDevices = [];
{ 
    if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
        _heliCyclicRightDevices pushBackUnique _x;
    };
} forEach actionKeysEx "HeliCyclicRight";

private _heliCyclicLeftDevices = [];
{ 
    if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
        _heliCyclicLeftDevices pushBackUnique _x;
    };
} forEach actionKeysEx "HeliCyclicLeft";

private _heliCyclicRightOut     = if ((count _heliCyclicRightDevices) == 0) then { 1.0; } else {1.0 / (count _heliCyclicRightDevices); };
private _heliCyclicLeftOut      = if ((count _heliCyclicLeftDevices) == 0)  then { 1.0; } else {1.0 / (count _heliCyclicLeftDevices); };

_heli setVariable ["fza_sfmplus_heliCyclicRightOut", _heliCyclicRightOut];
_heli setVariable ["fza_sfmplus_heliCyclicLeftOut",  _heliCyclicLeftOut];
/////////////////////////////////////////////////////////////////////////////////////////////
// Pedal Input          /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _heliRudderRightDevices = [];
{ 
    if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
        _heliRudderRightDevices pushBackUnique _x;
    };
} forEach actionKeysEx "HeliRudderRight";

private _heliRudderLeftDevices = [];
{ 
    if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
        _heliRudderLeftDevices pushBackUnique _x;
    };
} forEach actionKeysEx "HeliRudderLeft";

private _heliRudderRightOut = if ((count _heliRudderLeftDevices) == 0)  then { 1.0; } else {1.0 / (count _heliRudderLeftDevices); };
private _heliRudderLeftOut  = if ((count _heliRudderRightDevices) == 0) then { 1.0; } else {1.0 / (count _heliRudderRightDevices); };

_heli setVariable ["fza_sfmplus_heliRudderRightOut", _heliRudderRightOut];
_heli setVariable ["fza_sfmplus_heliRudderLeftOut",  _heliRudderLeftOut];
/////////////////////////////////////////////////////////////////////////////////////////////
// Collective Input     /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _heliCollectiveRaiseDevices = [];
{ 
    if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
        _heliCollectiveRaiseDevices pushBackUnique _x;
    };
} forEach actionKeysEx "HeliCollectiveRaise";

private _heliCollectiveLowerDevices = [];
{ 
    if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
        _heliCollectiveLowerDevices pushBackUnique _x;
    };
} forEach actionKeysEx "HeliCollectiveLower";

private _heliCollectiveRaiseOut = if ((count _heliCollectiveLowerDevices) == 0) then { 1.0; } else {1.0 / (count _heliCollectiveLowerDevices); };
private _heliCollectiveLowerOut = if ((count _heliCollectiveRaiseDevices) == 0) then { 1.0; } else {1.0 / (count _heliCollectiveRaiseDevices); };

_heli setVariable ["fza_sfmplus_heliCollectiveRaiseOut", _heliCollectiveRaiseOut];
_heli setVariable ["fza_sfmplus_heliCollectiveLowerOut", _heliCollectiveLowerOut];