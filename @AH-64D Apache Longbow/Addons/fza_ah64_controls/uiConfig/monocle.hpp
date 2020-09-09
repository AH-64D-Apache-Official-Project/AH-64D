
//END EXPERIMENTAL - MONOCLE OVERLAY
class CfgInGameUI
{
	class Cursor{
		class Targeting
		{
			class MarkedTarget
            {
                scale=1;
                texture="\A3\ui_f\data\igui\cfg\targeting\MarkedTarget_ca.paa";
                color[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
                textureLockable="\A3\ui_f\data\igui\cfg\targeting\MarkedTargetLockable_ca.paa";
                colorLockable[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
                textureFriendly="\A3\ui_f\data\igui\cfg\targeting\MarkedTargetFriendly_ca.paa";
                colorFriendly[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
                shadow=0;
            };
            class MarkedTargetNoLos: MarkedTarget
            {
                texture="\A3\ui_f\data\igui\cfg\targeting\MarkedTargetNoLOS_ca.paa";
                color[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
					"(0.60000002 * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
                textureLockable="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
                colorLockable[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
                textureFriendly="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
                colorFriendly[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
            };

			class Seeker
            {
                texture="\A3\ui_f\data\igui\cfg\targeting\seeker_ca.paa";
                color[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
                scale=1;
                shadow=0;
            };
            class SeekerLocked: Seeker
            {
                texture="\A3\ui_f\data\igui\cfg\targeting\SeekerLocked_ca.paa";
                color[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
            };
			class ImpactPoint: Seeker
            {
                scale=0.5;
                texture="\A3\ui_f\data\igui\cfg\targeting\ImpactPoint_ca.paa";
                color[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
            };
			class ImpactPointNoLOS: ImpactPoint
            {
                texture="\A3\ui_f\data\igui\cfg\targeting\ImpactPointNoLOS_ca.paa";
                color[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
            };
			class HitPrediction: Seeker
            {
                scale=0.5;
                texture="\A3\ui_f\data\igui\cfg\targeting\HitPrediction_ca.paa";
                color[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
            };
			class HitConfirm: Seeker
            {
                texture="\A3\ui_f\data\igui\cfg\targeting\HitConfirm_ca.paa";
                color[]={0.70899999,0.972,0.384,1};
            };
			class KnownTarget: Seeker
            {
                texture="\A3\ui_f\data\igui\cfg\targeting\KnownTarget_ca.paa";
                color[]=
                {
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
                    "(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
                    "((profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8]) * (profilenamespace getvariable ['fza_ah64_enableTargeting', 1]))"
                };
            };
		};
	};
};