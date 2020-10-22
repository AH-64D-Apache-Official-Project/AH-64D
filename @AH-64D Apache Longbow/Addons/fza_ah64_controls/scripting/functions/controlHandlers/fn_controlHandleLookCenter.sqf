/* ----------------------------------------------------------------------------
Function: fza_fnc_controlHandleLookCenter

Description:
    Handler for the look center (Num 5) key.

    Centres the click helper back to the middle of the screen

Parameters:
    None

Returns:
	Nothing

Examples:
	--- Code
    call fza_fnc_controlHandleLookCenter
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
fza_ah64_mousehorpos = 0.5;
fza_ah64_mousevertpos = 0.5;
((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601) ctrlSetPosition[fza_ah64_mousehorpos - 0.005, fza_ah64_mousevertpos - 0.009];
((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 602) ctrlSetPosition[fza_ah64_mousehorpos - 0.25, fza_ah64_mousevertpos + 0.02];
((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601) ctrlCommit 0.01;
((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 602) ctrlCommit 0.01;