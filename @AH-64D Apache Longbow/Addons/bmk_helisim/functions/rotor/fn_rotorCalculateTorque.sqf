params ["_heli", "_rtrNum", "_CT", "_rotorParams", "_rho", "_omegaR", "_mu", "_thrust", "_lambda", "_Hdrag"];

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_thrustScalar", "_Ib", "_s", "_polarMOI", "_inputMaps"];

//From "Bramwell's Helicopter Dynamics", second edition, eqn 3.43 and 3.44
//Replaces SH79 eqn 36 (sourced from JSBSim)
private _deltaDrag_0 = 6.0 * _CT / (_a * _s);
private _deltaDrag   = 0.009 + 0.3 * _deltaDrag_0^2;

private _torque = _rho * _b * _c * _deltaDrag * _omegaR^2 * _R^2 * (1.0 + 4.5 * _mu^2) / 8.0 - (_thrust * _lambda + _Hdrag * _mu) * _R;
if (_torque == 0.0) then { _torque = 0.0; };
/*
hintSilent format ["Rotor %1
                   \ndeltaDrag2 %2
                   \ndeltaDrag %3
                   \ntorque %4
                   \nmu %5
                   \nomegaR %6
                   \nthrust %7", _rtrNum, _deltaDrag_0 toFixed 3, _deltaDrag toFixed 3, _torque toFixed 3, _mu toFixed 3, _omegaR toFixed 3, _thrust toFixed 3];
*/
[_heli, "bmk_helisim_rtrOutputTq", _rtrNum, _torque] call fza_sfmplus_fnc_setArrayVariable;

[_torque];