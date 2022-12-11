params ["_heli", "_engine"];

private _numEng        = count _engine;
private _eng1GovOutput = 0.0;
private _eng2GovOutput = 0.0;

if (_numEng < 1 || _numEng > 2) exitWith { systemChat format ["Invalid engine configuration!"];  };

if (_numEng == 1) then {

};

if (_numEng == 2) then {
    //Engine 1


    //Engine 2
    

};