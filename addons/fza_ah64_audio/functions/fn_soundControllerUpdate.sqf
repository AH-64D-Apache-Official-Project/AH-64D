/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_soundControllerUpdate

Description:
    Sets the aircraft's custom sound controllers from HeliSim's public state.
    Called every frame, on every machine with an interface, for every Apache.

    CustomSoundController1     - APU rpm
    CustomSoundController2     - battery bus
    CustomSoundController5/6   - engine 1/2 starter, 1 starting, -1 on
    CustomSoundController10/12 - engine 1/2 lit
    CustomSoundController11/13 - engine 1/2 flamed out
    CustomSoundController15    - mean Ng against the Ng limiter
    CustomSoundController17    - rotor RPM, in place of the engine's rotorSpeed

Parameters:
    _heli      - The helicopter [Object]
    _deltaTime - Seconds since the last frame [Number]

Returns:
    Nothing

Examples:
    [_heli, diag_deltaTime] call fza_audio_fnc_soundControllerUpdate

Author:
    Aaren
---------------------------------------------------------------------------- */
#define ENG_SMOOTH_TIME 1.5
#define APU_SMOOTH_TIME 0.2
#define RTR_SMOOTH_TIME 0.2

//A trigger left high replays its one-shot whenever the player gets in or out
#define TRIGGER_HOLD 0.5

params ["_heli", "_deltaTime"];

private _engState = _heli getVariable "bmkhs_engState";
if (isNil "_engState") exitWith {};

private _pwrLvr    = _heli getVariable ["bmkhs_engPowerLeverState", []];
private _state     = [_engState, _pwrLvr];
private _prev      = _heli getVariable ["fza_audio_soundState", []];
private _firstSeen = _prev isEqualTo [];

private _held   = _heli getVariable ["fza_audio_soundTriggers", []];
private _active = _held;

private _fnc_trigger = {
    params ["_id", "_value"];
    private _controller = format ["CustomSoundController%1", _id];
    setCustomSoundController [_heli, _controller, _value];
    _active = _active select {(_x # 0) != _controller};
    if (_value != 0) then {_active pushBack [_controller, time + TRIGGER_HOLD]};
};

if (_state isNotEqualTo _prev) then {
    //An aircraft first seen already running adopts its state without replaying the one-shots
    if (!_firstSeen) then {
        _prev params ["_prevState", "_prevLvr"];
        {
            private _st     = _engState param [_x, "OFF"];
            private _stPrev = _prevState param [_x, "OFF"];
            if (_st != _stPrev) then {
                switch (_st) do {
                    case "STARTING": {[5 + _x,  1] call _fnc_trigger};
                    case "ON":       {[5 + _x, -1] call _fnc_trigger};
                    default          {[5 + _x,  0] call _fnc_trigger};
                };
            };

            private _lit     = _st != "OFF" && {(_pwrLvr param [_x, "OFF"]) != "OFF"};
            private _litPrev = _stPrev != "OFF" && {(_prevLvr param [_x, "OFF"]) != "OFF"};
            if (_lit isNotEqualTo _litPrev) then {
                [10 + _x * 2, [0, 1] select _lit] call _fnc_trigger;
                [11 + _x * 2, [1, 0] select _lit] call _fnc_trigger;
            };
        } forEach [0, 1];
    };
    _heli setVariable ["fza_audio_soundState", +_state];
};

if (_active isNotEqualTo []) then {
    private _playing = _active select {time < (_x # 1)};
    if (count _playing != count _active) then {
        {
            if (time >= (_x # 1)) then {setCustomSoundController [_heli, _x # 0, 0]};
        } forEach _active;
        _active = _playing;
    };
};
if (_active isNotEqualTo _held) then {
    _heli setVariable ["fza_audio_soundTriggers", _active];
};

private _fnc_approach = {
    params ["_controller", "_target", "_smoothTime"];
    private _value = getCustomSoundController [_heli, _controller];
    if (_value == _target) exitWith {};
    if (_firstSeen || {abs (_target - _value) < 0.001}) then {
        _value = _target;
    } else {
        _value = _value + (_target - _value) * ((_deltaTime / _smoothTime) min 1);
    };
    setCustomSoundController [_heli, _controller, _value];
};

private _ng = _heli getVariable ["bmkhs_engPctNg", []];
["CustomSoundController15", (((_ng param [0, 0]) + (_ng param [1, 0])) / (2 * fza_audio_ngRef)) min 1 max 0, ENG_SMOOTH_TIME] call _fnc_approach;
["CustomSoundController1", _heli getVariable ["bmkhs_apuRpm_pct", 0], APU_SMOOTH_TIME] call _fnc_approach;

private _designRpm = _heli getVariable ["bmkhs_engDesignRpm", 0];
private _rtrRpm    = if (_designRpm > 0) then {(_heli getVariable ["bmkhs_xmsnOutputRpm", 0]) / _designRpm} else {0};
["CustomSoundController17", _rtrRpm max 0, RTR_SMOOTH_TIME] call _fnc_approach;

private _battBus = [0, 1] select (_heli getVariable ["bmkhs_battBusOn", false]);
if (getCustomSoundController [_heli, "CustomSoundController2"] != _battBus) then {
    setCustomSoundController [_heli, "CustomSoundController2", _battBus];
};
