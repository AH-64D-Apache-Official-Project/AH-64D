params ["_lat", "_long"];

private _eastWest   = ["N", "S"] select (_lat >= 0);
private _northSouth = ["E", "W"] select (_long >= 0);

private _ewDegrees = [abs _lat, 2, 0] call CBA_fnc_formatNumber;
private _ewMinutes = [(abs _lat * 60) % 60, 2, 0] call CBA_fnc_formatNumber;
private _ewSeconds = [(abs _lat * 360) % 60, 2, 0] call CBA_fnc_formatNumber;

private _nsDegrees = [abs _long, 3, 0] call CBA_fnc_formatNumber;
private _nsMinutes = [(abs _long * 60) % 60, 2, 0] call CBA_fnc_formatNumber;
private _nsSeconds = [(abs _long * 360) % 60, 2, 0] call CBA_fnc_formatNumber;


format ["%1%2 %3.%4 %5%6 %7.%8"
    ,_eastWest
    , _ewDegrees
    , _ewMinutes
    , _ewSeconds
    , _northSouth
    , _nsDegrees
    , _nsMinutes
    , _nsSeconds];