params ["_heli", "_rtrNum", "_CT", "_rotorParams", "_rho", "_omegaR", "_mu", "_thrust", "_lambda", "_H"];
#include "\bmk_helisim\headers\core.hpp"

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_thrustScalar", "_Ib", "_s", "_polarMOI", "_inputMaps"];

//From "Bramwell's Helicopter Dynamics", second edition, eqn 3.43 and 3.44
//Replaces SH79 eqn 36 (sourced from JSBSim)
private _deltaDrag_0 = 6.0 * _CT / (_a * _s);
private _deltaDrag   = 0.009 + 0.3 * (_deltaDrag_0 * _deltaDrag_0);

private _torque       = _rho * _b * _c * _deltaDrag * (_omegaR * _omegaR) * (_R * _R) * (1.0 + 4.5 * (_mu * _mu)) / 8.0 - (_thrust * _lambda + _H * _mu) * _R;
private _outputTorque = _torque / _gearRatio;

if (_outputTorque < 0 ) exitWith { hintSilent format ["Output torque < 0! %1", _outputTorque]};

[_heli, "bmk_helisim_rotor_outputTorque", _rtrNum, _outputTorque] call fza_sfmplus_fnc_setArrayVariable;

[_torque];