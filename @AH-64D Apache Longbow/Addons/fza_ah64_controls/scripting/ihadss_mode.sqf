if (fza_ah64_hmdfsmode == "trans") exitwith {
    fza_ah64_hmdfsmode = "cruise";
};
if (fza_ah64_hmdfsmode == "cruise") exitwith {
    fza_ah64_hmdfsmode = "hover";
};
if (fza_ah64_hmdfsmode == "hover") exitwith {
    fza_ah64_hmdfsmode = "bobup";
};
if (fza_ah64_hmdfsmode == "bobup") exitwith {
    fza_ah64_hmdfsmode = "trans";
};