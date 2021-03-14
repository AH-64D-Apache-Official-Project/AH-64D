_heli = _this select 0;
params["_heli", "_tank"];

_tankName = format ["fza_ah64_%1_leak", _tank];

if (_heli getVariable _tankName) exitWith {};

_heli setVariable [_tankName, true, true];
while {(alive _heli) && (damage _heli > 0.01) && _heli getVariable _tankName}
do {
    waituntil {
        player in _heli
    };
    _heli setfuel((fuel _heli) - 0.0003);
    sleep 0.1;
};