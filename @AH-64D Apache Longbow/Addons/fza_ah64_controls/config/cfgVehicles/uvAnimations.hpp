class UVAnimations
{
    class plt_mmap_01_tnsx
    {
        type			= translation;
        source			= plt_mmap_tx;
        section			= plt_pr_mpd_back;
        minValue		= -1;
        maxValue		= 2;
        offset0[]		= {-1,0};
        offset1[]		= {2,0};
    };
    class plt_mmap_02_tnsy
    {
        type			= translation;
        source			= plt_mmap_ty;
        section			= plt_pr_mpd_back;
        minValue		= -1;
        maxValue		= 2;
        offset0[]		= {0,-1};
        offset1[]		= {0,2};
    };
    class plt_mmap_03_rot
    {
        type			= rotate;
        source			= plt_mmap_r;
        section			= plt_pr_mpd_back;
        minValue		= 0;
        maxValue		= 360;
        center[]		= { 0.5, 0.75 };
        angle0			= 0;
        angle1			= rad 360;
    };
    class plt_mmap_04_scale
    {
        type = scale;
        source = plt_mmap_sc;
        section	= plt_pr_mpd_back;
        minValue = 0.01;
        maxValue = 100;
        center[] = { 0.50, 0.75 };
        scale0[] = {0.01,0.01};
        scale1[] = {100,100};
    };
    class cpg_mmap_01_tnsx : plt_mmap_01_tnsx
    {
        section	= cpg_pr_mpd_back;
        source = cpg_mmap_tx;
    };
    class cpg_mmap_02_tnsy : plt_mmap_02_tnsy
    {
        section	= cpg_pr_mpd_back;
        source = cpg_mmap_ty;
    };
    class cpg_mmap_03_rot : plt_mmap_03_rot
    {
        section	= cpg_pr_mpd_back;
        source = cpg_mmap_r;
    };
    class cpg_mmap_04_scale : plt_mmap_04_scale
    {
        section	= cpg_pr_mpd_back;
        source = cpg_mmap_sc;
    };
};