#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex"];

private _laserFreqs = _heli getVariable "fza_ah64_laserChannelIndex";

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_A), str(_laserFreqs get "A")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_B), str(_laserFreqs get "B")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_C), str(_laserFreqs get "C")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_D), str(_laserFreqs get "D")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_E), str(_laserFreqs get "E")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_F), str(_laserFreqs get "F")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_G), str(_laserFreqs get "G")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_H), str(_laserFreqs get "H")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_J), str(_laserFreqs get "J")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_K), str(_laserFreqs get "K")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_L), str(_laserFreqs get "L")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_M), str(_laserFreqs get "M")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_N), str(_laserFreqs get "N")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_P), str(_laserFreqs get "P")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_Q), str(_laserFreqs get "Q")];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_R), str(_laserFreqs get "R")];
