class CodeRange {
    class Lines {
        type=line;
        width=3;
        points[] = {
            MPD_POINTS_BOX_PAD(Null,(0.5-11*MPD_TEXT_WIDTH),0.27,22*MPD_TEXT_WIDTH,2*MPD_TEXT_HEIGHT-0.02,0.01)
        };
    };

    MPD_TEXT_R(CodeRange_Header,0.5-11*MPD_TEXT_WIDTH,0.26+0*MPD_TEXT_HEIGHT,MPD_TEXT_STATIC("CODE RANGES  STATUS"))
    MPD_TEXT_R(CodeRange_Header_Line,0.497-11*MPD_TEXT_WIDTH,0.26+0*MPD_TEXT_HEIGHT,MPD_TEXT_STATIC("____ ______  ______"))
    MPD_TEXT_R(CodeRange_Header_Line2,0.503-11*MPD_TEXT_WIDTH,0.26+0*MPD_TEXT_HEIGHT,MPD_TEXT_STATIC("____ ______  ______"))
    MPD_TEXT_R(CodeRange_1 ,0.5-11*MPD_TEXT_WIDTH,0.26+1*MPD_TEXT_HEIGHT ,MPD_TEXT_STATIC("1111 - 1788"))
};