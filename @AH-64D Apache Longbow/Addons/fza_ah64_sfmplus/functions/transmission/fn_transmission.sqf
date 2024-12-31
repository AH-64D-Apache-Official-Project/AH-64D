params ["_heli"];

private _engDesignRPM     = 21109;
private _mainRtrMOI       = _heli getVariable "fza_sfmplus_rtrMOI" select 0;
private _mainRtrGearRatio = 72.29;
private _outputRPM        = _heli getVariable "fza_sfmplus_xmsnOutputRPM";
private _deltaRPM         = _heli getVariable "fza_sfmplus_xmsnDeltaRPM";

private _totTQ = 0.0;
private _rtrTQ =  _heli getVariable "fza_sfmplus_rtrTQ";
{
    _totTQ = _totTQ + _x;
} forEach _rtrTQ;

private _engOutputTQ = _heli getVariable "fza_sfmplus_engOutputTQ";
private _engInputTQ  = 0.0;
{
    _engInputTQ = _engInputTQ + _x;
} forEach _engOutputTQ;

_deltaRPM  = (_engInputTQ - _totTQ) / (_mainRtrMOI / _mainRtrGearRatio^2);
_outputRPM = _outputRPM + _deltaRPM;
_outputRPM = [_outputRPM, 0.0, _engDesignRPM] call BIS_fnc_clamp;

_heli setVariable ["fza_sfmplus_xmsnOutputRPM", _outputRPM];
_heli setVariable ["fza_sfmplus_xmsnDeltaRPM",  _deltaRPM];