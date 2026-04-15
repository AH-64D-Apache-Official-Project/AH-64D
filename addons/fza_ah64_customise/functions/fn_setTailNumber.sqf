params ["_heli", "_tailNumber"];

private _validChars = createHashmapFromArray [
    ["0", "\fza_ah64_customise\data\texture\0_ca.paa"],
    ["1", "\fza_ah64_customise\data\texture\1_ca.paa"],
    ["2", "\fza_ah64_customise\data\texture\2_ca.paa"],
    ["3", "\fza_ah64_customise\data\texture\3_ca.paa"],
    ["4", "\fza_ah64_customise\data\texture\4_ca.paa"],
    ["5", "\fza_ah64_customise\data\texture\5_ca.paa"],
    ["6", "\fza_ah64_customise\data\texture\6_ca.paa"],
    ["7", "\fza_ah64_customise\data\texture\7_ca.paa"],
    ["8", "\fza_ah64_customise\data\texture\8_ca.paa"],
    ["9", "\fza_ah64_customise\data\texture\9_ca.paa"]
];

private _char01 = _tailNumber select [0, 1];
private _char02 = _tailNumber select [1, 1];
private _char03 = _tailNumber select [2, 1];
private _char04 = _tailNumber select [3, 1];
private _char05 = _tailNumber select [4, 1];

_heli setObjectTextureGlobal ["tailDigit_01", _validChars getOrDefault [_char01, ""]];
_heli setObjectTextureGlobal ["tailDigit_02", _validChars getOrDefault [_char02, ""]];
_heli setObjectTextureGlobal ["tailDigit_03", _validChars getOrDefault [_char03, ""]];
_heli setObjectTextureGlobal ["tailDigit_04", _validChars getOrDefault [_char04, ""]];
_heli setObjectTextureGlobal ["tailDigit_05", _validChars getOrDefault [_char05, ""]];
