params ["_heli", "_mpdIndex", "_control"];

 systemChat str _this;
switch(_control) do {
	case "b1": {
		[_heli, _mpdIndex, "wca"] call fza_mpd_fnc_setCurrentPage;
	};
	case "b2": {
		[_heli, _mpdIndex, "eng"] call fza_mpd_fnc_setCurrentPage;
	};
	case "b3": {
		[_heli, _mpdIndex, "flt"] call fza_mpd_fnc_setCurrentPage;
	};
	case "b4": {
		[_heli, _mpdIndex, "fuel"] call fza_mpd_fnc_setCurrentPage;
	};
	case "l5": {
		[_heli, _mpdIndex, "wpn"] call fza_mpd_fnc_setCurrentPage;
	};

};