/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponRocketAlign

Description:
    Positions the rocket to the correct location
    Uses the event handler format

Parameters:
    _heli - The helicopter that fired it
    _unused - Unused
    _unused - Unused
    _unused - Unused
    _unused - Unused
    _unused - Unused
    _missobj - The missile unit that fired it

Returns:
	Nothing

Examples:

Author:
	unknown
---------------------------------------------------------------------------- */
params ["_heli", "", "", "", "", "", "_missobj"];
_mags = magazines _heli;
if (typeOf _missobj == "fza_275_m151" || typeOf _missobj == "fza_275_m229" || typeOf _missobj == "fza_275_m255" || typeOf _missobj == "fza_275_m261" || typeOf _missobj == "fza_275_m257") then {
    if (local _missobj) then {
        _pbvar2 = _heli call fza_fnc_getPitchBank;
        _helipitch = _pbvar2 select 0;
        _helibank = _pbvar2 select 1;
        _pbvar = _missobj call fza_fnc_getPitchBank;
        _dir = direction _missobj + ((_heli animationphase "pylon1") * 10) * (sin _helibank) + (random 0.3) + (random - 0.3);
        _angle = (_pbvar select 0) + ((_heli animationphase "pylon1") * 10) * (cos _helibank) + (random 0.2) + (random - 0.2);
        _pitch = (_pbvar select 1) + (random 0.2) + (random - 0.2);

        _vecdx = sin(_dir) * cos(_angle);
        _vecdy = cos(_dir) * cos(_angle);
        _vecdz = sin(_angle);

        _vecux = cos(_dir) * cos(_angle) * sin(_pitch);
        _vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
        _vecuz = cos(_angle) * cos(_pitch);

        _missobj setvelocity[0, 0, 0];

        _missobj setVectorDirAndUp[[_vecdx, _vecdy, _vecdz], [_vecux, _vecuy, _vecuz]];

        fza_ah64_salvofired = fza_ah64_salvofired + 1;
    };
    [_missobj] call fza_ah64_fx_rktmsl;
};