///this script tracks fuel associated functions
#include "\fza_ah64_controls\headers\selections.h"
if (!(isNil "fza_ah64_nofuel")) exitwith {};
_heli = _this select 0;
_iafs100qty = 0.27;
_iafs130qty = 0.35;
_waux230qty_1 = 0.62;
_waux230qty_2 = 0.62;
_waux230qty_3 = 0.62;
_waux230qty_4 = 0.62;
_activetank = 0;
_fuelweight = 2538;
_totfuelweight = 2538;
_auxfuelweight1 = 1550;
_auxfuelweight2 = 1550;
_auxfuelweight3 = 1550;
_auxfuelweight4 = 1550;
_fwdfuel = 0;
_aftfuel = 0;
_fwdfuelth = 0;
_fwdfuelhu = 0;
_fwdfuelte = 0;
_fwdfuelsi = 0;
_aftfuelth = 0;
_aftfuelhu = 0;
_aftfuelte = 0;
_aftfuelsi = 0;
_fwdfuelformat1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_fwdfuelformat2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_fwdfuelformat3 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_fwdfuelformat4 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_aftfuelformat1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_aftfuelformat2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_aftfuelformat3 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_aftfuelformat4 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_iafsfuel = 0;
_iafsfuelhu = 0;
_iafsfuelte = 0;
_iafsfuelsi = 0;
_iafsformat1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_iafsformat2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_iafsformat3 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_intfuelth = 0;
_intfuelhu = 0;
_intfuelte = 0;
_intfuelsi = 0;
_intfuelweight = 0;
_totfuelend = 0;
_burnrate = 0;
_curwaux1 = "";
_curwaux2 = "";
_curwaux3 = "";
_curwaux4 = "";
_fueltrigger = false;
_basefuel = fuel _heli;
fza_ah64_fuelsave = 1;

sleep 1;

while {
    (alive _heli)
}
do {
    //TODO: Move back to vanilla arma fuel system.
    if (fuel _heli > 0) then {
        _basefuel = fuel _heli;
    };
    if (!(player == driver _heli || player == gunner _heli)) then {
        _heli setfuel _basefuel;
    };
    waituntil {
        (player == driver _heli || player == gunner _heli)
    };
    if (isNil "fza_ah64_fuelsave") then {
        fza_ah64_fuelsave = fuel _heli;
    };
    _mags = magazines _heli;
    _curfuel = fuel _heli;
    if (_curfuel > 0 && !(isengineon _heli)) then {
        fza_ah64_fuelsave = fuel _heli;
    };
    if (isengineon _heli && player in _heli) then {
        fza_ah64_fuelsave = fuel _heli;
        _fueltrigger = false;
    };
    if (player == driver _heli) then {
        if ("fza_ah64_fwd_leak" in (_heli magazinesturret[-1]) || "fza_ah64_aft_leak" in (_heli magazinesturret[-1])) then {
            fza_ah64_fuelsave = fza_ah64_fuelsave - 0.0003;
        };
        if (fuel _heli > 0 && !(_heli getVariable ["fza_ah64_estarted", false]) && !(_fueltrigger)) then {
            _heli setfuel 0;
            _fueltrigger = true;
        };
        if (!(isengineon _heli) && !(_heli getVariable ["fza_ah64_estarted", false])) then {
            _heli setfuel 0;
        };
        if (_heli getVariable ["fza_ah64_estarted", false] && _fueltrigger) then {
            _heli setfuel fza_ah64_fuelsave;
            fza_ah64_fuelsave = fuel _heli;
            _fueltrigger = false;
        };
    };
    if (local _heli && isengineon _heli) then {
        _fuelused = 1 - fza_ah64_fuelsave;
        if ("fza_iafs_130" in _mags && _iafs130qty > 0) then {
            _activetank = 5;
        };
        if ("fza_iafs_100" in _mags && _iafs100qty > 0) then {
            _activetank = 4;
        };
        if ("fza_auxtank_230_4" in _mags && _waux230qty_4 > 0) then {
            _activetank = 3;
        };
        if ("fza_auxtank_230_1" in _mags && _waux230qty_1 > 0) then {
            _activetank = 0;
        };
        if ("fza_auxtank_230_2" in _mags && _waux230qty_2 > 0) then {
            _activetank = 1;
        };
        if ("fza_auxtank_230_3" in _mags && _waux230qty_3 > 0) then {
            _activetank = 2;
        };
        ///////////////WINGAUX//////////////////
        if ("fza_auxtank_230_1" in _mags && _waux230qty_1 > 0 && _activetank == 0) then {
            if (_fuelused > _waux230qty_1) then {
                _heli setfuel(fza_ah64_fuelsave + _waux230qty_1);
            } else {
                _heli setfuel 1;
            };
            _waux230qty_1 = _waux230qty_1 - _fuelused;
        };
        if ("fza_auxtank_230_2" in _mags && _waux230qty_2 > 0 && _activetank == 1) then {
            if (_fuelused > _waux230qty_2) then {
                _heli setfuel(fza_ah64_fuelsave + _waux230qty_2);
            } else {
                _heli setfuel 1;
            };
            _waux230qty_2 = _waux230qty_2 - _fuelused;
        };
        if ("fza_auxtank_230_3" in _mags && _waux230qty_3 > 0 && _activetank == 2) then {
            if (_fuelused > _waux230qty_3) then {
                _heli setfuel(fza_ah64_fuelsave + _waux230qty_3);
            } else {
                _heli setfuel 1;
            };
            _waux230qty_3 = _waux230qty_3 - _fuelused;
        };
        if ("fza_auxtank_230_4" in _mags && _waux230qty_4 > 0 && _activetank == 3) then {
            if (_fuelused > _waux230qty_4) then {
                _heli setfuel(fza_ah64_fuelsave + _waux230qty_4);
            } else {
                _heli setfuel 1;
            };
            _waux230qty_4 = _waux230qty_4 - _fuelused;
        };
        if (!("fza_auxtank_230_1" in _mags)) then {
            _waux230qty_1 = 0.62;
        };
        if (!("fza_auxtank_230_2" in _mags)) then {
            _waux230qty_2 = 0.62;
        };
        if (!("fza_auxtank_230_3" in _mags)) then {
            _waux230qty_3 = 0.62;
        };
        if (!("fza_auxtank_230_4" in _mags)) then {
            _waux230qty_4 = 0.62;
        };
        ///////////////IAFS///////////////
        if ("fza_iafs_100" in _mags && _iafs100qty > 0 && _activetank == 4) then {
            if (_fuelused > _iafs100qty) then {
                _heli setfuel(fza_ah64_fuelsave + _iafs100qty);
            } else {
                _heli setfuel 1;
            };
            _iafs100qty = _iafs100qty - _fuelused;
        };
        if ("fza_iafs_130" in _mags && _iafs130qty > 0 && _activetank == 5) then {
            if (_fuelused > _iafs130qty) then {
                _heli setfuel(fza_ah64_fuelsave + _iafs130qty);
            } else {
                _heli setfuel 1;
            };
            _iafs130qty = _iafs130qty - _fuelused;
        };
        if (!("fza_iafs_100" in _mags)) then {
            _iafs100qty = 0.27;
        };
        if (!("fza_iafs_130" in _mags)) then {
            _iafs130qty = 0.35;
        };
    };

    if ([_heli] call fza_fnc_engineAPUOn) then {
        fza_ah64_fuelsave = fza_ah64_fuelsave - 0.000002;
        _burnrate = 0.1875;
        if (_heli animationphase "plt_eng1_start" > 0) then {
            fza_ah64_fuelsave = fza_ah64_fuelsave - 0.000002;
            _burnrate = _burnrate + 0.1875;
        };
        if (_heli animationphase "plt_eng2_start" > 0) then {
            fza_ah64_fuelsave = fza_ah64_fuelsave - 0.000002;
            _burnrate = _burnrate + 0.1875;
        };
    };
    sleep 0.1;
};