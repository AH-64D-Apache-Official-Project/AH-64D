params ["_heli"];

_hfcurtraj = "";
_curwpn = weaponState [_heli, [0]];
if (_curwpn # 0 iskindof ["fza_hellfire", configFile / "CfgWeapons"]) then {
	switch (_curwpn # 2) do {
		case "Cruise": {
			_hfcurtraj = "hi";
		};
		case "TopDown": {
			_hfcurtraj = "lo";
		};
		case "LoalDistance" : {
			_hfcurtraj = "dir";
		};
		default {
			_hfcurtraj = "";
		};
	};
};
_hfcurtraj;