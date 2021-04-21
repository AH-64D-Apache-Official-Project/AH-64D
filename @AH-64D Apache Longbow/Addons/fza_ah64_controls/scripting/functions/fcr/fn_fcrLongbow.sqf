/* ----------------------------------------------------------------------------
Function: fza_fnc_fcrLongbow
Description:
    Fire control Radar script that takes target from sens radar and adds it to 
    fza_ah64_targetlist & fza_ah64_fcrlist
Parameters:
Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_fcrLongbow;
Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
if (!(isNil "fza_ah64_nofcr")) exitwith {};
_heli = vehicle player;

#define AGMODE_GND 0
#define AGMODE_AIR 1
_datalinkarray = [];
_ticker = 10;


if ((diag_ticktime - fza_ah64_overalltickerSlow) > _ticker) then {
    fza_ah64_overalltickerSlow= diag_ticktime; 
    if (isVehicleRadarOn _heli && (_heli animationPhase "fcr_enable" == 1) && _heli getHit "radar" < 0.8) then {
        fza_ah64_dataLinkArray = vehicles select {(_x distance _heli) < 10000 && !(_x isKindOf "StaticCannon") && !(_x == _heli)};
    };
};

if ((vehicle player) animationphase "plt_apu" > 0.5 || (isEngineOn _heli)) then {
	if (isVehicleRadarOn _heli && (_heli animationPhase "fcr_enable" == 1) && _heli getHit "radar" < 0.8) then {
        _datalinkarray = fza_ah64_dataLinkArray;
		{
			if (alive _x) then {
				_distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _x select 0), (getposatl _x select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);

				if ((_heli getVariable "fza_ah64_agmode" == AGMODE_GND) && (_distOffAxis > 45)) then {
					_dataLinkArray = _dataLinkArray - [_x];
				};				
				if (_heli getVariable "fza_ah64_agmode" == AGMODE_AIR && !(_x isKindOf "air")) then {
					_dataLinkArray = _dataLinkArray - [_x];
				};
                if ([_heli, "VIEW", _x] checkVisibility [eyePos player, aimPos _x] == 0) then {
                    _dataLinkArray = _dataLinkArray - [_x];
                };
				if ((_x distance _heli) > 8000) then {
                    _dataLinkArray = _dataLinkArray - [_x];
                };
				sleep 0.10;
			};
		}   foreach _dataLinkArray;
		fza_ah64_targetlist = fza_ah64_targetlist + _dataLinkArray;
	};
};
fza_ah64_fcrlist = _dataLinkArray;

[_heli] call fza_fnc_targetingVariable;