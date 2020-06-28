#include "\fza_ah64_controls\headers\selections.h"
_heli = _this select 0;

if (fza_ah64_pr_mpd == "tsd") exitwith {
    fza_ah64_pr_mpd = "fcr";
};
if (fza_ah64_pr_mpd == "fcr") exitwith {
    fza_ah64_pr_mpd = "wca";
};
if (fza_ah64_pr_mpd == "wca") exitwith {
    fza_ah64_pr_mpd = "ase";
};
if (fza_ah64_pr_mpd == "ase") exitwith {
    fza_ah64_pr_mpd = "eng";
};
if (fza_ah64_pr_mpd == "eng") exitwith {
    fza_ah64_pr_mpd = "tsd";
};
if (fza_ah64_pr_mpd == "fail" && !("fza_ah64_rdp_fail" in (_heli magazinesturret[-1])) && !("fza_ah64_ldp_fail" in (_heli magazinesturret[-1]))) exitwith {
    fza_ah64_pr_mpd = "eng";
};
if (fza_ah64_pr_mpd == "fail" && !("fza_ah64_ldp_fail" in (_heli magazinesturret[-1]))) exitwith {
    fza_ah64_pr_mpd = "eng";
    fza_ah64_pl_mpd = "fail";
    _heli setobjecttexture [SEL_PL_MPD_BACK, ""];
};