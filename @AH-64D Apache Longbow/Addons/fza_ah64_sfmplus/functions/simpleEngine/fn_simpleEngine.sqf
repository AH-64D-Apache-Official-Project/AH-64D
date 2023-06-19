params ["_heli", "_engNum", "_deltaTime", "_refTq"];

private _ng_start      = 0.23;
private _ng_dropout    = 0.52;
private _ng_idle       = 0.674;
private _ng_fly        = 0.855;

private _tq_start      = 0.04;
private _tq_idle       = 0.09;
private _tq_fly        = 0.36;

private _idleDelayMax  = 1.0 ;
private _tgtDelay      = 0.05;
private _tqDelay       = 1.00;

private _np_idle_gnd   = 0.57;
private _np_idle_fly   = 0.94;
private _np_fly        = 1.01;

private _tgtNgTable    = [
                          [0.000,   0.0]
                         ,[0.674, 460.0]
                         ,[0.855, 540.0]
                         ,[1.050, 999.0]
                         ];

private _tqNgTable     = [
                          [0.000, 0.00]
                         ,[0.023, 0.09] 
                         ,[0.674, 0.18]
                         ,[0.855, 0.36]
                         ,[0.996, 1.34] 
                         ];

private _FAT               = _heli getVariable "fza_sfmplus_FAT";
private _state             = _heli getVariable "fza_sfmplus_simpleEng_state"         select _engNum;
private _isOn              = _heli getVariable "fza_sfmplus_simpleEng_isOn"          select _engNum;
private _isStarting        = _heli getVariable "fza_sfmplus_simpleEng_isStarting"    select _engNum;
private _isCutoff          = _heli getVariable "fza_sfmplus_simpleEng_isCutoff"      select _engNum;
private _starterBroken     = _heli getVariable "fza_sfmplus_simpleEng_starterBroken" select _engNum;
private _noFuel            = _heli getVariable "fza_sfmplus_simpleEng_noFuel"        select _engNum;
private _throttlePct       = _heli getVariable "fza_sfmplus_simpleEng_throttlePct"   select _engNum;
private _ng_pct            = _heli getVariable "fza_sfmplus_simpleEng_ng_pct"        select _engNum;
private _coreTemp_degC     = _heli getVariable "fza_sfmplus_simpleEng_coreTemp_degC" select _engNum;
private _tgt_degC          = _heli getVariable "fza_sfmplus_simpleEng_tgt_degC"      select _engNum;
private _outputTq          = _heli getVariable "fza_sfmplus_simpleEng_outputTq"      select _engNum;
private _xmsnOutputRPM_pct = _heli getVariable "fza_sfmplus_xmsnOutputRPM_pct";
private _pidEng            = _heli getVariable "fza_sfmplus_pid_engine" select _engNum;

//Transition to motor if the engine is off and the starter has been engaged.
if (!_isOn && _isStarting) then {
    if (_state == "OFF") then {
        _state = "MOTOR";
        [_heli, "fza_sfmplus_simpleEng_state", _engNum, _state, true] call fza_fnc_setArrayVariable;
    };
};
//If the engine is off and the fuel flow to the engine isn't cutoff, and the
//Ng is > 15%, transition to start.
if (!_isOn && !_isCutoff && (_ng_pct > 0.15)) then {
    _state = "START";
    [_heli, "fza_sfmplus_simpleEng_state", _engNum, _state, true] call fza_fnc_setArrayVariable;
};
//If the fuel flow is cutoff and the engine isn't motoring, then it's off
if (_isCutoff && (_state != "MOTOR")) then {
    _state = "OFF";
    [_heli, "fza_sfmplus_simpleEng_state", _engNum, _state, true] call fza_fnc_setArrayVariable;
};
//If there's no more fuel on board the aircraft, the engine is off
if (_noFuel) then {
    _state = "OFF";
    [_heli, "fza_sfmplus_simpleEng_state", _engNum, _state, true] call fza_fnc_setArrayVariable; 
};

switch (_state) do {
	case "OFF": {
        _isOn       = false;

        //Ng
        _ng_pct          = [_ng_pct, 0.0, _idleDelayMax * 2.5, _idleDelayMax * 5.0] call fza_fnc_expSeek;
        //TGT
        _coreTemp_degC   = [_coreTemp_degC, _FAT, 300, 400] call fza_fnc_expSeek;
        private _tgt_ng  = [_tgtNgTable, _ng_pct] call fza_fnc_linearInterp select 1;
        private _tgtGoal = if (_ng_pct > 0.20) then { _tgt_ng + 0.00; } else { _tgt_ng + ((0.20 - _ng_pct) / 0.20 * _coreTemp_degC); };
        _tgt_degC        = [_tgt_degC, _tgtGoal, _tgtDelay, _tgtDelay * 1.2] call fza_fnc_expSeek;
        //Torque
        _outputTq        = [_outputTq, 0.0, _tqDelay, _tqDelay] call fza_fnc_expSeek;
        _outputTq        = [_outputTq, 0.0, 1.32] call BIS_fnc_clamp;

        [_heli, "fza_sfmplus_simpleEng_isOn",          _engNum, _isOn,          true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_isStarting",    _engNum, _isStarting,    true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_ng_pct",        _engNum, _ng_pct,        true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_coreTemp_degC", _engNum, _coreTemp_degC, true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_tgt_degC",      _engNum, _tgt_degC,      true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_outputTq",      _engNum, _outputTq,      true] call fza_fnc_setArrayVariable;  
    };
    case "MOTOR": {
        _isOn       = false;
        //_isStarting = true;

        if (_starterBroken || !_isStarting) then {
            _isStarting = false;
            _state   = "OFF";
        };

        //Ng
        _ng_pct          = [_ng_pct, _ng_start, _idleDelayMax * 6.0, _idleDelayMax * 2.4] call fza_fnc_expSeek;
        //TGT
        _coreTemp_degC   = [_coreTemp_degC, _FAT, 300, 400] call fza_fnc_expSeek;
        private _tgt_ng  = [_tgtNgTable, _ng_pct] call fza_fnc_linearInterp select 1;
        private _tgtGoal = if (_ng_pct > 0.20) then { _tgt_ng + 0.00; } else { _tgt_ng + ((0.20 - _ng_pct) / 0.20 * _coreTemp_degC); };
        _tgt_degC        = [_tgt_degC, _tgtGoal, _tgtDelay, _tgtDelay * 1.2] call fza_fnc_expSeek;
        //Torque
        private _tqGoal  = [_tqNgTable, _ng_pct] call fza_fnc_linearInterp select 1;
        _tqGoal          = [_tqGoal, 0.0, 1.32] call BIS_fnc_clamp;  
        _outputTq        = [_outputTq, _tqGoal * 481.0, _tqDelay, _tqDelay] call fza_fnc_expSeek;

        [_heli, "fza_sfmplus_simpleEng_isOn",          _engNum, _isOn,          true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_isStarting",    _engNum, _isStarting,    true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_ng_pct",        _engNum, _ng_pct,        true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_state",         _engNum, _state,         true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_coreTemp_degC", _engNum, _coreTemp_degC, true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_tgt_degC",      _engNum, _tgt_degC,      true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_outputTq",      _engNum, _outputTq,      true] call fza_fnc_setArrayVariable;   
    };
    case "START": {
        if ((_ng_pct > 0.15) && !_noFuel) then {
            if (_ng_pct < _ng_dropout) then {
                //NG
                private _prev_ng_pct = _ng_pct;
                _ng_pct              = [_ng_pct, _ng_idle * 1.1, _idleDelayMax * 4.0, _idleDelayMax * 2.4] call fza_fnc_expSeek;
                //TGT
                _coreTemp_degC   = [_coreTemp_degC, _FAT, 300, 400] call fza_fnc_expSeek;
                private _tgt_ng  = [_tgtNgTable, (_ng_pct - _prev_ng_pct) * 30.0 + _ng_pct] call fza_fnc_linearInterp select 1;
                private _tgtGoal = if (_ng_pct > 0.20) then { _tgt_ng + 0.00; } else { _tgt_ng + ((0.20 - _ng_pct) / 0.20 * _coreTemp_degC); };
                _tgt_degC        = [_tgt_degC, _tgtGoal, _tgtDelay, _tgtDelay * 1.2] call fza_fnc_expSeek;
                //Torque
                private _tqGoal  = [_tqNgTable, _ng_pct] call fza_fnc_linearInterp select 1;
                _tqGoal          = [_tqGoal, 0.0, 1.32] call BIS_fnc_clamp;  
                _outputTq        = [_outputTq, _tqGoal * 481.0, _tqDelay, _tqDelay] call fza_fnc_expSeek;

            } else {
                _state      = "ON";
                _isOn       = true;
                _isStarting = false;
            };
        } else {
            _state      = "OFF";
            _isStarting = false;
        };

        [_heli, "fza_sfmplus_simpleEng_isOn",          _engNum, _isOn,          true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_isStarting",    _engNum, _isStarting,    true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_ng_pct",        _engNum, _ng_pct,        true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_state",         _engNum, _state,         true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_coreTemp_degC", _engNum, _coreTemp_degC, true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_tgt_degC",      _engNum, _tgt_degC,      true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_outputTq",      _engNum, _outputTq,      true] call fza_fnc_setArrayVariable;  
    };
    case "ON": {
        _isOn       = true;
        _isStarting = false;

        //Ng
        private _prev_ng_pct = _ng_pct;
        private _refRPM      = _np_idle_gnd + (_np_fly - _np_idle_gnd) * _throttlePct;
        _ng_pct              = [_ng_pct, _ng_idle + (_ng_fly - _ng_idle) * _throttlePct, _idleDelayMax, _idleDelayMax * 2.4] call fza_fnc_expSeek;
        //TGT
        _coreTemp_degC       = [_coreTemp_degC, _tgt_degC, 300, 400] call fza_fnc_expSeek;
        private _tgtGoal     = [_tgtNgTable, (_ng_pct - _prev_ng_pct) * 30.0 + _ng_pct] call fza_fnc_linearInterp select 1;
        _tgt_degC            = [_tgt_degC, _tgtGoal, _tgtDelay, _tgtDelay * 1.2] call fza_fnc_expSeek;
        //Torque
        _pidEng set ["kp", E_KP];
        _pidEng set ["ki", E_KI];
        _pidEng set ["kd", E_KD];
        private _govOutput   = [_pidEng, _deltaTime, _refRPM, _xmsnOutputRPM_pct] call fza_fnc_pidRun;
        private _tqGoal      = _govOutput + ([_tqNgTable, _ng_pct] call fza_fnc_linearInterp select 1);
        _tqGoal              = [_tqGoal, 0.0, 1.32] call BIS_fnc_clamp;  
        systemChat format ["Eng %1 Gov Out %2", _engNum, _govOutput];
        _outputTq            = [_outputTq, _tqGoal * 481.0, _tqDelay, _tqDelay] call fza_fnc_expSeek;      

        if (_isCutoff) then { _state = "OFF"; };
        if (_noFuel)   then { _state = "OFF"; };

        [_heli, "fza_sfmplus_simpleEng_isOn",          _engNum, _isOn,          true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_isStarting",    _engNum, _isStarting,    true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_ng_pct",        _engNum, _ng_pct,        true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_state",         _engNum, _state,         true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_coreTemp_degC", _engNum, _coreTemp_degC, true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_tgt_degC",      _engNum, _tgt_degC,      true] call fza_fnc_setArrayVariable;
        [_heli, "fza_sfmplus_simpleEng_outputTq",      _engNum, _outputTq,      true] call fza_fnc_setArrayVariable;   
    };
};

systemChat format ["Eng %1 - On %2 - Start %3 - Ng %4 - State %5 -- TGT %6 - Ref Tq %7", _engNum, _isOn, _isStarting, _ng_pct toFixed 3, _state, _tgt_degC toFixed 0, _refTq toFixed 3];


/*
private _oppEngNum   = if (_engNum == 0) then { 1; } else { 0; }; 

private _RPM_gndIdle = 0.57;
private _RPM_airIdle = 0.94;
private _RPM_fly     = 1.01;


private _rtrRPM      = _heli getVariable "fza_sfmplus_xmsnOutputRPM_pct";
private _outputTq    = _heli getVariable "fza_sfmplus_simpleEngOutputTq" select _engNum;
private _mainRtrTq   = _heli getVariable "fza_sfmplus_mainRtrTorque";
private _setRPm      = 0.0;
private _deltaRPM    = 0.0;
private _govOutput   = 0.0;
private _balance     = 0.0;

private _engPwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select _engNum;
private _throttlePos    = 0.0;
if (_engPwrLvrState in ["OFF", "IDLE"]) then {
    _throttlePos = 0.0;
} else {
    _throttlePos = 1.0;
};

if (isTouchingGround _heli) then {
    _setRPM = _RPM_gndIdle + (_RPM_fly - _RPM_gndIdle) * _throttlePos;
} else {
    _setRPM = _RPM_airIdle + (_RPM_fly - _RPM_airIdle) * _throttlePos;
};

//TEMP!
if (_engPwrLvrState in ["IDLE", "FLY"]) then {
    _heli engineOn true;

    //Old
    private _idleTq   = 0.0796 * _refTq;
    private _flyTq    = 0.1877 * _refTq;
    private _maxTq_DE = 1.32 * _refTq;
    private _maxTq_SE = 1.34 * _refTq;

    private _refRPM          = 20900;
    private _engRPMTrim_idle = 0.57;
    private _engRPMTrim_fly  = 1.01;
    private _engRPM_idle     = _refRPM * _engRPMTrim_idle;
    private _engRPM_fly      = _refRPM * _engRPMTrim_fly;
    private _maxPwr_DE       = _maxTQ_DE * 0.105 * _engRPM_fly;  //Watts
    private _maxPwr_SE       = _maxTq_SE * 0.105 * _engRPM_fly;  //Watts

    private _baseTq         = _heli getVariable "fza_sfmplus_simpleEngBaseTq"    select _engNum;

    //Engine governoer
    private _pidEng     = _heli getVariable "fza_sfmplus_pid_engine" select _engNum;
    //_pidEng set ["kp", E_KP];
    //_pidEng set ["ki", E_KI];
    //_pidEng set ["kd", E_KD];

    _deltaRPM           = _setRPM - _rtrRPM;
    if (_engPwrLvrState in ["OFF", "IDLE"]) then {
        [_pidEng] call fza_fnc_pidReset;
    } else {
        _govOutput          = [_pidEng, _deltaTime, _setRPM, _rtrRPM] call fza_fnc_pidRun;
    };
    _baseTq   = [_baseTq, _idleTq + (_flyTq - _idleTq) * _throttlePos, (1 / 3.0) * _deltaTime] call BIS_fnc_lerp;
    _outputTq = _baseTq + (_govOutput * _refTq) + ((_maxTQ_DE - _baseTq) * fza_sfmplus_collectiveOutput) *_throttlePos;

    //private _balancePID = [0.600, 0.010, 0.005] call fza_fnc_pidCreate;
    //_balancePID set ["kp", E_KP];
    //_balancePID set ["ki", E_KI];
    //_balancePID set ["kd", E_KD];
    //private _deltaTq    = _outputTq - (_mainRtrTq / 2);
    //private _balanceTq  = 0.0;
    //if (_deltaTq < -0.10 || _deltaTq > 0.10) then {
    //if (_deltaTq < 0) then {
        _deltaTq = (_outputTq - (_mainRtrTq / 2)) * -1.0 ;
    //};
    //if (_deltaTq > 0) then {
        _deltaTq = _outputTq - (_mainRtrTq / 2);
    //};
    //    _balanceTq = [_balancePID, _deltaTime, _mainRtrTq / 2, _deltaTq] call fza_fnc_pidRun;
    //};
    //_outputTq = _outputTq + _balanceTq;

    //systemChat format ["Eng (%2) Balance Tq = %1", _balanceTq, _engNum];

    _outputTq = [_outputTq, 0, _maxTQ_DE] call BIS_fnc_clamp;

    [_heli, "fza_sfmplus_simpleEngBaseTq",   _engNum, _baseTq, true] call fza_fnc_setArrayVariable;
    [_heli, "fza_sfmplus_simpleEngOutputTq", _engNum, _outputTq,  true] call fza_fnc_setArrayVariable;
} else {
    _heli engineOn false;
};

systemChat format ["Eng (%1) Gov Output = %2 -- DeltaRPM = %3 -- Rtr RPM = %4 -- Set RPM = %5 -- Opp Eng Num = %6 -- Balance Tq = %7", _engNum, _govOutput toFixed 2, _deltaRPM toFixed 2, _rtrRPM toFixed 2, _setRPM toFixed 2, _oppEngNum, _balance toFixed 2];
[_heli, "fza_sfmplus_engPctTQ",      _engNum, _outputTq / 481.0] call fza_fnc_setArrayVariable;

_outputTq;
*/