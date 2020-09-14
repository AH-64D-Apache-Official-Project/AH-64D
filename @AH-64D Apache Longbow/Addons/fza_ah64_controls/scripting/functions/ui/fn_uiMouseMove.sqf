if (vehicle player iskindof "fza_ah64base" && fza_ah64_tiron) then {
    _mousex = _this select 1;
    _mousey = _this select 2;

    _mousex = _mousex * 0.05;
    _mousey = _mousey * 0.05;

    fza_ah64_mousehorpos = fza_ah64_mousehorpos + _mousex;
    fza_ah64_mousevertpos = fza_ah64_mousevertpos + _mousey;
    if (fza_ah64_mousehorpos > (safezoneXabs + safezonew)) then {
        fza_ah64_mousehorpos = safezoneXabs + safezonew;
    };
    if (fza_ah64_mousehorpos < safezoneXabs) then {
        fza_ah64_mousehorpos = safezoneXabs;
    };
    if (fza_ah64_mousevertpos > (safezoneY + safezoneH)) then {
        fza_ah64_mousevertpos = safezoneY + safezoneH;
    };
    if (fza_ah64_mousevertpos < safezoneY) then {
        fza_ah64_mousevertpos = safezoneY;
    };
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601) ctrlSetPosition[fza_ah64_mousehorpos - 0.005, fza_ah64_mousevertpos - 0.009];
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 602) ctrlSetPosition[fza_ah64_mousehorpos - 0.25, fza_ah64_mousevertpos + 0.02];
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601) ctrlCommit 0.01;
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 602) ctrlCommit 0.01;
};