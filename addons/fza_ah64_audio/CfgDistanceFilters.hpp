class CfgDistanceFilters
{
	class fza_Close_Engine_Filter
	{
		type="lowpassfilter";
		mincutofffrequency=1500;
		qfactor=1.0;
		innerrange=100;
		range=1200;
		powerfactor=10;
	};
	class fza_Distant_Engine_Filter: fza_Close_Engine_Filter
	{
		mincutofffrequency=200;
		innerrange=800;
		range=3000;
		powerfactor=18;
	};
};
