private ["_heli"];
_heli = _this select 0;

if(!(player in _heli)) exitwith {};

fza_ah64_tsdtargets = fza_ah64_targetlist;
fza_ah64_tsddisptargs = [];
//////////sort targets for helicopter/////////

{
_i = _x;
fza_ah64_tsdtargets = fza_ah64_tsdtargets - [_i];

if(fza_ah64_tsdsort < 4) then
{
	{
		if (_i iskindof _x) then {fza_ah64_tsdtargets = fza_ah64_tsdtargets + [_i]; fza_ah64_tsddisptargs = fza_ah64_tsddisptargs + [_i];};
	} foreach fza_ah64_tsdsortarray;
} else {
	if (_i in fza_ah64_tsdsortarray) then {fza_ah64_tsdtargets = fza_ah64_tsdtargets + [_i]; fza_ah64_tsddisptargs = fza_ah64_tsddisptargs + [_i];};
};

_theta = [_heli,(getposatl _heli select 0),(getposatl _heli select 1),(getposatl _i select 0),(getposatl _i select 1)] call fza_ah64_reldir;

if((fza_ah64_agmode == 1 && getpos _i select 2 < 50) || (_theta > 45 && _theta < 315) || (fza_ah64_agmode == 0 && getpos _i select 2 > 50) || (((_heli distance _i) * rangesetting) > 1) || !(alive _i)) then {fza_ah64_tsdtargets = fza_ah64_tsdtargets - [_i];};
if((((_heli distance _i) * rangesetting > 0.2) && (_theta > 90 && _theta < 270)) || ((_heli distance _i) * rangesetting > 1) || !(alive _i)) then {fza_ah64_tsddisptargs = fza_ah64_tsddisptargs - [_i];};
} foreach fza_ah64_tsdtargets;

///FCR///

