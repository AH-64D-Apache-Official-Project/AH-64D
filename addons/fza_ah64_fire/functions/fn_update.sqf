/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_update

Description:
    handles the perframe fire panel Logic

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli"];

private _battBusOn          = _heli getVariable "bmkhs_battBusOn";
private _engineOneArm       = (_heli getVariable "fza_ah64_fireArmed1") #0;
private _engineOneArmTimer  = (_heli getVariable "fza_ah64_fireArmed1") #2;
private _engineTwoArm       = (_heli getVariable "fza_ah64_fireArmed2") #0;
private _engineTwoArmTimer  = (_heli getVariable "fza_ah64_fireArmed2") #2;
private _apuArm             = (_heli getVariable "fza_ah64_fireArmedApu") #0;
private _apuArmTimer        = (_heli getVariable "fza_ah64_fireArmedApu") #2;
private _primaryFB          = _heli getVariable "fza_ah64_firepdisch";
private _reserveFB          = _heli getVariable "fza_ah64_firerdisch";
private _engineOneFire      = _heli getVariable "fza_ah64_e1_fire";
private _engineTwoFire      = _heli getVariable "fza_ah64_e2_fire";
private _apuFire            = _heli getVariable "fza_ah64_apu_fire";
private _mstrWarnLighton    = _heli getVariable "fza_ah64_mstrWarnLightOn";

if (_engineOneArm && _engineOneArmTimer <= CBA_missionTime - 2) then {
    [_heli, "bmkhs_engState", 0, "OFF", true] call fza_fnc_setArrayVariable;
};
if (_engineTwoArm && _engineTwoArmTimer <= CBA_missionTime - 2) then {
    [_heli, "bmkhs_engState", 1, "OFF", true] call fza_fnc_setArrayVariable;
};
if (_apuArm && _apuArmTimer <= CBA_missionTime - 2) then {
    [_heli, "bmkhs_apuBtnOn", false] call fza_fnc_updateNetworkGlobal;
};

//An oil-starved engine failing rolls once for fire; a repair clears the roll.
if (local _heli) then {
    private _rolled = _heli getVariable "fza_ah64_oilFireRolled";
    {
        private _failed = (_heli getVariable "bmkhs_engFailed") select _forEachIndex;
        if (!_failed) then {
            _rolled set [_forEachIndex, false];
        } else {
            if ((_heli getVariable "bmkhs_lowOilPsiFailure") select _forEachIndex && {!(_rolled select _forEachIndex)}) then {
                _rolled set [_forEachIndex, true];
                if (random 1 < SYS_ENG_OIL_FIRE_CHANCE) then {
                    [_heli, _x, true] spawn fza_fire_fnc_damageEngineFire;
                };
            };
        };
    } forEach ["left", "right"];
};

//Fire test switch
if ((_heli getVariable "fza_ah64_firetest") >= 1) then {
    [_heli, "fza_ah64_mstrWarnLightOn", true] call fza_fnc_updateNetworkGlobal;
    _engineOneArm  = true;
    _engineTwoArm  = true;
    _apuArm        = true;
    _primaryFB     = false;
    _reserveFB     = false;
    _engineOneFire = true;
    _engineTwoFire = true;
    _apuFire       = true;
};
if ((_heli getVariable "fza_ah64_firetest") == 2) then {
    _primaryFB     = true;
    _reserveFB     = true;
};

if !_battBusOn then {
    [_heli, "fza_ah64_fireArmed1", [false, 0, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_fireArmed2", [false, 0, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_fireArmedApu", [false, 0, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
    _engineOneArm  = false;
    _engineTwoArm  = false;
    _apuArm        = false;
    _primaryFB     = false;
    _reserveFB     = false;
    _engineOneFire = false;
    _engineTwoFire = false;
    _apuFire       = false;
};

//FIRE Arm
_heli setObjectTexture ["in_lt_fire1rdy", ["", "\fza_ah64_model\tex\in\pushbut.paa"] select _engineOneArm];
_heli setObjectTexture ["in_lt_fire2rdy", ["", "\fza_ah64_model\tex\in\pushbut.paa"] select _engineTwoArm];
_heli setObjectTexture ["in_lt_fireapurdy", ["", "\fza_ah64_model\tex\in\pushbut.paa"] select _apuArm];
//FIRE Detected
_heli setObjectTexture ["in_lt_fire1", ["", "\fza_ah64_model\tex\in\pushbut.paa"] select _engineOneFire];
_heli setObjectTexture ["in_lt_fire2", ["", "\fza_ah64_model\tex\in\pushbut.paa"] select _engineTwoFire];
_heli setObjectTexture ["in_lt_fireapu", ["", "\fza_ah64_model\tex\in\pushbut.paa"] select _apuFire];
//Fire bottle Dispensed
_heli setObjectTexture ["in_lt_firepdis", ["", "\fza_ah64_model\tex\in\pushbut.paa"] select _primaryFB];
_heli setObjectTexture ["in_lt_firerdis", ["", "\fza_ah64_model\tex\in\pushbut.paa"] select _reserveFB];
