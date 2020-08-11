#include "\fza_ah64_controls\headers\selections.h"
if (!(isNil "fza_ah64_notsdfcr")) exitwith {};
_heli = _this select 0;
if (isNil "fza_ah64_tsdtargets") then {
    fza_ah64_tsdtargets = [];
};
_adaunit = false;
_targzpos = 0;
_targindi = 0;
_targnum = 265;
_objnum = 0;
_targnumcpg = 1076;
_tsdrformat1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_tsdrformat2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_tgtrformat1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_tgtrformat2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_tgtrformat3 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_targdir1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_targdir2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_targdir3 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_pfzsel = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_tfilter = "\fza_ah64_us\tex\mpd\all.paa";
_helidir = (direction _heli);
_tgtr = 0;
_windspd = 0;
_navstring = "\fza_ah64_US\tex\ICONS\ah64_wp_ina_00.paa";
if (isNil "fza_ah64_shotat_list") then {
    fza_ah64_shotat_list = [];
};
_targxpos = 0;
_targypos = 0;
_helixpos = 0;
_heliypos = 0;
if (isNil "fza_ah64_mapsizearea") then {
    fza_ah64_mapsizearea = 5120;
};
if (isNil "fza_ah64_maplist") then {
    fza_ah64_maplist = ["\fza_ah64_US\tex\mpd\notfound_2.paa"];
};
if (isNil "fza_ah64_currentmap") then {
    fza_ah64_currentmap = "\fza_ah64_US\tex\mpd\notfound_2.paa";
};

while {
    (time > -1)
}
do {
    waituntil {
        (vehicle player) iskindof "fza_ah64base"
    };
    _heli = vehicle player;
    _prevcache = fza_ah64_pfzcache;
    waitUntil {
        ((driver(vehicle player) == player || gunner(vehicle player) == player))
    };

    fza_ah64_dispfcrlist = fza_ah64_fcrlist;

    {
        //TODO: Move target sorting elsewhere
        _i = _x;
        fza_ah64_dispfcrlist = fza_ah64_dispfcrlist - [_i];

        if (fza_ah64_tsdsort < 4) then {

            {
                if (_i iskindof _x) then {
                    fza_ah64_dispfcrlist = fza_ah64_dispfcrlist + [_i];
                };
            }
            foreach fza_ah64_tsdsortarray;

        } else {

            if (_i in fza_ah64_tsdsortarray) then {
                fza_ah64_dispfcrlist = fza_ah64_dispfcrlist + [_i];
            };
        };

        _thetafcr = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _i select 0), (getposatl _i select 1)] call fza_ah64_reldir;

        if (fza_ah64_agmode == 1) then {
            if ((getpos _i select 2 < 10) || ((_heli distance2D _i) > 8000) || !(alive _i)) then {
                fza_ah64_dispfcrlist = fza_ah64_dispfcrlist - [_i];
            };
        };

        if (fza_ah64_agmode == 0) then {
            if ((getpos _i select 2 > 10) || ((_heli distance2D _i) > 8000) || (_thetafcr > 70 && _thetafcr < 290) || !(alive _i)) then {
                fza_ah64_dispfcrlist = fza_ah64_dispfcrlist - [_i];
            };
        };

    }
    foreach fza_ah64_dispfcrlist;

    sleep 0.03;
    if ((fza_ah64_pfzcache select 3) != (_prevcache select 3)) then {
        if ((fza_ah64_pfzcache select 1) == (name player) || (fza_ah64_pfzcache select 1) == "all") then {
            _heli vehiclechat "New cache data detected."
        };
    };
};