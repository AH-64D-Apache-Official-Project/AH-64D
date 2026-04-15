params["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _pageNumber = _persistState get "pageNumber";
private _pageNumberstr = str _pageNumber + "/" + str MFD_ABR_NUMPAGES;

_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_IND_ABR_PAGENUM), _pageNumberstr];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ABR_PAGE), _pageNumber];
