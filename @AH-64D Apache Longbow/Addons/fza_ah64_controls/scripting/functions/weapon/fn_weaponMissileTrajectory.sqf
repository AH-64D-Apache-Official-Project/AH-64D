params ["_heli"];

_hfcurtraj = "";
_curwpn = weaponState [_heli, [0]];
if (_curwpn # 0 iskindof ["fza_hellfire", configFile / "CfgWeapons"]) then {
	switch (_curwpn # 2) do {
		case "Cruise": {
			_hfcurtraj = "\fza_ah64_us\tex\icons\hi.paa";
		};
		case "TopDown": {
			_hfcurtraj = "\fza_ah64_us\tex\icons\lo.paa"
		};
		case "LoalDistance" : {
			_hfcurtraj = "\fza_ah64_us\tex\icons\dir.paa";
		};
		default {
			_hfcurtraj = "";
		};
	};
};
_hfcurtraj;