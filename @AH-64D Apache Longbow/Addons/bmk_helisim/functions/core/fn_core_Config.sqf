params ["_heli"];

private _mainRotor_numBlades    = 4;
_heli setVariable ["bmk_helisim_mainRotor_numBlades", _mainRotor_numBlades];
private _mainRotor_bladeRadius  = 7.315; //m
_heli setVariable ["bmk_helisim_mainRotor_bladeRadius", _mainRotor_bladeRadius];
private _mainRotor_bladeChord   = 0.533; //m
_heli setVariable ["bmk_helisim_mainRotor_bladeChord", _mainRotor_bladeChord];
private _mainRotor_gearRatio    = 72.29;
_heli setVariable ["bmk_helisim_mainRotor_gearRatio", _mainRotor_gearRatio];