params ["_heli"];

private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";

fza_simvars_e1ThrottlePos = "OFF";
fza_simvars_e1State = "OFF";
fza_simvars_e1Start = false;
fza_simvars_e1on    = false;
fza_simvars_e1np    = 0.0;
fza_simvars_e1ng    = 0.0;
fza_simvars_e1tgt   = 0.0;
fza_simvars_e1trq   = 0.0;
fza_simvars_e1opsi  = 0.0;

fza_simvars_e2ThrottlePos = "OFF";
fza_simvars_e2State = "OFF";
fza_simvars_e2Start = false;
fza_simvars_e2on    = false;
fza_simvars_e2np    = 0.0;
fza_simvars_e2ng    = 0.0;
fza_simvars_e2tgt   = 0.0;
fza_simvars_e2trq   = 0.0;
fza_simvars_e2opsi  = 0.0;

fza_simvars_rtrRPM  = 0.0;


//SFM+
if ((getText _flightModel) == "SFMPlus") then {
    //Engine 1
    fza_simvars_e1ThrottlePos = _heli getVariable "fza_sfmplus_engThrottlePos" select 0;
    fza_simvars_e1State = _heli getVariable "fza_sfmplus_engState" select 0;
    fza_simvars_e1start = fza_simvars_e1State == "STARTING";
    fza_simvars_e1np    = (_heli getVariable "fza_sfmplus_engPctNP" select 0) * 100;
    fza_simvars_e1ng    = (_heli getVariable "fza_sfmplus_engPctNG" select 0) * 1000;
    fza_simvars_e1tgt   =  _heli getVariable "fza_sfmplus_engTGT" select 0;
    fza_simvars_e1trq   = (_heli getVariable "fza_sfmplus_engPctTQ" select 0) * 100;
    fza_simvars_e1opsi  = (_heli getVariable "fza_sfmplus_engOilPSI" select 0) * 100;

    //Engine 2
    fza_simvars_e2ThrottlePos = _heli getVariable "fza_sfmplus_engThrottlePos" select 1;
    fza_simvars_e2State = _heli getVariable "fza_sfmplus_engState" select 1;
    fza_simvars_e2start = fza_simvars_e2State == "STARTING";
    fza_simvars_e2np    = (_heli getVariable "fza_sfmplus_engPctNP" select 1) * 100;
    fza_simvars_e2ng    = (_heli getVariable "fza_sfmplus_engPctNG" select 1) * 1000;
    fza_simvars_e2tgt   =  _heli getVariable "fza_sfmplus_engTGT" select 1;
    fza_simvars_e2trq   = (_heli getVariable "fza_sfmplus_engPctTQ" select 1) * 100;
    fza_simvars_e2opsi  = (_heli getVariable "fza_sfmplus_engOilPSI" select 1) * 100;

    fza_simvars_rtrRPM = ((_heli animationPhase "mainrotorRPM") * 1.08) * 10;
    fza_simvars_rtrRPM = [fza_simvars_rtrRPM, 0.0, fza_simvars_e1np max fza_simvars_e2np] call BIS_fnc_clamp;
} else {
    //Engine 1
    fza_simvars_e1ThrottlePos = _heli getVariable "bmk_helisim_engThrottlePos" select 0;
    fza_simvars_e1State = _heli getVariable "bmk_helisim_engState" select 0;
    fza_simvars_e1Start = _heli getVariable "bmk_helisim_engStart" select 0;
    fza_simvars_e1np    = ((_heli getVariable "bmk_helisim_engineOutputRPM" select 0) / 21109) * 100;
    fza_simvars_e1trq   = ((_heli getVariable "bmk_helisim_engineOutputTq" select 0) / 481) * 100;

    //Engine 2
    fza_simvars_e2ThrottlePos = _heli getVariable "bmk_helisim_engThrottlePos" select 1;
    fza_simvars_e2State = _heli getVariable "bmk_helisim_engState" select 1;
    fza_simvars_e2Start = _heli getVariable "bmk_helisim_engStart" select 1;
    fza_simvars_e2np    = ((_heli getVariable "bmk_helisim_engineOutputRPM" select 1) / 21109) * 100;
    fza_simvars_e2trq   = ((_heli getVariable "bmk_helisim_engineOutputTq" select 1) / 481) * 100;

    fza_simvars_rtrRPM = ((_heli getVariable "bmk_helisim_xmsnOutputRPM") / 21109) * 100;
};