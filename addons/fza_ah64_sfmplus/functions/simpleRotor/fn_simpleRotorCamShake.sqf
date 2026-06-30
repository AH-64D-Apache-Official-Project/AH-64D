/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_simpleRotorCamShake

Description:
    Speed- and VRS-induced camera shake for the simple rotor model.
    Intentionally not gated on vehicle locality — purely cosmetic, per-client.
    velModelSpace and vel2D are independently computed each frame on every crew
    member's machine via fza_sfmplus_fnc_coreUpdate (no locality requirement).
    xmsnOutputRpm, vrsVelocityMin/Max are broadcast with true by their owning
    functions so they are valid on all clients.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (cameraView != "INTERNAL") exitWith {};

private _isOnGnd      = [_heli] call fza_sfmplus_fnc_onGround;
private _velModelSpace = _heli getVariable "fza_sfmplus_velModelSpace";
private _velXYNoWind  = vectorMagnitude [_velModelSpace # 0, _velModelSpace # 1] min VEL_VNE;
if (_isOnGnd) then { _velXYNoWind = 0.0; };
private _velZ         = _velModelSpace # 2;
private _vel2d        = (_heli getVariable "fza_sfmplus_vel2D") * KNOTS_TO_MPS;
private _inputRPM     = (_heli getVariable ["fza_sfmplus_xmsnOutputRpm", 0.0]) / 20900;
private _vrsVelMax    = _heli getVariable ["fza_sfmplus_vrsVelocityMax", 0.0];

//Camera shake effect for ETL (16 to 24 knots)
if (_velXYNoWind > 8.23 && _velXYNoWind < 12.35 && !_isOnGnd) then {
    enableCamShake true;
    setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
    addCamShake       [0.9, 0.4, 6.2];
    enableCamShake false;

    setCustomSoundController[_heli, "CustomSoundController3", 1.5];
    setCustomSoundController[_heli, "CustomSoundController4", 0.8];
} else {
    setCustomSoundController[_heli, "CustomSoundController4", 0.0];
};
//Camera shake effect 130kts to 140kts
if (_vel2d >= 66.87 && _vel2d < 72.02) then {
    enableCamShake true;
    setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
    addCamShake       [2.5, 1, 5];
    enableCamShake false;

    setCustomSoundController[_heli, "CustomSoundController3", 6.4];
    setCustomSoundController[_heli, "CustomSoundController4", 1.8];
} else {
    setCustomSoundController[_heli, "CustomSoundController4", 0.0];
};
//Camera shake effect 140kts to 150kts
if (_vel2d >= 72.02 && _vel2d < 77.16) then {
        enableCamShake true;
        setCamShakeParams [0.0, 0.5, 0.0, 0.5, true];
        addCamShake       [3, 1, 5.5];
        enableCamShake false;

        setCustomSoundController[_heli, "CustomSoundController3", 6.4];
        setCustomSoundController[_heli, "CustomSoundController4", 1.8];
} else {
    setCustomSoundController[_heli, "CustomSoundController4", 0.0];
};
//Camera shake effect 150kts to 160kts
if (_vel2d >= 77.16 && _vel2d < 82.30) then {
        enableCamShake true;
        setCamShakeParams [0.0, 0.75, 0.0, 0.75, true];
        addCamShake       [3.5, 1, 6.0];
        enableCamShake false;

        setCustomSoundController[_heli, "CustomSoundController3", 6.4];
        setCustomSoundController[_heli, "CustomSoundController4", 1.8];
} else {
    setCustomSoundController[_heli, "CustomSoundController4", 0.0];
};
//Camera shake effect >160kts
if (_vel2d >= 82.30) then {
        enableCamShake true;
        setCamShakeParams [0.0, 1.0, 0.0, 2.0, true];
        addCamShake       [4.0, 1, 6.5];
        enableCamShake false;

        setCustomSoundController[_heli, "CustomSoundController3", 6.4];
        setCustomSoundController[_heli, "CustomSoundController4", 1.8];
} else {
    setCustomSoundController[_heli, "CustomSoundController4", 0.0];
};
//Camera shake effect for vortex ring state
if (_velXYNoWind < 12.35 && _inputRPM > EPSILON && !_isOnGnd) then {  //must be less than ETL
    //2000 fpm to 2933fpm
    if (_velZ < -(_vrsVelMax * 0.40) && _velZ > -(_vrsVelMax * 0.60)) then {
        enableCamShake true;
        setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
        addCamShake       [2.5, 1, 5];
        enableCamShake false;

        setCustomSoundController[_heli, "CustomSoundController3", 6.4];
        setCustomSoundController[_heli, "CustomSoundController4", 1.8];

        if (fza_ah64_sfmPlusVrsWarning) then {
            hintSilent parseText format ["<t size='1.5' font='EtelkaMonospacePro' color='#99ffffff'>Entering VRS Condition!</t>"];
        };
    };
    //2933 fpm to 3867
    if (_velZ <= -(_vrsVelMax * 0.60) && _velZ > -(_vrsVelMax * 0.80)) then {
        enableCamShake true;
        setCamShakeParams [0.0, 0.5, 0.0, 0.5, true];
        addCamShake       [3, 1, 5.5];
        enableCamShake false;

        setCustomSoundController[_heli, "CustomSoundController3", 6.4];
        setCustomSoundController[_heli, "CustomSoundController4", 1.8];

        if (fza_ah64_sfmPlusVrsWarning) then {
            hintSilent parseText format ["<t size='1.5' font='EtelkaMonospacePro' color='#FFFF00'>Caution! VRS Developing!</t>"];
        };
    };
    //3867fpm to 4800 fpm
    if (_velZ <= -(_vrsVelMax * 0.80) && _velZ > -_vrsVelMax) then {
        enableCamShake true;
        setCamShakeParams [0.0, 0.75, 0.0, 0.75, true];
        addCamShake       [3.5, 1, 6.0];
        enableCamShake false;

        setCustomSoundController[_heli, "CustomSoundController3", 6.4];
        setCustomSoundController[_heli, "CustomSoundController4", 1.8];

        if (fza_ah64_sfmPlusVrsWarning) then {
            hintSilent parseText format ["<t size='1.5' font='EtelkaMonospacePro' color='#ff0000'>Warning! Fully Developed VRS Imminent!</t>"];
        };
    };
    //> 4800fpm
    if (_velZ < -_vrsVelMax) then {
        enableCamShake true;
        setCamShakeParams [0.0, 1.0, 0.0, 2.0, true];
        addCamShake       [4.0, 1, 6.5];
        enableCamShake false;

        setCustomSoundController[_heli, "CustomSoundController3", 6.4];
        setCustomSoundController[_heli, "CustomSoundController4", 1.8];

        if (fza_ah64_sfmPlusVrsWarning) then {
            hintSilent parseText format ["<t size='1.5' font='EtelkaMonospacePro' color='#ff0000'>Danger! You are in VRS!</t>"];
        };
    };
} else {
    setCustomSoundController[_heli, "CustomSoundController4", 0.0];
};
