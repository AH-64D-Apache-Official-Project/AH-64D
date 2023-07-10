params ["_heli"];

private _state     = _heli getVariable "fza_prestonai_heliState";
private _mode      = _heli getVariable "fza_prestonai_heliMode";
private _onGnd     = isTouchingGround _heli;
//private _battBusOn = _heli getVariable "fza_systems_battBusOn";
//private _apuOn     = _heli getVariable "fza_systems_apuOn";
//(_heli getVariable "fza_sfmplus_engState")
//    params ["_eng1State", "_eng2State"];
//private _engsOff   = true;
//if (_eng1State != "OFF" && _eng2State != "OFF") then {
//    _engsOff       = false;
//};

if (_mode == "GND") then {
    //Bring the aircraft up on the APU or perform a full Startup
    if (_state == "OFF") then {
        hintsilent format ["Preston Menu
                            \nAction One = N/A
                            \nAction Two = N/A
                            \n-------------------------
                            \nUp    = N/A
                            \nDown  = N/A
                            \nLeft  = Start APU
                            \nRight = Start Engines"];  
    };

    //If we're on APU power, we can shutdown the helicopter or Start the engines
    if (_state == "APU") then {
        hintsilent format ["Preston Menu
                            \nAction One = N/A
                            \nAction Two = N/A
                            \n-------------------------
                            \nUp    = N/A
                            \nDown  = N/A
                            \nLeft  = Shutdown APU
                            \nRight = Start Engines"];
    };

    //The APU is off, and the engines are on
    if (_state == "ON") then {
        hintsilent format ["Preston Menu
                            \nAction One = N/A
                            \nAction Two = Hvr
                            \n-------------------------
                            \nUp    = N/A
                            \nDown  = N/A
                            \nLeft  = Shutdown Engines
                            \nRight = N/A"];
    };
};

if (_mode == "HVR") then {
    hintsilent format ["Preston Menu
                        \nAction One = Gnd
                        \nAction Two = Trn
                        \n-------------------------
                        \nUp    = Climb
                        \nDown  = Descend
                        \nLeft  = Slide Left
                        \nRight = Slide Right"];
};