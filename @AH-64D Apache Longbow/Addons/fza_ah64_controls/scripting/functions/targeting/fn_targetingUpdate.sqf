/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingUpdate
Description:
	Handles repetitive ASE targeting information management. Should be run regularly.
Parameters:
	_heli - The helicopter to act on
Returns:
	Nothing
Examples:
	--- Code
    [_heli] call fza_fnc_targetingUpdate
	---
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
Private _asearray = fza_ah64_AseRWR;
Private _trackingarray = [];
{
	private _ADA = _x # 0;
	private _type = _x # 1;
	private _sensor = _x # 2;
	if ((vehicle player) animationphase "plt_apu" > 0.5 || (isEngineOn _heli)) then {
		if (!(_type == "missile") && ("radar" in _sensor) && (alive _ADA)) then {
			//TSD & ASE Draw
			if !(_ADA in fza_ah64_targetlist) then {
				fza_ah64_targetlist pushBack _ADA;
			};
			if !(_ADA in _asearray) then {
				_asearray pushBack _ADA;
			};
			
			if (_type == "locked") then {
				_trackingarray pushBack _ADA;
				
				//confirm ada hostile for team
				_ADA confirmSensorTarget [playerSide, true];

				//ASE autopage
				if (_heli getVariable "fza_ah64_aseautopage" == 1) then {
					[_heli, 1, "ase"] call fza_fnc_mpdSetDisplay;
				};

				//audio 
				if (_ADA iskindof "rhs_zsutank_base") then {
					["fza_ah64_zsu23_track", 2.3] spawn fza_fnc_playAudio;
				};
				if (_ADA iskindof "O_APC_Tracked_02_AA_F") then {
					["fza_ah64_bt_sa19", 1.6, "fza_ah64_bt_tracking", 0.65] spawn fza_fnc_playAudio;
				};
				if !((_ADA iskindof "rhs_zsutank_base") || (_ADA iskindof "O_APC_Tracked_02_AA_F")) then {
					["fza_ah64_rdr_track", 0.1] spawn fza_fnc_playAudio;
				};
			};
		};
	};
	sleep 0.1;
} forEach getSensorThreats _heli;

fza_ah64_threattracking = _trackingarray;
fza_ah64_asethreatsdraw = _asearray;

/* tracking audio repeats
ASE ICON
FW FIxed wing CSCOPE PLANE
RW  Rotor wing CSCOPE HELI
sa 12/5 s300 Long rane launcher