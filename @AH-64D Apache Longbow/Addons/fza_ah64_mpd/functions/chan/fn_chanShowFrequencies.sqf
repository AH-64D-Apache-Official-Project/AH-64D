#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex"];

private _laserFreqs = _heli getVariable "fza_ah64_laserChannelIndex";

[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_A), str(_laserFreqs get "A")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_B), str(_laserFreqs get "B")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_C), str(_laserFreqs get "C")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_D), str(_laserFreqs get "D")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_E), str(_laserFreqs get "E")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_F), str(_laserFreqs get "F")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_G), str(_laserFreqs get "G")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_H), str(_laserFreqs get "H")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_J), str(_laserFreqs get "J")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_K), str(_laserFreqs get "K")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_L), str(_laserFreqs get "L")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_M), str(_laserFreqs get "M")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_N), str(_laserFreqs get "N")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_P), str(_laserFreqs get "P")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_Q), str(_laserFreqs get "Q")] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FREQ_R), str(_laserFreqs get "R")] call fza_mpd_fnc_updateMfdText;