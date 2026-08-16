// ============================================================================
// Control Input Visualiser – RSC Titles definition
// IDD 5100, IDCs 5100-5160
// Positions are set to 0,0,0,0 on load; fn_ctrlVisUpdate repositions each frame.
// ============================================================================

class RscText;
class RscFrame;

class RscTitles
{
    class fza_ah64_ctrlvis
    {
    idd          = 5100;
    movingEnable = 1;       // Non-blocking: player retains game/vehicle inputs while display is open
    sizeEnable   = 1;       // Resizable in the Arma layout editor
    duration     = 99999;
    fadein       = 0;
    fadeout      = 0;
    name         = "fza_ah64_ctrlvis";
    onLoad       = "uiNameSpace setVariable ['fza_ah64_ctrlvis', _this select 0];";

    class controls
    {
        // ── Background ──────────────────────────────────────────────────────
        class FZA_CtrlVis_BG : RscText
        {
            idc = 5101;
            colorBackground[] = {0.0, 0.0, 0.0, 0.75};
            colorText[]       = {0, 0, 0, 0};
            text = "";
            // Position is read from profileNamespace so the Arma layout editor
            // (CfgUIGrids) can save/restore it.  Keys: IGUI_grid_fza_ctrlvis_X/Y/W/H
            x = "(profileNamespace getVariable ['IGUI_grid_fza_ctrlvis_X', safeZoneX + safeZoneW * 0.780])";
            y = "(profileNamespace getVariable ['IGUI_grid_fza_ctrlvis_Y', safeZoneY + safeZoneH * 0.500])";
            w = "(profileNamespace getVariable ['IGUI_grid_fza_ctrlvis_W', safeZoneH * 0.160])";
            h = "(profileNamespace getVariable ['IGUI_grid_fza_ctrlvis_H', safeZoneH * 0.240])";
        };

        // ── Drag / title bar ────────────────────────────────────────────────
        class FZA_CtrlVis_DragBar : RscText
        {
            idc  = 5102;
            colorBackground[] = {0.05, 0.20, 0.05, 0.90};
            colorText[]       = {0.70, 1.00, 0.70, 1.00};
            text    = "Control Inputs";
            font    = "PuristaMedium";
            sizeEx  = 0.012;
            style   = 2;    // center
            x = 0; y = 0; w = 0.001; h = 0.001;
            // Mouse events wired in fn_ctrlVisInit
        };

        // ── Mode labels ─────────────────────────────────────────────────────
        class FZA_CtrlVis_ModeALT : RscText
        {
            idc = 5110;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {0.6, 0.6, 0.6, 0.8};
            text   = "ALT";
            font   = "PuristaMedium";
            sizeEx = 0.012;
            style  = 2;
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        class FZA_CtrlVis_ModeATTPOS : RscText
        {
            idc = 5111;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {0.6, 0.6, 0.6, 0.8};
            text   = "ATT-POS";
            font   = "PuristaMedium";
            sizeEx = 0.012;
            style  = 2;
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        class FZA_CtrlVis_ModeVEL : RscText
        {
            idc = 5112;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {0.6, 0.6, 0.6, 0.8};
            text   = "VEL";
            font   = "PuristaMedium";
            sizeEx = 0.012;
            style  = 2;
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        class FZA_CtrlVis_ModeATT : RscText
        {
            idc = 5113;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {0.6, 0.6, 0.6, 0.8};
            text   = "ATT";
            font   = "PuristaMedium";
            sizeEx = 0.012;
            style  = 2;
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // ── Collective bar ───────────────────────────────────────────────────
        class FZA_CtrlVis_CollFrame : RscFrame
        {
            idc = 5120;
            colorFrame[] = {0.45, 0.45, 0.45, 0.80};
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // Collective scale labels (0 / 50 / 100)
        class FZA_CtrlVis_CollLabel : RscText
        {
            idc = 5123;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {0.55, 0.55, 0.55, 0.7};
            text   = "C";
            font   = "PuristaMedium";
            sizeEx = 0.009;
            style  = 2;
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // Actual collective line (green)
        class FZA_CtrlVis_CollAct : RscText
        {
            idc = 5121;
            colorBackground[] = {0.20, 1.00, 0.20, 0.90};
            colorText[]       = {0, 0, 0, 0};
            text   = "";
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // Alt-hold collective indicator (red, only when alt hold active)
        class FZA_CtrlVis_CollSAS : RscText
        {
            idc = 5122;
            colorBackground[] = {1.00, 0.25, 0.25, 0.85};
            colorText[]       = {0, 0, 0, 0};
            text   = "";
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // ── Cyclic display frame ─────────────────────────────────────────────
        class FZA_CtrlVis_CycFrame : RscFrame
        {
            idc = 5130;
            colorFrame[] = {0.45, 0.45, 0.45, 0.80};
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // Crosshair horizontal line
        class FZA_CtrlVis_CrossH : RscText
        {
            idc = 5131;
            colorBackground[] = {0.35, 0.35, 0.35, 0.55};
            colorText[]       = {0, 0, 0, 0};
            text = "";
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // Crosshair vertical line
        class FZA_CtrlVis_CrossV : RscText
        {
            idc = 5132;
            colorBackground[] = {0.35, 0.35, 0.35, 0.55};
            colorText[]       = {0, 0, 0, 0};
            text = "";
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // SAS + ATT hold – H bar of cross (bottom layer)
        class FZA_CtrlVis_CycSAS : RscText
        {
            idc = 5133;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {0, 0, 0, 0};
            text = "";
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // SAS + ATT hold – V bar of cross (bottom layer, paired with 5133)
        class FZA_CtrlVis_CycSAS_V : RscText
        {
            idc = 5136;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {0, 0, 0, 0};
            text = "";
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // Force trim reference – outer dot for ring (middle layer)
        // FT ring – transparent center baked into PAA; ring thickness matches Actual when rendered at half size
        class FZA_CtrlVis_CycFT : RscText
        {
            idc   = 5134;
            type  = 0;
            style = 48;   // ST_PICTURE
            text  = "\fza_ah64_controls\data\ui\ring_ft_ca.paa";
            colorText[]       = {1, 1, 1, 1};
            colorBackground[] = {0, 0, 0, 0};
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // Actual ring – transparent center baked into PAA
        class FZA_CtrlVis_CycAct : RscText
        {
            idc   = 5135;
            type  = 0;
            style = 48;   // ST_PICTURE
            text  = "\fza_ah64_controls\data\ui\ring_act_ca.paa";
            colorText[]       = {1, 1, 1, 1};
            colorBackground[] = {0, 0, 0, 0};
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // ── Yaw / heading bar ────────────────────────────────────────────────
        class FZA_CtrlVis_YawFrame : RscFrame
        {
            idc = 5140;
            colorFrame[] = {0.45, 0.45, 0.45, 0.80};
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // Yaw centre tick (thin vertical bar)
        class FZA_CtrlVis_YawCtr : RscText
        {
            idc = 5144;
            colorBackground[] = {0.35, 0.35, 0.35, 0.55};
            colorText[]       = {0, 0, 0, 0};
            text = "";
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // FT pedal indicator (orange)
        class FZA_CtrlVis_YawFT : RscText
        {
            idc = 5141;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {1.00, 0.60, 0.10, 1.00};
            text   = "|";
            font   = "EtelkaMonospaceProBold";
            sizeEx = 0.020;
            style  = 2;
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // Actual pedal position (green)
        class FZA_CtrlVis_YawAct : RscText
        {
            idc = 5142;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {0.20, 1.00, 0.20, 1.00};
            text   = "|";
            font   = "EtelkaMonospaceProBold";
            sizeEx = 0.020;
            style  = 2;
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // SAS yaw indicator (red)
        class FZA_CtrlVis_YawSAS : RscText
        {
            idc = 5143;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {1.00, 0.20, 0.20, 1.00};
            text   = "|";
            font   = "EtelkaMonospaceProBold";
            sizeEx = 0.016;
            style  = 2;
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

        // HDG label
        class FZA_CtrlVis_HDGLabel : RscText
        {
            idc = 5145;
            colorBackground[] = {0, 0, 0, 0};
            colorText[]       = {0.70, 0.70, 0.70, 0.85};
            text   = "HDG";
            font   = "PuristaMedium";
            sizeEx = 0.009;
            style  = 2;
            x = 0; y = 0; w = 0.001; h = 0.001;
        };

    }; // class controls
    }; // class fza_ah64_ctrlvis
}; // class RscTitles

// Register with the Arma layout editor (Options → Video → Edit Layout).
// CfgUIGrids is the correct API; the editor saves/restores IGUI_grid_fza_ctrlvis_X/Y/W/H
// in profileNamespace.  The BG control x/y/w/h read those keys above.
class CfgUIGrids
{
    class IGUI
    {
        class Presets
        {
            class Arma3
            {
                class Variables
                {
                    // Default position (used when player has not yet moved the widget)
                    grid_fza_ctrlvis[] = {
                        {
                            "safeZoneX + safeZoneW * 0.780",
                            "safeZoneY + safeZoneH * 0.500",
                            "safeZoneH * 0.160",
                            "safeZoneH * 0.240"
                        },
                        "safeZoneH * 0.005",
                        "safeZoneH * 0.005"
                    };
                };
            };
        };

        class Variables
        {
            class grid_fza_ctrlvis
            {
                displayName     = "FZA AH-64D: Control Input Visualiser";
                description     = "HeliSim control input and SAS visualiser overlay";
                // preview is the image the layout editor renders as the draggable element.
                // Without this the widget is invisible on the canvas and cannot be interacted with.
                preview         = "\fza_ah64_controls\data\ui\IGUI_ctrlvis_preview.paa";
                saveToProfile[] = {0, 1, 2, 3};
                canResize       = 1;
            };
        };
    };
};
