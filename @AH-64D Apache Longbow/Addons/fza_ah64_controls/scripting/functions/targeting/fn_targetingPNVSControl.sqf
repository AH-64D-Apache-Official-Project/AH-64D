/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingPNVSControl

Description:
    Handles the movement of the PNVS when the player moves their head or mouse (depending on if they are in head tracking mode.)

Parameters:
    _heli - The helicopter to act on

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_targetingPNVSControl
    ---

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli"];

private _acBusOn = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn = _heli getVariable "fza_systems_dcBusOn";

if (player == driver _heli && (vehicle player) isKindOf "fza_ah64base") then {
    if (player == driver _heli && (_acBusOn && _dcBusOn)) then {
        if (isNil "fza_ah64_pnvsgreff") then {
            fza_ah64_pnvsgreff = ppEffectCreate ["colorCorrections",4000];
        };
        fza_ah64_pnvsgreff ppEffectAdjust [1,1,0,[-2,2,-2,0.05],[-4.99,0.74,0.44,0.38],[0.33,0.33,0.33,0],[0,0,0,0,0,0,4]]; //GREEN PNVS (HDU LOGIC)
        //fza_ah64_pnvsgreff ppEffectAdjust[1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0.33, 0.33, 0.33, 0], [0, 0, 0, 0, 0, 0, 4]]; //GREY SOURCE PNVS (MPD LOGIC)
        fza_ah64_pnvsgreff ppEffectCommit 0;
        fza_ah64_pnvsgreff ppEffectEnable true;

    } else {
        if (isNil "fza_ah64_pnvsgreff") then {
            fza_ah64_pnvsgreff = ppEffectCreate ["colorCorrections",4000];
        };
        fza_ah64_pnvsgreff ppEffectAdjust[0, 0, 0, [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]];
        fza_ah64_pnvsgreff ppEffectCommit 0;
        fza_ah64_pnvsgreff ppEffectEnable true;
    };

    if (cameraView == "EXTERNAL" || cameraView == "INTERNAL") then {
        fza_ah64_pnvsgreff ppEffectEnable false;
    };

    if (vehicle player != _heli && !(vehicle player isKindOf "fza_ah64base") || !(alive _heli) && !(vehicle player isKindOf "fza_ah64base") || !(alive player)) then {
        fza_ah64_pnvsgreff ppEffectEnable false;
    };
    if (cameraView == "INTERNAL") then {
        (( _heli vectorWorldToModelVisual getCameraViewDirection player) call CBA_fnc_vect2Polar) params ["_mag", "_az", "_el"];
        if (_heli getHit "pnvs" >= 0.8) then {
            _az = -1;
            _el = 1;
        };
        _heli animateSource["pnvs", rad ([_az] call CBA_fnc_simplifyAngle180)];
        _heli animateSource["pnvs_vert", rad ([_el] call CBA_fnc_simplifyAngle180)];
    };
    if (cameraView == "GUNNER") then {
        if (fza_ah64_tiron) then {
            _heli animateSource["pnvs", linearConversion [-1, 1, inputaction "lookRightCont" - inputaction "lookLeftCont", rad -180, rad 180]];
            _heli animateSource["pnvs_vert", linearConversion [-1, 1, inputaction "lookUpCont" - inputaction "lookDownCont", rad -180, rad 180]];
        } else {
            private _panAdjust = (-0.0125 * (inputaction "AimLeft" + (0.0125 * inputaction "LookLeft"))) + (0.0125 * (inputaction "AimRight" + (0.0125 * inputaction "LookRight")));
            private _tiltAdjust = (0.0125 * (inputaction "AimUp" + (0.0125 * inputaction "LookUp"))) + (-0.0125 * (inputaction "AimDown" + (0.0125 * inputaction "LookDown")));
            _heli animateSource["pnvs", (_heli animationSourcePhase "pnvs") + _panAdjust];
            _heli animateSource["pnvs_vert", (_heli animationSourcePhase "pnvs_vert") + _tiltAdjust];
        }
    };
    
    // BACKUP TURRET OPTIC PNVS WITH BOTH LOGICS
    if(player == driver _heli && (_acBusOn && _dcBusOn)) then
    {
        if (isNil "fza_ah64_pnvsgreff") then {
            fza_ah64_pnvsgreff = ppEffectCreate ["colorCorrections",4000];
        };
        fza_ah64_pnvsgreff ppEffectAdjust [1,1,0,[-2,2,-2,0.05],[-4.99,0.74,0.44,0.38],[0.33,0.33,0.33,0],[0,0,0,0,0,0,4]]; //GREEN PNVS (HDU LOGIC)
        fza_ah64_pnvsgreff ppEffectCommit 0;
        fza_ah64_pnvsgreff ppEffectEnable true;
    
    } else {
            if (isNil "fza_ah64_pnvsgreff") then {
                fza_ah64_pnvsgreff = ppEffectCreate ["colorCorrections",4000];
            };
            fza_ah64_pnvsgreff ppEffectAdjust [0, 0, 0, [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]];
            fza_ah64_pnvsgreff ppEffectCommit 0;
            fza_ah64_pnvsgreff ppEffectEnable true;
    };
    
    if(cameraView == "EXTERNAL" || cameraView == "INTERNAL") then {
        fza_ah64_pnvsgreff ppEffectEnable false;
    };

    if (vehicle player != _heli && !(vehicle player isKindOf "fza_ah64base") || !(alive _heli) && !(vehicle player isKindOf "fza_ah64base") || !(alive player)) then {
        fza_ah64_pnvsgreff ppEffectEnable false;
    };	
};
