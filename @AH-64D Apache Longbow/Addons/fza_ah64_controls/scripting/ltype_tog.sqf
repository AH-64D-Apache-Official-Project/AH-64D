params["_heli"];

_heli setVariable ["fza_ah64_ltype", 
    switch (_heli getVariable "fza_ah64_ltype") do {
        case "lobl.sqf": {
            "loaldir.sqf"
        };
        case "loaldir.sqf": {
            "loallo.sqf"
        };
        case "loallo.sqf": {
            "loalhi.sqf"
        };
        case "loalhi.sqf": {
            "lobl.sqf"
        };
    },
    true];