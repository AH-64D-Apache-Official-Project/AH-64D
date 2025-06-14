params["_name", "_value"];
if !(vehicle player isKindOf "fza_ah64base") exitWith {};
private _heli = vehicle player;

//private _heliCyclicForwardOut   = _heli getVariable "fza_sfmplus_heliCyclicForwardOut";
//private _heliCyclicBackOut      = _heli getVariable "fza_sfmplus_heliCyclicBackOut";
//private _heliCyclicLeftOut      = _heli getVariable "fza_sfmplus_heliCyclicLeftOut";  
//private _heliCyclicRightOut     = _heli getVariable "fza_sfmplus_heliCyclicRightOut";
//private _heliRudderLeftOut      = _heli getVariable "fza_sfmplus_heliRudderLeftOut";
//private _heliRudderRightOut     = _heli getVariable "fza_sfmplus_heliRudderRightOut";
private _heliCollectiveRaiseOut = _heli getVariable "fza_sfmplus_heliCollectiveRaiseOut";
private _heliCollectiveLowerOut = _heli getVariable "fza_sfmplus_heliCollectiveLowerOut";     

if (_value) then {
    //When button pressed
    switch (_name) do {
        //case "fza_ah64_cyclicForward": {
        //    systemChat format ["KEYBOARD Fwd"];
        //};
        //case "fza_ah64_cyclicBackward": {
        //    systemChat format ["KEYBOARD Back"];
        //};
        //case "fza_ah64_cyclicLeft": {
        //    systemChat format ["KEYBOARD Cyclic Left"];
        //};
        //case "fza_ah64_cyclicRight": {
        //    systemChat format ["KEYBOARD Cyclic Right"];
        //};
        //case "fza_ah64_pedalLeft": {
        //    systemChat format ["KEYBOARD Pedal Left"];
        //};
        //case "fza_ah64_pedalRight": {
        //    systemChat format ["KEYBOARD Pedal Right"];
        //};
        case "fza_ah64_collectiveUp": {
            _heliCollectiveRaiseOut = _heliCollectiveRaiseOut + 0.005;
            _heliCollectiveRaiseOut = [_heliCollectiveRaiseOut, 0.0, 1.0] call BIS_fnc_clamp;
            _heli setVariable ["fza_sfmplus_heliCollectiveRaiseOut", _heliCollectiveRaiseOut];
            systemChat format ["_heliCollectiveRaiseOut = %1", _heliCollectiveRaiseOut];
        };
        case "fza_ah64_collectiveDn": {
            _heliCollectiveLowerOut = _heliCollectiveLowerOut + 0.005;
            _heliCollectiveLowerOut = [_heliCollectiveLowerOut, 0.0, 1.0] call BIS_fnc_clamp;
            _heli setVariable ["fza_sfmplus_heliCollectiveLowerOut", _heliCollectiveLowerOut];
            systemChat format ["_heliCollectiveLowerOut = %1", _heliCollectiveLowerOut];
        };
    };
};

if !(_value) then {
    //When button releassed
    switch (_name) do {
        //case "fza_ah64_cyclicForward": {
        //};
        //case "fza_ah64_cyclicBackward": {
        //};
        //case "fza_ah64_cyclicLeft": {
        //};
        //case "fza_ah64_cyclicRight": {
        //};
        //case "fza_ah64_pedalLeft": {
        //};
        //case "fza_ah64_pedalRight": {
        //};
        case "fza_ah64_collectiveUp": {
            //_heli setVariable ["fza_sfmplus_heliCollectiveRaiseOut", 0.0];
        };
        case "fza_ah64_collectiveDn": {
            //_heli setVariable ["fza_sfmplus_heliCollectiveLowerOut", 0.0];
        };        
    };
};