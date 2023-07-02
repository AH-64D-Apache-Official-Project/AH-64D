params ["_heli"];

#define SCALE_METERS_FEET 3.28084

private _barAlt = getPosASL _heli # 2 * SCALE_METERS_FEET;
_barAlt = round (_barAlt / 10) * 10;

private _radAlt = getPos _heli # 2 * SCALE_METERS_FEET;
if (_radAlt > 50) then {
    _radAlt = round (_radAlt / 10) * 10;
};

[_barAlt, _radAlt];