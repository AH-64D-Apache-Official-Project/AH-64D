#include "\fza_ah64_mpd\headers\mfdConstants.h"
#define KG_TO_LBS 2.20462
#define MAX_PA 8000

params ["_heli", "_mpdIndex"];

private _config  = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";

private _pa      = _heli getVariable "fza_sfmplus_PA";  //feet
private _fat     = _heli getVariable "fza_sfmplus_FAT";
private _gwt     = (_heli getVariable "fza_sfmplus_GWT") * KG_TO_LBS;
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_PA),  _pa  toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_FAT), _fat toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_GWT), _gwt toFixed 0];
/////////////////////////////////////////////////////////////////////////////////////////////
// Required torque  /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _reqTQ_IGE     = round ((_heli getVariable "fza_sfmplus_hvrTQ_IGE") * 100);
private _reqTQ_OGE     = round ((_heli getVariable "fza_sfmplus_hvrTQ_OGE") * 100);
//Set required IGE/OGE torque
private _reqTQ_text    = format["REQUIRED %1 %2", [str _reqTQ_IGE, 3] call fza_fnc_padString, [str _reqTQ_OGE, 3] call fza_fnc_padString];
if (_pa > MAX_PA) then { _reqTQ_text = format["REQUIRED   ?   ?"]; };
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_HVR_TQ_IGE_OGE), _reqTQ_text];
/////////////////////////////////////////////////////////////////////////////////////////////
// Indicated torque /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _eng1TQ        = round ((_heli getVariable "fza_sfmplus_engPctTQ" select 0) * 100);
private _eng2TQ        = round ((_heli getVariable "fza_sfmplus_engPctTQ" select 1) * 100);
private _indTQ         = _eng1TQ max _eng2TQ;
private _indTQ_text    = format["INDICATED  %1", [str _indTQ, 3] call fza_fnc_padString];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_IND_TQ), _indTQ_text];
/////////////////////////////////////////////////////////////////////////////////////////////
// Go/no-go torque  /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _goNoGoTQ_IGE  = round ((_heli getVariable "fza_sfmplus_goNoGoTQ_IGE") * 100);
private _goNoGoTQ_OGE  = round ((_heli getVariable "fza_sfmplus_goNoGoTQ_OGE") * 100);
//Set go/no-go torque
private _goNoGoTQ_text = format["GO-NO/GO %1 %2", [str _goNoGoTQ_IGE, 3] call fza_fnc_padString, [str _goNoGoTQ_OGE, 3] call fza_fnc_padString];
if (_pa > MAX_PA) then { _goNoGoTQ_text = format["GO-NO/GO   ?   ?"]; };
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_GO_NOGO_TQ_IGE_OGE), _goNoGoTQ_text];
/////////////////////////////////////////////////////////////////////////////////////////////
// Max GWT          /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//Dual engine
private _maxGWT_DE_IGE    = round ((_heli getVariable "fza_sfmplus_maxGWT_DE_IGE") / 10) * 10;
private _maxGWT_DE_OGE    = round ((_heli getVariable "fza_sfmplus_maxGWT_DE_OGE") / 10) * 10;
//Set max GWT IGE/OGE
private _maxGWT_DE_text   = format["   %1   %2", _maxGWT_DE_IGE, _maxGWT_DE_OGE];
if (_pa > MAX_PA) then { _maxGWT_DE_text = format["     ?       ?  "]; };
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_MAXGWT_DE_IGE_OGE), _maxGWT_DE_text];
//Single engine
private _maxGWT_SE_IGE    = round ((_heli getVariable "fza_sfmplus_maxGWT_SE_IGE") / 10) * 10;
if (_maxGWT_SE_IGE < 11000) then { _maxGWT_SE_IGE = 11000; };
private _maxGWT_SE_OGE    = round ((_heli getVariable "fza_sfmplus_maxGWT_SE_OGE") / 10) * 10;
if (_maxGWT_SE_OGE < 11000) then { _maxGWT_SE_OGE = 11000; };
//Set max GWT IGE/OGE
private _maxGWT_SE_text   = format["   %1   %2", _maxGWT_SE_IGE, _maxGWT_SE_OGE];
if (_pa > MAX_PA) then { _maxGWT_SE_text = format["     ?       ?  "]; };
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_MAXGWT_SE_IGE_OGE), _maxGWT_SE_text];
/////////////////////////////////////////////////////////////////////////////////////////////
// Max torque DE/SE /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _maxTQ_DE      = round((_heli getVariable "fza_sfmplus_maxTQ_DE") * 100);
private _maxTQ_SE      = round((_heli getVariable "fza_sfmplus_maxTQ_SE") * 100);
//Set max torque DE
private _maxTQ_DE_text = format["   %1", [str _maxTQ_DE, 3] call fza_fnc_padString];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_MAX_TQ_DE), _maxTQ_DE_text];
//Set max troque SE
private _maxTQ_SE_text = format["   %1", [str _maxTQ_SE, 3] call fza_fnc_padString];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_MAX_TQ_SE), _maxTQ_SE_text];
/////////////////////////////////////////////////////////////////////////////////////////////
// Cruise Data      /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _rngTQ = round((_heli getVariable "fza_sfmplus_TAS_rngTQ") * 100);
private _endTQ = round((_heli getVariable "fza_sfmplus_TAS_endTQ") * 100);
//Set max range and endurance torque
private _maxRngEndTQ_text = format[" Q  %1  %2", [str _rngTQ, 3] call fza_fnc_padString, [str _endTQ, 3] call fza_fnc_padString];
if (_pa > MAX_PA) then { _maxRngEndTQ_text = format[" Q   ?    ? "]; };
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_MAX_RNG_END_TQ), _maxRngEndTQ_text];

private _rngFF = round((_heli getVariable "fza_sfmplus_TAS_rngFF") / 10) * 10;
private _endFF = round((_heli getVariable "fza_sfmplus_TAS_endFF") / 10) * 10;
//Set max range and endurance fuel flow
private _maxRngEndFF_text = format["FF %1 %2", [str _rngFF, 4] call fza_fnc_padString, [str _endFF, 4] call fza_fnc_padString];
if (_pa > MAX_PA) then { _maxRngEndFF_text = format["FF   ?    ? "]; };
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_MAX_RNG_END_FF), _maxRngEndFF_text];
/////////////////////////////////////////////////////////////////////////////////////////////
// TAS Data         /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _vneTAS  = round(_heli getVariable "fza_sfmplus_TAS_vne");
private _vsseTAS = round(_heli getVariable "fza_sfmplus_TAS_vsse");
private _rngTAS  = round(_heli getVariable "fza_sfmplus_TAS_rngTAS");
private _endTAS  = round(_heli getVariable "fza_sfmplus_TAS_endTAS");
//Set vne, vsse, range and end airspeeds
private _vne_text    = format[" VNE %1", [str _vneTAS, 3] call fza_fnc_padString];
private _vsse_text   = format["VSSE %1", [str _vsseTAS, 3] call fza_fnc_padString];
private _rngTAS_text = format[" RNG %1", [str _rngTAS, 3] call fza_fnc_padString];
private _endTAS_text = format[" END %1", [str _endTAS, 3] call fza_fnc_padString];

if (_pa > MAX_PA) then { 
    _vne_text    = format[" VNE  ? "];
    _vsse_text   = format["VSSE  ? "]; 
    _rngTAS_text = format[" RNG  ? "]; 
    _endTAS_text = format[" END  ? "];  
};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_VNE),     _vne_text];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_VSSE),    _vsse_text];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_RNG_SPD), _rngTAS_text];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_END_SPD), _endTAS_text];
/////////////////////////////////////////////////////////////////////////////////////////////
// Wind Data        /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
_heli call fza_sfmplus_fnc_getWindDirVel
    params ["_windDir", "_windVel"];
private _wind_text = format["WIND %1/%2", [_windDir, 3] call CBA_fnc_formatNumber, _windVel];
if (_windvel < 5) then {_wind_text = "WIND CALM";};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WIND), _wind_text];