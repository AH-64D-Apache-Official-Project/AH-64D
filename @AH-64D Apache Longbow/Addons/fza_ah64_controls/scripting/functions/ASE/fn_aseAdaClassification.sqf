/* ----------------------------------------------------------------------------
Function: fza_fnc_aseAdaClassification

Description:
	handles returns anti air classification

Parameters:
	_object - Anti air unit

Returns:
	_Classification

Examples:
    _Classification = [_object] call fza_fnc_aseAdaClassification

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_Object"];
private _Classification = "radar";

//Generic radar
if (_Object iskindof "B_SAM_System_01_F") 				then {_Classification = "radar"};
if (_Object iskindof "B_SAM_System_02_F") 				then {_Classification = "radar"};
if (_Object iskindof "I_LT_01_scout_F") 				then {_Classification = "radar"};
if (_Object iskindof "I_LT_01_AA_F") 					then {_Classification = "radar"};
//ZSU
if (_Object iskindof "CUP_ZSU23_Base") 					then {_Classification = "zsu"};
if (_Object iskindof "rhs_zsutank_base") 				then {_Classification = "zsu"};
if (_Object iskindof "gm_gc_army_zsu234v1") 			then {_Classification = "zsu"};
if (_Object iskindof "pook_ZSU_base") 					then {_Classification = "zsu"};
//2s6
if (_Object iskindof "B_APC_Tracked_01_AA_F") 			then {_Classification = "2S6"};
if (_Object iskindof "O_APC_Tracked_02_AA_F") 			then {_Classification = "2S6"};
if (_Object iskindof "vn_o_static_rsna75") 				then {_Classification = "2S6"};
if (_Object iskindof "vn_sa2") 							then {_Classification = "2S6"};
//sa2
if (_Object iskindof "pook_SNR75_radar_base") 			then {_Classification = "sa2"};
if (_Object iskindof "vn_o_static_rsna75") 				then {_Classification = "sa2"};
//sa3
if (_Object iskindof "pook_SA3_radar_base") 			then {_Classification = "sa3"};
//sa8
if (_Object iskindof "pook_SA8_base") 					then {_Classification = "sa8"};
//sa10
if (_Object iskindof "Radar_System_01_base_F") 			then {_Classification = "sa10"};
if (_Object iskindof "Radar_System_02_base_F") 			then {_Classification = "sa10"};
if (_Object iskindof "SAM_System_03_base_F") 			then {_Classification = "sa10"};
if (_Object iskindof "SAM_System_04_base_F") 			then {_Classification = "sa10"};
if (_Object iskindof "pook_30N6E_mast") 				then {_Classification = "sa10"};
if (_Object iskindof "pook_30N6E_base") 				then {_Classification = "sa10"};
//sa11
if (_Object iskindof "pook_9S36_Root") 					then {_Classification = "sa11"};
//sa15
if (_Object iskindof "pook_9K331_Root") 				then {_Classification = "sa15"};
if (_Object iskindof "pook_9K332_Root") 				then {_Classification = "sa15"};
//sa17
if (_Object iskindof "pook_9K317_Root") 				then {_Classification = "sa17"};
if (_Object iskindof "pook_9K317M2_Root") 				then {_Classification = "sa17"};
if (_Object iskindof "pook_9K317M3_Root") 				then {_Classification = "sa17"};
//sa19
if (_Object iskindof "pook_SA19_root") 					then {_Classification = "sa19"};
//SA20
if (_Object iskindof "pook_30N6E2_mast") 				then {_Classification = "sa20"};
if (_Object iskindof "pook_30N6E2_Base") 				then {_Classification = "sa20"};
//sa21
if (_Object iskindof "pook_92N6E_mast") 				then {_Classification = "sa21"};
if (_Object iskindof "pook_92N6E_base") 				then {_Classification = "sa21"};
//sa22
if (_Object iskindof "pook_96K6_root") 					then {_Classification = "sa22"};
//Gun
if (_Object iskindof "B_AAA_System_01_F") 				then {_Classification = "gun"};
if (_Object iskindof "gm_ge_army_gepard1a1") 			then {_Classification = "gun"};
if (_Object iskindof "pook_CRAM_BASE") 					then {_Classification = "gun"};
//hawk
if (_Object iskindof "pook_BCP_root") 					then {_Classification = "Hawk"};
//Navel
if (_Object iskindof "Ship") 							then {_Classification = "Navel"};
if (_Object iskindof "Ship_F") 							then {_Classification = "Navel"};
if (_Object iskindof "Boat_F") 							then {_Classification = "Navel"};

_Classification;