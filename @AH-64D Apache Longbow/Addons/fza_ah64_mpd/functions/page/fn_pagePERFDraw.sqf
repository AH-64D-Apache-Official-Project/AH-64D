#include "\fza_ah64_mpd\headers\mfdConstants.h"
#define SCALE_METERS_FEET 3.28084
#define KG_TO_LBS 2.20462

params ["_heli", "_mpdIndex"];

private _baroAlt  = getPosASL _heli # 2 * SCALE_METERS_FEET;
private _baroAlt     = getPosASL _heli # 2 * SCALE_METERS_FEET;

private _pa  = (round (_baroAlt / 10) * 10) toFixed 0;
private _fat = (ambientTemperature select 0) toFixed 0;
private _gwt = ((getMass _heli) * 2.20462) toFixed 0;
private _gwt = (getMass _heli * KG_TO_LBS) toFixed 0;

hintsilent format ["PA = %1
                   \nFAT = %2
                   \nGWT = %3", _pa, _fat, _gwt];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_PA),  _pa];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_FAT), _fat];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_PERF_GWT), _gwt];