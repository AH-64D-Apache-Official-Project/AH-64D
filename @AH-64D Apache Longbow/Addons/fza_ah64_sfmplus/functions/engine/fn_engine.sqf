


params ["_heli", "_engNum"];
#include "\fza_ah64_sfmplus\headers\core.hpp";

private _ng_accel       = 6.0;
private _ng_decel       = 4.0;

private _np_motor_accel = 3.0;
private _np_motor_decel = 2.0;
private _np_start_accel = 2.0;
private _np_on_accel    = 10.0;

private _tgt_accel      = 100.0;
private _tgt_decel      = 90.0;
private _tgt_off_accel  = 0.2;
private _tgt_off_decel  = 0.1;

private _ng_motor       = 24.0;
private _ng_start       = 52.0;
private _ng_idle        = 67.4;
private _ng_fly         = 85.6;
private _ng_max         = 105.1;

private _np_motor       = 10.0;
private _np_idle        = 57.0;
private _np_gov         = 101.0;
private _np_max         = 121.0;

private _tgt_off        = 225.0;
private _tgt_start      = 641.0;
private _tgt_idle       = 445.0;
private _tgt_fly        = 517.0;
private _tgt_max        = 949.0;

private _fuelFlow_idle  = 125.0;    //lbs per hour
private _fuelFlow_fly   = 200.0;    //lbs per hour
private _tq_100pct      = 481.0;

//
private _isApuOn      = _heli getVariable "fza_systems_apuOn";
private _FAT          = _heli getVariable "fza_sfmplus_FAT";

private _isOEI        = _heli getVariable "fza_sfmplus_engIsOEI";
private _engState     = _heli getVariable "fza_sfmplus_engState_new"         select _engNum;
private _switchState  = _heli getVariable "fza_sfmplus_engStartSwitchState"  select _engNum;
private _throttlePos  = _heli getVariable "fza_sfmplus_engThrottlePos"       select _engNum;
private _pwrLvrState  = _heli getVariable "fza_sfmplus_engPowerLeverState"   select _engNum;

private _hasFuel      = _heli getVariable "fza_sfmplus_engHasFuel"           select _engNum;
private _isFuelCutoff = _heli getVariable "fza_sfmplus_engIsFuelCutoff"      select _engNum;
private _isStarting   = _heli getVariable "fza_sfmplus_engIsStarting"        select _engNum;
private _isMotoring   = _heli getVariable "fza_sfmplus_engIsMotoring"        select _engNum;
private _isOn         = _heli getVariable "fza_sfmplus_engIsOn"              select _engNum;

private _ng           = _heli getVariable "fza_sfmplus_engNg"                select _engNum;
private _ng_base      = 0.0;
private _ng_val       = 0.0;
private _np           = _heli getVariable "fza_sfmplus_engNp"                select _engNum;
private _np_val       = 0.0;
private _oil_psi      = _heli getVariable "fza_sfmplus_engOil_psi"           select _engNum;
private _oil_temp     = _heli getVariable "fza_sfmplus_engOil_temp"          select _engNum;
private _tgt          = _heli getVariable "fza_sfmplus_tgt"                  select _engNum;
private _tgt_val      = 0.0;
private _fuelFlow     = _heli getVariable "fza_sfmplus_fuelFlow"             select _engNum;
private _fuelFlow_val = 0.0;
private _tq_val       = 0.0;
private _tq_max       = 0.0;
private _tq_out       = _heli getVariable "fza_sfmplus_engTq_out"            select _engNum;
private _tq_req       = _heli getVariable "fza_sfmplus_engTq_req"            select _engNum;
private _tq_rtr       = _heli getVariable "fza_sfmplus_rtrEngTq";

if (_isOEI) then {
    _tq_max = _heli getVariable "fza_sfmplus_maxTQ_SE";
    _tq_req = _tq_rtr / _tq_100pct;
} else {
    _tq_max = _heli getVariable "fza_sfmplus_maxTQ_DE";
    _tq_req = (_tq_rtr / _tq_100pct) / 2.0;
};

if (fuel _heli == 0.0) then { 
    _hasFuel = false; 
} else {
    _hasFuel = true;
};

if (_pwrLvrState == PWR_LEVER_OFF) then {
    _isFuelCutoff = true;
} else {
    _isFuelCutoff = false;
};

if (_switchState == START_SWITCH_OFF) then {
    //_isMotoring = false;
    _isStarting = false;
};

if (_switchState == START_SWITCH_START) then { 
    _isStarting = true;
};

//if (_switchState == START_SWITCH_ORIDE) then { 
//    _isMotoring = true;
//    _isStarting = false;
//};

if (!_isOn && _isFuelCutoff && _isStarting) then {
    if (_engState == ENG_OFF) then {
        _engState = ENG_MOTORING;
    };
};

if (_isStarting) then {
    if (!_isOn && !_isFuelCutoff && _ng > 0.0) then {
        _engState = ENG_STARTING;
    };
};

if (_isFuelCutoff && _engState != ENG_MOTORING) then {
    _engState = ENG_OFF;
};

if (!_hasFuel) then {
    _engState = ENG_OFF;
};

private _droopFactor = 1 - (_tq_req / _tq_max);
_droopFactor         = [_droopFactor, -1.0, 0.0] call BIS_fnc_clamp;

switch(_engState) do {
    case ENG_OFF : {
        _isOn       = false;
        
        _ng       = [_ng, 0.0, _ng / 2.0 + 0.1, _ng / 2.0] call fza_sfmplus_fnc_seek;
        _np       = [_np, 0.0, _np / 2.0 + 0.1, _np / 2.0] call fza_sfmplus_fnc_seek;
        _oil_psi  = _np * 0.62;
        //_oil_temp = [_oil_temp, _FAT, (1 / 15.0) * fza_sfmplus_deltaTime] call BIS_fnc_lerp;        
        if (_tgt > _tgt_off) then {
            _tgt  = [_tgt, _tgt_off, _tgt_accel, _tgt_decel] call fza_sfmplus_fnc_seek;
        } else {
            _tgt  = [_tgt, 0.0, _tgt_off_accel, _tgt_off_decel] call fza_sfmplus_fnc_seek;
        };
        _fuelFlow = 0.0;
        _tq_out   = 0.0;
    };
    case ENG_ON : {
        _isOn         = true;

        _ng_base      = _ng_idle + ((_ng_fly - _ng_idle) * _throttlePos);
        _ng_val       = _ng_base + ((_ng_max - _ng_base) * fza_sfmplus_collectiveOutput);
        _np_val       = _np_idle + (_np_gov - _np_idle) * _throttlePos;
        _tgt_val      = _FAT + _tgt_idle + ((_tgt_fly - _tgt_idle) * _throttlePos) + (fza_sfmplus_collectiveOutput * 1000.0);
        _fuelFlow_val = _fuelFlow_idle * _np / _np_idle + (fza_sfmplus_collectiveOutput * 500.0);
        _tq_val       = (_tq_max * _tq_100pct) * _throttlePos;
        
        _ng       = [_ng, _ng_val, _ng_accel, _ng_decel] call fza_sfmplus_fnc_seek;
        _np       = [_np, _np_val + (_droopFactor * 100), _np_on_accel, _np_on_accel / 2.0] call fza_sfmplus_fnc_seek;
        _oil_psi  = _np * 0.62;
        //_oil_temp = [_oil_temp, _FAT, (1 / 15.0) * fza_sfmplus_deltaTime] call BIS_fnc_lerp;
        _tgt      = [_tgt, _tgt_val, _tgt_accel, _tgt_decel] call fza_sfmplus_fnc_seek;
        _fuelFlow = _fuelFlow_val;
        _tq_out   = [_tq_out, _tq_val, _np_on_accel, _np_on_accel / 2.0] call fza_sfmplus_fnc_seek;

        if (_isFuelCutoff) then { _engState = ENG_OFF;};
    };
    case ENG_STARTING : {
        if (_ng < _ng_start) then {
            _tgt_val      = _FAT + _tgt_start;
            _fuelFlow_val = _fuelFlow_idle * _np / _np_idle;
            _tq_val       = (_tq_max * _tq_100pct) * _throttlePos;

            _ng       = [_ng, _ng_idle, _ng_accel, _ng / 2.0] call fza_sfmplus_fnc_seek;
            _np       = [_np, _np_idle, _np_start_accel, _np / 2.0] call fza_sfmplus_fnc_seek;
            _oil_psi  = _np * 0.62;
            //_oil_temp = [_oil_temp, _FAT, (1 / _startTime) * fza_sfmplus_deltaTime] call BIS_fnc_lerp;
            _tgt      = [_tgt, _tgt_val, _tgt_accel, _tgt_decel] call fza_sfmplus_fnc_seek;
            _fuelFlow = _fuelFlow_val;
            _tq_out   = [_tq_out, _tq_val, _np_start_accel, _np / 2.0] call fza_sfmplus_fnc_seek;

            if (_isFuelCutoff) then { _engState = ENG_OFF; [_heli, _engNum] call fza_sfmplus_fnc_interactStartSwitch; };
            
        } else {
            _engState    = ENG_ON;
            _isOn        = true;
            _isStarting  = false;
            [_heli, _engNum] call fza_sfmplus_fnc_interactStartSwitch;
        };
    };
    case ENG_MOTORING : {
        _isOn     = false;

        _fuelFlow = 0.0;
        _ng       = [_ng, _ng_motor, _ng_accel, _ng / 2.0] call fza_sfmplus_fnc_seek;
        _np       = [_np, _np_motor, _np_motor_accel, _np / 2.0] call fza_sfmplus_fnc_seek;
        _oil_psi  = _np * 0.62;
        //_oil_temp = [_oil_temp, _FAT, (1 / 25.0) * fza_sfmplus_deltaTime] call BIS_fnc_lerp;
        _tgt      = [_tgt, 0.0, _tgt_accel, _tgt_decel] call fza_sfmplus_fnc_seek;

        _tq_val   = (_tq_max * _tq_100pct) * _throttlePos;
        _tq_out   = [_tq_out, _tq_val, _np_motor_accel, _np / 2.0] call fza_sfmplus_fnc_seek;

        if (!_isStarting) then {
            _engState = ENG_OFF;
        };
    };
};

[_heli, "fza_sfmplus_engHasFuel",      _engNum, _hasFuel,      true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engIsFuelCutoff", _engNum, _isFuelCutoff, true] call fza_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engNg",           _engNum, _ng,           true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engNp",           _engNum, _np,           true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engOil_psi",      _engNum, _oil_psi,      true] call fza_fnc_setArrayVariable;
//[_heli, "fza_sfmplus_engOil_temp", _engNum, _oil_temp, true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_tgt",             _engNum, _tgt,          true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_fuelFlow",        _engNum, _fuelFlow,     true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engTq_out",       _engNum, _tq_out,       true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engTq_req",       _engNum, _tq_req,       true] call fza_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engState_new",    _engNum, _engState,     true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engIsOn",         _engNum, _isOn,         true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engIsStarting",   _engNum, _isStarting,   true] call fza_fnc_setArrayVariable;

//systemChat format ["Eng %1 State = %2 -- Start Switch State = %3 -- Throttle Pos = %4", _engNum, _engState, _switchState, _throttlePos];
systemChat format ["Eng %5 State = %1, _hasFuel = %2, _isOn = %3, _isStarting = %4", _engState, _hasFuel, _isOn, _isStarting, _engNum];
//systemChat format ["Eng %1 _ng = %2 -- _np = %3 -- _oil_psi = %4 -- _tgt = %5 -- _fuelFlow = %6", _engNum, _ng toFixed 2, _np toFixed 2, _oil_psi toFixed 2, _tgt toFixed 0, _fuelFlow toFixed 0 ];
systemChat format ["Eng %1 _ng = %2 -- _np = %3 -- _tq = %4 -- _tgt = %5 -- _fuelFlow = %6", _engNum, _ng toFixed 2, _np toFixed 2, _tq_out toFixed 2, _tgt toFixed 0, _fuelFlow toFixed 0 ];