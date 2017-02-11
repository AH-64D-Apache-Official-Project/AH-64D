_heli = _this select 0;

if (fza_ah64_pl_mpd == "fuel") exitwith {fza_ah64_pl_mpd = "wpn";};
if (fza_ah64_pl_mpd == "wpn") exitwith {fza_ah64_pl_mpd = "wca";};
if (fza_ah64_pl_mpd == "wca") exitwith {fza_ah64_pl_mpd = "flt";};
if (fza_ah64_pl_mpd == "flt") exitwith {fza_ah64_pl_mpd = "fuel";};
if (fza_ah64_pl_mpd == "fail" && !("fza_ah64_ldp_fail" in (_heli magazinesturret [-1])) && !("fza_ah64_rdp_fail" in (_heli magazinesturret [-1]))) exitwith {fza_ah64_pl_mpd = "fuel";};
if (fza_ah64_pl_mpd == "fail" && !("fza_ah64_rdp_fail" in (_heli magazinesturret [-1]))) exitwith {fza_ah64_pl_mpd = "fuel"; fza_ah64_pr_mpd = "fail"; _heli setobjecttexture [303,""];};