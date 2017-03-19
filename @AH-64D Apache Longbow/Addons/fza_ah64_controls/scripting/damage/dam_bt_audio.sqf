//USAGE: _system = first message, _delay1 = delay from first message, _subsystem = second message
//_delay2 = delay from second message, _state = final message, _delay3 = final delay
if(!(alive player) || !(vehicle player isKindOf "fza_ah64base")) exitwith {};
_array = _this;
if(count _array < 3) then {_array = _array + ["",0,"",0];};
if(count _array < 5) then {_array = _array + ["",0];};
_system = _array select 0;
_delay1 = _array select 1;
_subsystem = _array select 2;
_delay2 = _array select 3;
_state = _array select 4;
_delay3 = _array select 5;

if(isNil "fza_ah64_bt_soundplay") then {fza_ah64_bt_soundplay = 0;};
waituntil{fza_ah64_bt_soundplay == 0;};
fza_ah64_bt_soundplay = 1;
if(!(_system == "")) then
{
playsound [_system,true];
sleep _delay1;
};
if(!(_subsystem == "")) then
{
playsound [_subsystem,true];
sleep _delay2;
};
if(!(_state == "")) then
{
playsound [_state,true];
sleep _delay3;
};

fza_ah64_bt_soundplay = 0;