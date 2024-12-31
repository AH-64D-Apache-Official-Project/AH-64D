/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_damageApply <-- rename me to perfLimit, move to engine

Description:
    Applies damage within a defined period of time after exceeding aircraft
    operating limits. 

Parameters:
    _heli      - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

if (!local _heli) exitWith {};

private _pctNR       = (_heli getVariable "fza_sfmplus_engNp" select 0) max (_heli getVariable "fza_sfmplus_engNp" select 1);
private _eng1PctTQ   = _heli getVariable "fza_sfmplus_engTq_req" select 0;
private _eng2PctTQ   = _heli getVariable "fza_sfmplus_engTq_req" select 1;
private _engPctTQ    = _eng1PctTQ max _eng2PctTQ;
private _isOEI = _heli getVariable "fza_sfmplus_engIsOEI";
private _maxTQ_DE    = _heli getVariable "fza_sfmplus_maxTQ_DE";
private _maxTQ_SE    = _heli getVariable "fza_sfmplus_maxTQ_SE";
private _droopRotor  = false;

if (isEngineOn _heli) then {
    //With the power levers at idle
    if (_pctNR <= 50.0 && _engPctTQ >= 30.0) then {
        _droopRotor = true;
    };

    if (_pctNR > 90.0) then {
        if (_isOEI) then {
            if (_engPctTQ > _maxTQ_SE) then {
                _droopRotor = true;
            } else {
                _droopRotor = false;
            };
        } else {
            if (_eng1PctTQ > _maxTQ_DE) then {
                _droopRotor = true;
            } else {
                _droopRotor = false;
            };
        };
    };
};

if (_droopRotor) then {
    fza_sfmplus_liftLossTimer = (fza_sfmplus_liftLossTimer + 0.01) max 0 min 1;
} else {
    fza_sfmplus_liftLossTimer = (fza_sfmplus_liftLossTimer - 0.05) max 0 min 1;
};