#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

private _baroAlt = getPosASL _heli # 2 * METERS_TO_FEET;
private _baseAlt = 0.0;
private _baseFAT = 0.0;
switch (fza_ah64_sfmplusEnvironment) do {
    case ISA_STD: {
        _baseAlt = 0;
        _baseFAT = 15.0;
    };
    case EUROPE_SUMMER: {
        _baseAlt = 800;
        _baseFAT = 20.0;
    };
    case EUROPE_WINTER: {
        _baseAlt = 800;
        _baseFAT = 0.0;
    };
    case MIDDLE_EAST: {
        _baseAlt = 1800;
        _baseFAT = 30.0;
    };
    case CENTRAL_ASIA_SUMMER: {
        _baseAlt = 5000;
        _baseFAT = 30.0;
    };
    case CENTRAL_ASIA_WINTER: {
        _baseAlt = 5000;
        _baseFAT = -5.0;
    };
    case ASIA: {
        _baseAlt = 3100;
        _baseFAT = 25.0;
    };
};

//Environment
private _altitude          = round ((_baseAlt + _baroAlt) / 10) * 10;; //PA  feet
private _altimeter         = 29.92; //in mg
private _temperature       = _baseFAT - round((_baroAlt / 1000) * 2); //FAT deg C

private _referencePressure = _altimeter * IN_MG_TO_HPA;
private _referenceAltitude = 0;
private _exp               = -GRAVITY * MOLAR_MASS_OF_AIR * (_altitude - _referenceAltitude) / (UNIVERSAL_GAS_CONSTANT * (_temperature + DEG_C_TO_KELVIN));
private _pressure          = ((_referencePressure / 0.01) * (EXP _exp)) * 0.01;

private _densityAltitude   = (_altitude + ((SEA_LEVEL_PRESSURE - _altimeter) * 1000)) + (120 * (_temperature - (STANDARD_TEMP - ((_altitude / 1000) * 2))));
private _dryAirDensity     = (_pressure / 0.01) / (287.05 * (_temperature + DEG_C_TO_KELVIN));

_heli setVariable ["fza_sfmplus_PA",    _altitude];
_heli setVariable ["fza_sfmplus_FAT",   _temperature];
_heli setVariable ["fza_sfmplus_rho",   _dryAirDensity];

//Wind
private _deltaTime     = _heli getVariable "fza_sfmplus_deltaTime";
//private _gustSpeed     = _heli getVariable "fza_sfmplus_windGustSpeed";

private _windDir       = fza_ah64_sfmPlusWindDirection;
private _windSpeed     = fza_ah64_sfmPlusWindSpeed;
private _randGust      = 0.0;//random fza_ah64_sfmPlusWindGustSpeed;
private _gustSpeed     = 0.0;//[_gustSpeed, _randGust, (1.0 / 3.0) * _deltaTime] call BIS_fnc_lerp;

//systemChat format ["_windDir = %1 -- _windSpeed = %2 -- _gustSpeed = %3 -- _randGust = %4", _windDir toFixed 0, _windSpeed toFixed 0, _gustSpeed toFixed 0, _randGust toFixed 0];

_windSpeed = _windSpeed * KNOTS_TO_MPS;
_gustSpeed = _gustSpeed * KNOTS_TO_MPS;

private __velWindWorldSpaceX = -((_windSpeed + _gustSpeed) * sin _windDir);
private __velWindWorldSpaceY = -((_windSpeed + _gustSpeed) * cos _windDir);

private _velWindWorldSpace   = [__velWindWorldSpaceX, __velWindWorldSpaceY, 0.0];

_heli setVariable ["fza_sfmplus_velWindWorldSpace", _velWindWorldSpace];
//_heli setVariable ["fza_sfmplus_windGustSpeed", _gustSpeed];