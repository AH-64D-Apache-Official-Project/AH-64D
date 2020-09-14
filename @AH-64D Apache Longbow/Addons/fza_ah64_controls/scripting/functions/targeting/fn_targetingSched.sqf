private["_heli"];
_heli = _this select 0;
if (!(player in _heli)) exitwith {};
private _visibleTargets = [];

fza_ah64_tsdtargets = fza_ah64_targetlist;
fza_ah64_tsddisptargs = [];

//_heli vehiclechat format ["%1",fza_ah64_dispfcrlist];
//////////sort targets for helicopter/////////
{
    _i = _x;
    fza_ah64_tsdtargets = fza_ah64_tsdtargets - [_i];
    fza_ah64_tsddisptargs = fza_ah64_tsddisptargs - [_i];

    if (fza_ah64_tsdsort < 4) then {
        {
            if (_i iskindof _x) then {
                fza_ah64_tsdtargets = fza_ah64_tsdtargets + [_i];
                fza_ah64_tsddisptargs = fza_ah64_tsddisptargs + [_i];
            };
        }
        foreach fza_ah64_tsdsortarray;
    } else {
        if (_i in fza_ah64_tsdsortarray) then {
            fza_ah64_tsdtargets = fza_ah64_tsdtargets + [_i];
            fza_ah64_tsddisptargs = fza_ah64_tsddisptargs + [_i];
        };
    };

    _theta = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _i select 0), (getposatl _i select 1)] call fza_fnc_relativeDirection;

    if ((fza_ah64_agmode == 1 && getpos _i select 2 < 10) || (_theta > 45 && _theta < 315) || (fza_ah64_agmode == 0 && getpos _i select 2 > 10) || (((_heli distance _i) * fza_ah64_rangesetting) > 1) || !(alive _i)) then {
        fza_ah64_tsdtargets = fza_ah64_tsdtargets - [_i];
    };
    if ((((_heli distance _i) * fza_ah64_rangesetting > 0.2) && (_theta > 90 && _theta < 270)) || ((_heli distance _i) * fza_ah64_rangesetting > 1) || !(alive _i)) then {
        fza_ah64_tsddisptargs = fza_ah64_tsddisptargs - [_i];
        fza_ah64_tsdtargets = fza_ah64_tsdtargets - [_i];
    };

}
foreach fza_ah64_tsdtargets;

if ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "fcr") then {
    fza_ah64_tsdtargets = fza_ah64_dispfcrlist;
};

_visibleTargets =
    if ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "fcr") then {
        fza_ah64_dispfcrlist;
    } else {
        if (fza_ah64_pfz_count == 0) then {
            fza_ah64_tsdtargets;
        }
        else {
            fza_ah64_currentpfz;
        }
    };

if (count fza_ah64_tsdtargets == 0 && isNull fza_ah64_mycurrenttarget) then {
    fza_ah64_mycurrenttarget = objNull;
};
if (inputAction "vehLockTargets" > 0.5 && fza_ah64_locktargstate == 0 && count fza_ah64_tsdtargets > 0) then {
    if (fza_ah64_mynum >= count _visibleTargets - 1) then {
        fza_ah64_mynum = 0;
    } else {
        fza_ah64_mynum = fza_ah64_mynum + 1;
    };
    fza_ah64_mycurrenttarget = _visibleTargets select(fza_ah64_mynum);
    fza_ah64_locktargstate = 1;
};
if (inputAction "vehLockTargets" < 0.5 && fza_ah64_locktargstate == 1) then {
    fza_ah64_locktargstate = 0;
};
if (fza_ah64_agmode == 2) then {
    fza_ah64_mycurrenttarget = cursortarget;
};