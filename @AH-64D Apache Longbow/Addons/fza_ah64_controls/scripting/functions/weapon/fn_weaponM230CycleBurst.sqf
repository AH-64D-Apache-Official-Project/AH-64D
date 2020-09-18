params ["_heli"];

if !(player == gunner _heli || player == driver _heli) exitWith {};

switch (_heli getVariable "fza_ah64_burst_limit") do {
    case 10: {
        _heli setVariable ["fza_ah64_burst_limit", 20];
    };
    case 20: {
        _heli setVariable ["fza_ah64_burst_limit", 50];
    };
    case 50: {
        _heli setVariable ["fza_ah64_burst_limit", 100];
    };
    case 100: {
        _heli setVariable ["fza_ah64_burst_limit", 10];
    };
};