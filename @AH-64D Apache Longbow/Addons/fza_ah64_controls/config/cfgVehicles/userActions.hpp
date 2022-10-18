class UserActions
{
    class lookcenter
    {
        displayName="";
        useAction=false;
        showSwitchAction=false;
        position="pilot_action";
        onlyForPlayer=1;
        radius=8;
        showWindow=0;
        priority=0;
        condition="(player == driver this || player == gunner this) && alive this && !(this iskindof ""fza_ah64a_l"")";
        shortcut="LookCenter";
        statement="fza_ah64_mousehorpos = 0.5; fza_ah64_mousevertpos = 0.5; ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 601) ctrlSetPosition[fza_ah64_mousehorpos - 0.005, fza_ah64_mousevertpos - 0.009]; ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 602) ctrlSetPosition[fza_ah64_mousehorpos - 0.25, fza_ah64_mousevertpos + 0.02]; ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 601) ctrlCommit 0.01; ((uiNameSpace getVariable 'fza_ah64_click_helper') displayCtrl 602) ctrlCommit 0.01;";
    };
    class sensorselect
    {
        displayName="";
        useAction=false;
        showSwitchAction=false;
        position="pilot_action";
        onlyForPlayer=1;
        radius=8;
        showWindow=0;
        priority=0;
        //condition="(player == driver this || player == gunner this) && alive this && !(this iskindof ""fza_ah64a_l"" || this iskindof ""fza_ah64a_e"")";
        condition="(player == driver this || player == gunner this) && alive this && !(this iskindof ""fza_ah64a_l"")";
        shortcut="OpticsMode";
        statement="[this] call fza_fnc_weaponguncontrol;";
    };
    class tiron
    {
        displayName="Toggle Head Tracking On";
        useAction=false;
        showSwitchAction=false;
        position="pilot_action";
        onlyForPlayer=1;
        radius=8;
        showWindow=0;
        priority=9;
        condition="!fza_ah64_tiron && (player == driver this || player == gunner this)";
        statement="fza_ah64_tiron = !fza_ah64_tiron";
    };
    class tiroff
    {
        displayName="Toggle Head Tracking Off";
        useAction=false;
        showSwitchAction=false;
        position="pilot_action";
        onlyForPlayer=1;
        radius=8;
        showWindow=0;
        priority=9;
        condition="fza_ah64_tiron && (player == driver this || player == gunner this)";
        statement="fza_ah64_tiron = !fza_ah64_tiron";
    };
};