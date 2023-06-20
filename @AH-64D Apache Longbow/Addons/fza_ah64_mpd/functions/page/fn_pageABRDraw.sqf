params["_heli", "_mpdIndex"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"


private _abrPage        = _heli Getvariable "fza_ah64_abr_PageNum";
private _pageNum        = _abrPage # _mpdIndex;

_heli setUserMfdtext  [MFD_INDEX_OFFSET(MFD_IND_ABR_PAGENUM), str _pageNum];
_heli setUserMfdvalue [MFD_INDEX_OFFSET(MFD_IND_ABR_PAGE), _pageNum];