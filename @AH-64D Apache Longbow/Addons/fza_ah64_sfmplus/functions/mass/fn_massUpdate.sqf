/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_massUpdate

Description:
    Updates the mass and moment of a wing station

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _armCPG         = [ 0.00, 2.09];
private _armPLT         = [ 0.00, 3.64];
private _armFwdFuelCell = [ 0.00, 3.51];
private _armAmmoBay     = [ 0.00, 5.32];
private _armAftFuelCell = [ 0.00, 6.79];

private _armStation01   = [-2.16, 4.72];
private _armStation02   = [-1.50, 4.72];
private _armStation03   = [ 1.50, 4.72];
private _armStation04   = [ 2.16, 4.72];

private _curMass   = 0;
private _curMom    = 0;
private _emptyMass = 0;
private _emptyMom  = 0;

if (_heli animationPhase "fcr_enable" == 1) then {
    _emptyMass = _heli getVariable "fza_sfmplus_emptyMassFCR";
    _emptyMom  = _heli getVariable "fza_sfmplus_emptyMomFCR";
} else {
    _emptyMass = _heli getVariable "fza_sfmplus_emptyMassNonFCR";
    _emptyMom  = _heli getVariable "fza_sfmplus_emptyMomNonFCR";
};

//Crew
private _cpgMass     = 113.4;   //kg - 250lbs
private _cpgMom      = _cpgMass * (_armCPG select 1);

private _pltMass     = 113.4;   //kg - 250lbs
private _pltMom      = _pltMass * (_armPLT select 1);

private _crewMass    = _cpgMass + _pltMass;//(count (fullcrew _heli)) * 113.4; //kg - 250lbs per individual

//Fwd and Aft Fuel Cells
([_heli] call fza_sfmplus_fnc_fuelSet)
    params ["_fwdFuelMass", "_ctrFuelMass", "_aftFuelMass"];

_fwdFuelMass = _fwdFuelMass - 158;
_aftFuelMass = _aftFuelMass - 158;

private _fwdFuelMom = _fwdFuelMass * (_armFwdFuelCell select 1);
private _ctrFuelMom = _ctrFuelMass * (_armAmmoBay select 1);
private _aftFuelMom = _aftFuelMass * (_armAftFuelCell select 1);

private _fuelMass   = _fwdFuelMass + _aftFuelMass;

//1200rd Magazine or Robbie Tank
private _magMass         = [_heli] call fza_sfmplus_fnc_massUpdateMagazine;
private _magMom          = _magMass * (_armAmmoBay select 1);

private _ammoBayMass     = _ctrFuelMass + _magMass;
private _ammoBayMom      = _ctrFuelMom + _magMom;

//Station 1
private _station1Mass    = [_heli,  0,  1,  4] call fza_sfmplus_fnc_massUpdateStation;
private _station1LatMom  = _station1Mass * (_armStation01 select 0);
private _station1LongMom = _station1Mass * (_armStation01 select 1);
//Station 2
private _station2Mass    = [_heli,  4,  5,  8] call fza_sfmplus_fnc_massUpdateStation;
private _station2LatMom  = _station2Mass * (_armStation02 select 0);
private _station2LongMom = _station2Mass * (_armStation02 select 1);
//Station 3
private _station3Mass    = [_heli,  8,  9, 12] call fza_sfmplus_fnc_massUpdateStation;
private _station3LatMom  = _station3Mass * (_armStation03 select 0);
private _station3LongMom = _station3Mass * (_armStation03 select 1);
//Station 4
private _station4Mass    = [_heli, 12, 13, 16] call fza_sfmplus_fnc_massUpdateStation;
private _station4LatMom  = _station4Mass * (_armStation04 select 0);
private _station4LongMom = _station4Mass * (_armStation04 select 1);

private _stationMass     = _station1Mass + _station2Mass + _station3Mass + _station4Mass;

//Calculate the total current mass of the helicopter
_curMass    = _emptyMass + _crewMass + _fuelMass + _ammoBayMass + _stationMass;
_curLongMom = _emptyMom + _cpgMom + _pltMom + _fwdFuelMom + _ammoBayMom + _aftFuelMom + _station1LongMom + _station2LongMom + _station3LongMom + _station4LongMom;
_curLongCG  = _curLongMom / _curMass;

_curLatMom  = _station1LatMom + _station2LatMom + _station3LatMom + _station4LatMom;
_curLatCG   = _curLatMom / _curMass;

_heli setCenterOfMass [_curLatCG, 7.12 - _curLongCG, -1.34];

//systemChat format ["Total Mass = %1 lbs (%2 kg) -- Total Moment = %3 -- Long CG = %4 in -- Lat CG = %5 in", (_curMass * 2.20462) toFixed 1, _curMass toFixed 1, _curLongMom toFixed 3, (_curLongCG * 39.3701) toFixed 1, (_curLatCG * 39.3701) toFixed 1];

if (local _heli) then {
    _heli setMass _curMass;
};
_heli setVariable ["fza_sfmplus_GWT", _curMass];
_heli setVariable ["fza_sfmplus_CG",  _curLongCG];


#ifdef __A3_DEBUG__
private _vecX = [5.0, 0.0, 0.0];
private _vecY = [0.0, 5.0, 0.0];
private _vecZ = [0.0, 0.0, 5.0];

//Draw the force vector
private _heliCoM = getCenterOfMass _heli;

[_heli, _heliCoM, _heliCoM vectorAdd _vecX, "red"]   call fza_fnc_debugDrawLine;
[_heli, _heliCoM, _heliCoM vectorAdd _vecY, "green"] call fza_fnc_debugDrawLine;
[_heli, _heliCoM, _heliCoM vectorAdd _vecZ, "blue"]  call fza_fnc_debugDrawLine;
#endif