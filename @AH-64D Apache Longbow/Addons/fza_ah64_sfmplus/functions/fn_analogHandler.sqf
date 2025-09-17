params["_name", "_value"];
if !(vehicle player isKindOf "fza_ah64base") exitWith {};
private _heli = vehicle player;

private _heliCyclicForwardOut   = _heli getVariable "fza_sfmplus_heliCyclicForwardOut";
private _heliCyclicBackOut      = _heli getVariable "fza_sfmplus_heliCyclicBackwardOut";
private _heliCyclicLeftOut      = _heli getVariable "fza_sfmplus_heliCyclicLeftOut";  
private _heliCyclicRightOut     = _heli getVariable "fza_sfmplus_heliCyclicRightOut";
private _heliRudderLeftOut      = _heli getVariable "fza_sfmplus_heliRudderLeftOut";
private _heliRudderRightOut     = _heli getVariable "fza_sfmplus_heliRudderRightOut";
private _heliCollectiveRaiseOut = _heli getVariable "fza_sfmplus_heliCollectiveRaiseOut";
private _heliCollectiveLowerOut = _heli getVariable "fza_sfmplus_heliCollectiveLowerOut";     

//When button pressed
switch (_name) do {
    case "fza_ah64_cyclicForward": {
        private _heliCyclicForwardDevices = [];
        { 
            if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
                _heliCyclicForwardDevices pushBackUnique _x;
            };
        } forEach actionKeysEx "fza_ah64_cyclicForward";

        _heliCyclicForwardOut = if ((count _heliCyclicForwardDevices) == 0) then { 1.0; } else {1.0 / (count _heliCyclicForwardDevices); };
        _heliCyclicForwardOut = linearConversion [0.0, _heliCyclicForwardOut, _value, 0.0, 1.0, true];
        _heli setVariable ["fza_sfmplus_heliCyclicForwardOut", _heliCyclicForwardOut];
    };
    case "fza_ah64_cyclicBackward": {
        private _heliCyclicBackDevices = [];
        { 
            if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
                _heliCyclicBackDevices pushBackUnique _x;
            };
        } forEach actionKeysEx "fza_ah64_cyclicBackward";

        _heliCyclicBackOut = if ((count _heliCyclicBackDevices) == 0) then { 1.0; } else {1.0 / (count _heliCyclicBackDevices); };
        _heliCyclicBackOut = linearConversion [0.0, _heliCyclicBackOut, _value, 0.0, 1.0, true];
        _heli setVariable ["fza_sfmplus_heliCyclicBackwardOut", _heliCyclicBackOut];
    };
    case "fza_ah64_cyclicLeft": {
        private _heliCyclicLeftDevices = [];
        { 
            if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
                _heliCyclicLeftDevices pushBackUnique _x;
            };
        } forEach actionKeysEx "fza_ah64_cyclicLeft";

        _heliCyclicLeftOut = if ((count _heliCyclicLeftDevices) == 0)  then { 1.0; } else {1.0 / (count _heliCyclicLeftDevices); };
        _heliCyclicLeftOut = linearConversion [0.0, _heliCyclicLeftOut, _value, 0.0, 1.0, true];
        _heli setVariable ["fza_sfmplus_heliCyclicLeftOut",  _heliCyclicLeftOut];        
    };
    case "fza_ah64_cyclicRight": {
        private _heliCyclicRightDevices = [];
        { 
            if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
                _heliCyclicRightDevices pushBackUnique _x;
            };
        } forEach actionKeysEx "fza_ah64_cyclicRight";

        private _heliCyclicRightOut = if ((count _heliCyclicRightDevices) == 0) then { 1.0; } else {1.0 / (count _heliCyclicRightDevices); };
        _heliCyclicRightOut         = linearConversion [0.0, _heliCyclicRightOut, _value, 0.0, 1.0, true];
        _heli setVariable ["fza_sfmplus_heliCyclicRightOut", _heliCyclicRightOut];
    };
    case "fza_ah64_pedalLeft": {
        private _heliRudderLeftDevices = [];
        { 
            if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
                _heliRudderLeftDevices pushBackUnique _x;
            };
        } forEach actionKeysEx "fza_ah64_pedalLeft";

        _heliRudderLeftOut = if ((count _heliRudderLeftDevices) == 0) then { 1.0; } else {1.0 / (count _heliRudderLeftDevices); };
        _heliRudderLeftOut = linearConversion [0.0, _heliRudderLeftOut, _value, 0.0, 1.0, true];
        _heli setVariable ["fza_sfmplus_heliRudderLeftOut",  _heliRudderLeftOut];
    };
    case "fza_ah64_pedalRight": {
        private _heliRudderRightDevices = [];
        { 
            if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
                _heliRudderRightDevices pushBackUnique _x;
            };
        } forEach actionKeysEx "fza_ah64_pedalRight";

        _heliRudderRightOut = if ((count _heliRudderRightDevices) == 0)  then { 1.0; } else {1.0 / (count _heliRudderRightDevices); };
        _heliRudderRightOut = linearConversion [0.0, _heliRudderRightOut, _value, 0.0, 1.0, true];
        _heli setVariable ["fza_sfmplus_heliRudderRightOut", _heliRudderRightOut];
    };
    case "fza_ah64_collectiveUp": {
        fza_sfmplus_keyboardCollective = false;

        private _heliCollectiveRaiseDevices = [];
        { 
            if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
                _heliCollectiveRaiseDevices pushBackUnique _x;
            };
        } forEach actionKeysEx "fza_ah64_collectiveUp";

        _heliCollectiveRaiseOut = if ((count _heliCollectiveRaiseDevices) == 0) then { 1.0; } else {1.0 / (count _heliCollectiveRaiseDevices); };
        _heliCollectiveRaiseOut = linearConversion [0.0, _heliCollectiveRaiseOut, _value, 0.0, 1.0, true];
        
        _heli setVariable ["fza_sfmplus_heliCollectiveRaiseOut", _heliCollectiveRaiseOut];
    };
    case "fza_ah64_collectiveDn": {
        fza_sfmplus_keyboardCollective = false;

        private _heliCollectiveLowerDevices = [];
        { 
            if ("JOYSTICK_AXIS" in (_x select 0 select 1)) then {
                _heliCollectiveLowerDevices pushBackUnique _x;
            };
        } forEach actionKeysEx "fza_ah64_collectiveDn";
    
        _heliCollectiveLowerOut = if ((count _heliCollectiveLowerDevices) == 0) then { 1.0; } else {1.0 / (count _heliCollectiveLowerDevices); };
        _heliCollectiveLowerOut = linearConversion [0.0, _heliCollectiveLowerOut, _value, 0.0, 1.0, true];

        _heli setVariable ["fza_sfmplus_heliCollectiveLowerOut", _heliCollectiveLowerOut];
    };
};