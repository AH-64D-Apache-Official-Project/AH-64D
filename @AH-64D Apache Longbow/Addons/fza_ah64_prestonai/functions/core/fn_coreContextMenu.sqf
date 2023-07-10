params ["_heli"];

private _onGnd     = isTouchingGround _heli;
private _battBusOn = _heli getVariable "fza_systems_battBusOn";
private _apuOn     = _heli getVariable "fza_systems_apuOn";
(_heli getVariable "fza_sfmplus_engState")
    params ["_eng1State", "_eng2State"];
private _engsOff   = true;
if (_eng1State != "OFF" && _eng2State != "OFF") then {
    _engsOff       = false;
};

//Bring the aircraft up on the APU or perform a full Startup
if (!_battBusOn && _onGnd) then {
    hintsilent format ["Preston Menu
                        \nAction One = N/A
                        \nAction Two = N/A
                        \n-------------------------
                        \nUp    = N/A
                        \nDown  = N/A
                        \nLeft  = Start APU
                        \nRight = Start Engines"];

    _heli setVariable ["fza_prestonai_heliState", "OFF"];    
};

//If we're on APU power, we can shutdown the helicopter or Start the engines
if (_apuOn && _engsOff && _onGnd) then {
    hintsilent format ["Preston Menu
                        \nAction One = N/A
                        \nAction Two = N/A
                        \n-------------------------
                        \nUp    = N/A
                        \nDown  = N/A
                        \nLeft  = Shutdown APU
                        \nRight = Start Engines"];
    _heli setVariable ["fza_prestonai_heliState", "APU"];   
};

//The APU is off, and the engines are on
if (!_apuOn && !_engsOff) then {
    hintsilent format ["Preston Menu
                        \nAction One = N/A
                        \nAction Two = Hvr
                        \n-------------------------
                        \nUp    = N/A
                        \nDown  = N/A
                        \nLeft  = Shutdown Engines
                        \nRight = N/A"];
    _heli setVariable ["fza_prestonai_heliState", "ON"];   
}

