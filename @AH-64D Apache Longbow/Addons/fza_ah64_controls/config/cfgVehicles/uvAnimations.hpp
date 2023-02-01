class UVAnimations
{
    class plt_lmpd_uiscale {
        type = scale;
        source = plt_uiscale;
        section = plt_pl_mpd_back;
        minValue = 0.1;
        maxValue = 10;
        center[] = {0.5, 0.5};
        scale0[] = {1*1.030, 0.1*1.025};
        scale1[] = {1*1.030, 10 *1.025};
    };
    class plt_rmpd_uiscale : plt_lmpd_uiscale {
        section = plt_pr_mpd_back;
    };
    class cpg_lmpd_uiscale : plt_lmpd_uiscale {
        source = cpg_uiscale;
        section = cpg_cl_mpd_back;
    };
    class cpg_rmpd_uiscale : cpg_lmpd_uiscale {
        section = cpg_cr_mpd_back;
    };
};