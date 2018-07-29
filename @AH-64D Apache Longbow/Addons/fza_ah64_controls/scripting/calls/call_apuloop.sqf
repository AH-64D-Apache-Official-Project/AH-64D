params["_heli"];

if(fza_ah64_apuon isEqualTo 1)then
{
    private _veh = "VR_3DSelector_01_default_F" createVehicle [0,0,0];
    _veh attachTo [_heli,[0,0,0]];

    hideObject _veh; 
    private _targetTime = time + 24.500;
    while {fza_ah64_apuon isEqualTo 1} do 
    {
        if (time > _targetTime) then 
        {
            _targetTime = time + 60.876;
            _veh say3D ["fza_ah64_loop_3D",200,1];
        };
    };
    deleteVehicle _veh;
};