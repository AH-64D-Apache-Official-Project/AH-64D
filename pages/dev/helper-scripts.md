---
title: Helper scripts
tags: [contributing]
sidebar: ah64d_sidebar
permalink: dev-helper-scripts.html
folder: contributing
---

{% include warning.html content="These are scripts that are meant for developers and testers to use to debug this mod. These are **NOT** supported for general use and are only for debugging use. It could even crash your game!" %}

# Engine datalogger

Adds 3 options to your action menu to record the engine RPMs and torques. This can then be exported into CSV format, in the schema
| No. | Description | Units |
| --: | :-- | :-- |
| 1 | Game time since mission start | Seconds |
| 2 | Engine 1 RPM | RPM |
| 3 | Engine 2 RPM | RPM |
| 4 | Engine 1 Torque | Newton Meters |
| 5 | Engine 2 Torque | Newton Meters |

```sqf
_heli = vehicle player; 
 
mbs_buffer = [];
mbs_shouldRecord = false; 
 
_heli addAction ["<t color='#00ff00'>Start recording</t>", { 
    hint "Recording started";
    mbs_buffer = []; 
    mbs_shouldRecord = true; 
    _heli = vehicle player; 
    
    while {mbs_shouldRecord} do { 
        enginesRpmRTD _heli params [["_r1", -1], ["_r2", -1]]; 
        enginesTorqueRTD _heli params [["_t1", -1], ["_t2", -1]]; 
        _rec = [time, _r1, _r2, _t1, _t2] joinString ","; 
        mbs_buffer pushBack _rec; 
        hintSilent _rec; 
        sleep 0.01; 
    }; 
    hint "Recording stopped"; 
}
, nil, 1.5, true, true, "", "!mbs_shouldRecord"]; 

_heli addAction ["<t color='#ff0000'>Stop recording</t>", {mbs_shouldRecord = false;}, nil, 1.5, true, true, "", "mbs_shouldRecord"]; 
 
_heli addAction ["<t color='#ffff00'>Export data</t>", {
    copyToClipboard (mbs_buffer joinString toString [13, 10]); 
    hint "Copied to clipboard!"; 
}, nil, 1.5, true, false];
```

# Variable logging

Copies all variables with the prefix `fza_ah64` to the clipboard

```sqf
private _arr = ["GLOBAL VARIABLES:"]; 
{ 
    private _split = _x splitString "_"; 
    if (count _split >= 2) then { 
        if (_split # 0 == "fza" && _split # 1 == "ah64") then { 
            _arr pushBack (format ["%1 = %2", _x, currentNamespace getVariable _x]); 
        }; 
    }; 
} 
forEach (allVariables currentNamespace); 
_arr pushBack "APACHE VARIABLES:"; 
{ 
    private _split = _x splitString "_"; 
    if (count _split >= 2) then { 
        if (_split # 0 == "fza" && _split # 1 == "ah64") then { 
            _arr pushBack (format ["%1 = %2", _x, vehicle player getVariable _x]); 
        }; 
    }; 
} 
forEach (allVariables vehicle player); 
 
copyToClipboard (_arr joinString toString [13, 10])
```

# Auto engine startup

This is really not recommended, it jumps between engine states in a not supported way. Could theoretically to your apache literally blowing up on occasion.

```sqf
vehicle player animateSource ["plt_rtrbrake", 0];
vehicle player animate["plt_batt", 1];
vehicle player animate["plt_apu", 1];
vehicle player setVariable ["fza_sfmplus_engPowerLeverState",["FLY", "FLY"]];
vehicle player setVariable ["fza_sfmplus_engState",["ON", "ON"]];
vehicle player setVariable ["fza_ah64_estarted", true, true];
vehicle player animate["plt_eng1_throttle", 1];
vehicle player animate["plt_eng2_throttle", 1];
vehicle player engineon true;
vehicle player animate["plt_apu", 0];
```