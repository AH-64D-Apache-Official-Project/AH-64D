
//END EXPERIMENTAL - MONOCLE OVERLAY
class CfgInGameUI
{
	class Cursor{
		class Targeting
		{
			class MarkedTarget
			{
				scale=1;
				texture="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				color[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
				textureLockable="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				colorLockable[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
				textureFriendly="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				colorFriendly[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
				shadow=0;
			};
			class MarkedTargetNoLos: MarkedTarget
			{
				texture="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				color[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
				textureLockable="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				colorLockable[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
				textureFriendly="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				colorFriendly[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
			};
			class Seeker
			{
				texture="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				color[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
				scale=1;
				shadow=0;
			};
			class SeekerLocked: Seeker
			{
				texture="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				color[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
			};
			class ImpactPoint: Seeker
			{
				scale=0.5;
				texture="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				color[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
			};
			class ImpactPointNoLOS: ImpactPoint
			{
				texture="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				color[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
			};
			class HitPrediction: Seeker
			{
				scale=0.5;
				texture="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				color[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
			};
			class HitConfirm: Seeker
			{
				texture="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				color[]={0.70899999,0.972,0.384,1};
			};
			class KnownTarget: Seeker
			{
				texture="\A3\ui_f\data\igui\cfg\targeting\empty_ca.paa";
				color[]=
				{
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',0])",
					"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0])"
				};
			};
		};
	};
};
