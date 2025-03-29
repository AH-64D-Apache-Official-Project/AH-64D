params["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _pageNumber = _persistState get "pageNumber";
private _pageNumberstr = str _pageNumber + "/" + str MFD_ABR_NUMPAGES;

[_heli, MFD_INDEX_OFFSET(MFD_IND_ABR_PAGENUM), _pageNumberstr] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_IND_ABR_PAGE), _pageNumber] call fza_mpd_fnc_updateMfdValue;