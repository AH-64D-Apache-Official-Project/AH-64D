// Texture files the MPD display loads with itself (RscFzaAH64MPD)
params ["_color"];

switch (true) do {
    case (_color isEqualTo [0, 1, 0, 1]): {"\fza_ah64_mpd\tex\canvas\line_green_ca.paa"};
    case (_color isEqualTo [1, 1, 1, 1]): {"\fza_ah64_mpd\tex\canvas\line_white_ca.paa"};
    case (_color isEqualTo [1, 1, 0, 1]): {"\fza_ah64_mpd\tex\canvas\line_yellow_ca.paa"};
    case (_color isEqualTo [0.6, 0.6, 0.6, 1]): {"\fza_ah64_mpd\tex\canvas\line_dim_ca.paa"};
    // The areas' red as well (fza_mpd_fnc_tsdZoneItems): a procedural texture fails to load in the ui() display
    case (_color isEqualTo [1, 0, 0, 1] || {_color isEqualTo [1, 0, 0.2, 1]}): {"\fza_ah64_mpd\tex\canvas\line_red_ca.paa"};
    case (_color isEqualTo [0.4, 0.6, 1, 1]): {"\fza_ah64_mpd\tex\canvas\line_blue_ca.paa"};
    default {format (["#(rgb,8,8,3)color(%1,%2,%3,%4)"] + _color)};
}
