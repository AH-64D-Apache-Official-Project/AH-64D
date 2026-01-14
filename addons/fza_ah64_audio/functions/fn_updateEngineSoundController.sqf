/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_updateEngineSoundController
Description:
    trigger on `fza_fnc_setArrayVariable` change variable event to update engine sound controllers.

Parameters:
    _heli  - heli itself <OBJECT>
    _variableName  - variable Name that been updated <STRING>
    _index  - Engine index [0/1] <STRING>
    _value  - Value of the variable <ANYTHING>
    _public  - Is the value public to the network <BOOL>

Returns:
    Nothing

Examples
    (begin example)
        [params] call fza_audio_fnc_updateEngineSoundController
    (end)

Author:
    Aaren
---------------------------------------------------------------------------- */

params ["_heli", "_variableName", "_index", "_value", ["_public", false]];

//- Must be public variables
if (!_public) exitWith {};

switch (_variableName) do {
  case "fza_sfmplus_engState": {
    // systemChat str [format ["Engine Set POS (%1)", _value], time];

    private _Snd_Ctrl_BaseID = 5; //- CustomSoundController 5
    private _toValue = call {
      if (_value == "ON") exitWith {-1};
      if (_value == "STARTING") exitWith {1};
      0
    };

    private _Snd_Ctrl = format ["CustomSoundController%1", _Snd_Ctrl_BaseID + _index];
    private _cur_Snd_Ctrl = getCustomSoundController [_heli, _Snd_Ctrl];
    // systemChat str ["StartSwitch",_Snd_Ctrl,_toValue,_cur_Snd_Ctrl];
      
    if (_cur_Snd_Ctrl == _toValue) exitWith {};
    setCustomSoundController [_heli, _Snd_Ctrl, _toValue];
    
    //- Update power sound
    [_heli, "powerLever"] call fza_fnc_fxLoops;
  };
  
  case "fza_sfmplus_engPowerLeverState": {
    private _engState = _heli getVariable "fza_sfmplus_engState" select _index;

    // #NOTE - Catch lever when the engine isn't started yet
    if (_engState == "OFF" && _value != "OFF") exitWith {}; //- Exit

    {
      _x params ["_Snd_Ctrl_BaseID","_toStatus"];

      private _Snd_Ctrl = format ["CustomSoundController%1", _Snd_Ctrl_BaseID + (_index * 2)];
      
      private _toValue = parseNumber _toStatus;
      private _cur_Snd_Ctrl = getCustomSoundController [_heli, _Snd_Ctrl];
        
      if (_cur_Snd_Ctrl == _toValue) then {continue};
      setCustomSoundController [_heli, _Snd_Ctrl, _toValue];
    } forEach [
      [10, _value != "OFF"],// Startup (ID : 10, 12)
      [11, _value == "OFF"] // Shutdown (ID : 11, 13)
    ];

    //- Update power sound
    [_heli, "powerLever"] call fza_fnc_fxLoops;
  };
};