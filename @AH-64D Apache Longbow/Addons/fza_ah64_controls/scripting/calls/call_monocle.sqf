/*
if(!(isNil "fza_ah64_notargeting")) exitwith {};
_heli = _this select 0;

if (_heli isKindOf "fza_ah64base" && cameraView == "INTERNAL") then
{
  3 cutrsc ["fza_ah64_click_monocle", "PLAIN",0.01,false];
  ((uiNameSpace getVariable "fza_ah64_click_monocle")displayCtrl 501) ctrlSetText "\fza_ah64_US\tex\HDU\monocle_solid.paa";
};

if (_heli isKindOf "fza_ah64base" && (cameraView == "EXTERNAL" || cameraView == "GUNNER")) then
{
  3 cuttext ["", "PLAIN"];
  ((uiNameSpace getVariable "fza_ah64_click_monocle")displayCtrl 501) ctrlSetText "";
};

if (_heli isKindOf "fza_ah64base" && fza_ah64_monocleinbox == 1) then {
  3 cuttext ["", "PLAIN",0.1];
  ((uiNameSpace getVariable "fza_ah64_click_monocle")displayCtrl 501) ctrlSetText "";
};
*/
/*
//DISABLE/ENABLE MONOCLE (1ST/3RD PERSON)
if (cameraView == "EXTERNAL" || cameraView == "GUNNER") then
{
3 cutrsc ["", "PLAIN",0.01];
((uiNameSpace getVariable "fza_ah64_click_monocle")displayCtrl 501) ctrlSetText "";
} else {
if (cameraView == "INTERNAL") then
{
3 cutrsc ["fza_ah64_click_monocle", "PLAIN",0.1];
((uiNameSpace getVariable "fza_ah64_click_monocle")displayCtrl 501) ctrlSetText "\fza_ah64_US\tex\HDU\monocle_solid.paa";
}
};
//END DISABLE/ENABLE MOUSE CURSOR (1ST/3RD PERSON)
*/