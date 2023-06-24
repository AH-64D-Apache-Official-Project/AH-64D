params["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _pageNumber = _state get "pageNumber";

_heli setUserMfdtext  [MFD_INDEX_OFFSET(MFD_IND_ABR_PAGENUM), str _pageNumber];
_heli setUserMfdvalue [MFD_INDEX_OFFSET(MFD_IND_ABR_PAGE), _pageNumber];