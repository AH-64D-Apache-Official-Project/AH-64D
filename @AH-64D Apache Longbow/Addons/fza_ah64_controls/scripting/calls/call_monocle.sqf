if (vehicle player isKindOf "fza_ah64base" && cameraView == "INTERNAL") then
{
  3 cutrsc ["fza_ah64_click_monocle", "PLAIN",0.01,false];
  ((uiNameSpace getVariable "fza_ah64_click_monocle")displayCtrl 501) ctrlSetText "\fza_ah64_US\tex\HDU\monocle_solid.paa";
};

if (vehicle player isKindOf "fza_ah64base" && (cameraView == "EXTERNAL" || cameraView == "GUNNER")) then
{
  3 cuttext ["", "PLAIN"];
  ((uiNameSpace getVariable "fza_ah64_click_monocle")displayCtrl 501) ctrlSetText "";
};

if (vehicle player isKindOf "fza_ah64base" && fza_ah64_monocleinbox == 1) then {
  3 cuttext ["", "PLAIN",0.1];
  ((uiNameSpace getVariable "fza_ah64_click_monocle")displayCtrl 501) ctrlSetText "";
};