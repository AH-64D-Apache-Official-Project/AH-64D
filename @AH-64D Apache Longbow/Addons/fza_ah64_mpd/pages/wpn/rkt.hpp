class VABs_Mode_Rkt {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN), 2));
    #define WPN_RKT_INVENTORY(className, invIndex, posY, nameSource, qtySource) \
    class className {\
        MPD_TEXT_R(Name, MPD_POS_BUTTON_L_X, posY - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_USER(nameSource)) \
        MPD_TEXT_R(Qty, MPD_POS_BUTTON_L_X, posY + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_USER(qtySource)) \
        class Box {\
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_RKT_SELECTED_INV), invIndex));\
            class Line { \
                type = line;\
                width = 3;\
                points[] = {\
                    {{MPD_POS_BUTTON_L_X - 0.01, posY - 0.5 * MPD_TEXT_HEIGHT}, 1},\
                    {{MPD_POS_BUTTON_L_X + 0.01 + 3 * MPD_TEXT_WIDTH, posY - 0.5 * MPD_TEXT_HEIGHT}, 1},\
                    {{MPD_POS_BUTTON_L_X + 0.01 + 3 * MPD_TEXT_WIDTH, posY + 1.5 * MPD_TEXT_HEIGHT}, 1},\
                    {{MPD_POS_BUTTON_L_X - 0.01, posY + 1.5 * MPD_TEXT_HEIGHT}, 1},\
                    {{MPD_POS_BUTTON_L_X - 0.01, posY - 0.5 * MPD_TEXT_HEIGHT}, 1}\
                };\
            }; \
        };\
    };
    
    WPN_RKT_INVENTORY(Inv1, 0, MPD_POS_BUTTON_LR_1_Y, MFD_TEXT_IND_WPN_RKT_INV_1_NAME, MFD_TEXT_IND_WPN_RKT_INV_1_QTY)
    WPN_RKT_INVENTORY(Inv2, 1, MPD_POS_BUTTON_LR_2_Y, MFD_TEXT_IND_WPN_RKT_INV_2_NAME, MFD_TEXT_IND_WPN_RKT_INV_2_QTY)
    WPN_RKT_INVENTORY(Inv3, 2, MPD_POS_BUTTON_LR_3_Y, MFD_TEXT_IND_WPN_RKT_INV_3_NAME, MFD_TEXT_IND_WPN_RKT_INV_3_QTY)
    WPN_RKT_INVENTORY(Inv4, 3, MPD_POS_BUTTON_LR_4_Y, MFD_TEXT_IND_WPN_RKT_INV_4_NAME, MFD_TEXT_IND_WPN_RKT_INV_4_QTY)
    WPN_RKT_INVENTORY(Inv5, 4, MPD_POS_BUTTON_LR_5_Y, MFD_TEXT_IND_WPN_RKT_INV_5_NAME, MFD_TEXT_IND_WPN_RKT_INV_5_QTY)

    class Static {
        type = line;
        width = 3;
        points[] = {
            // Burst limit box
            {{0.02,MPD_POS_BUTTON_LR_1_Y - MPD_TEXT_HEIGHT}, 1},
            {{0.11,MPD_POS_BUTTON_LR_1_Y - MPD_TEXT_HEIGHT}, 1},
            {{0.11,MPD_POS_BUTTON_LR_3_Y - 4*MPD_TEXT_HEIGHT}, 1}, {},
            {{0.11,MPD_POS_BUTTON_LR_3_Y + 5*MPD_TEXT_HEIGHT}, 1},
            {{0.11,MPD_POS_BUTTON_LR_5_Y + 2*MPD_TEXT_HEIGHT}, 1},
            {{0.02,MPD_POS_BUTTON_LR_5_Y + 2*MPD_TEXT_HEIGHT}, 1}, {},
            MPD_POINTS_BOX_PAD(Null, 0.5-6.5*MPD_TEXT_WIDTH, 0.78, 13*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT, 0.01)
        };
    };
    MPD_TEXT_C(Total_Rockets_Label, 0.5, 0.78, MPD_TEXT_STATIC("TOTAL ROCKETS"))
    MPD_TEXT_C(Total_Rockets, 0.5, 0.78+MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_RKT_TOT_QTY))

    MPD_TEXT_R(Inventory_Label_1, 0.11, MPD_POS_BUTTON_LR_3_Y - 4*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("I"))
    MPD_TEXT_R(Inventory_Label_2, 0.11, MPD_POS_BUTTON_LR_3_Y - 3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("N"))
    MPD_TEXT_R(Inventory_Label_3, 0.11, MPD_POS_BUTTON_LR_3_Y - 2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("V"))
    MPD_TEXT_R(Inventory_Label_4, 0.11, MPD_POS_BUTTON_LR_3_Y - 1*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))
    MPD_TEXT_R(Inventory_Label_5, 0.11, MPD_POS_BUTTON_LR_3_Y - 0*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("N"))
    MPD_TEXT_R(Inventory_Label_6, 0.11, MPD_POS_BUTTON_LR_3_Y + 1*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
    MPD_TEXT_R(Inventory_Label_7, 0.11, MPD_POS_BUTTON_LR_3_Y + 2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
    MPD_TEXT_R(Inventory_Label_8, 0.11, MPD_POS_BUTTON_LR_3_Y + 3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("R"))
    MPD_TEXT_R(Inventory_Label_9, 0.11, MPD_POS_BUTTON_LR_3_Y + 4*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Y"))

    class quantityDraw {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_POPOUT_MENU), 1));
        class static {
            color[] = {1,1,1,1};
            type = line;
            width = 3;
            points[] = {
                {{0.98, 0.1425 + (MPD_TEXT_HEIGHT / 2)}, 1},
                {{1 - (MPD_TEXT_WIDTH * 5), 0.1425 + (MPD_TEXT_HEIGHT / 2)}, 1},
                {{1 - (MPD_TEXT_WIDTH * 5), ((MPD_POS_BUTTON_LR_3_Y + MPD_POS_BUTTON_LR_4_Y) / 2) - MPD_TEXT_HEIGHT}, 1},
                {},
                {{1 - (MPD_TEXT_WIDTH * 5), ((MPD_POS_BUTTON_LR_3_Y + MPD_POS_BUTTON_LR_4_Y) / 2) + MPD_TEXT_HEIGHT * 2}, 1},
                {{1 - (MPD_TEXT_WIDTH * 5), 0.9}, 1},
                {{((MPD_POS_BUTTON_TB_5_X + MPD_POS_BUTTON_TB_6_X) / 2), 0.9}, 1},
                {{((MPD_POS_BUTTON_TB_5_X + MPD_POS_BUTTON_TB_6_X) / 2), 0.98}, 1},
                {}
            };
        };
        MPD_TEXT_L(QtyText_1, 1 - (MPD_TEXT_WIDTH * 5), ((MPD_POS_BUTTON_LR_3_Y + MPD_POS_BUTTON_LR_4_Y) / 2) - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Q"))
        MPD_TEXT_L(QtyText_2, 1 - (MPD_TEXT_WIDTH * 5), ((MPD_POS_BUTTON_LR_3_Y + MPD_POS_BUTTON_LR_4_Y) / 2), MPD_TEXT_STATIC("T"))
        MPD_TEXT_L(QtyText_3, 1 - (MPD_TEXT_WIDTH * 5), ((MPD_POS_BUTTON_LR_3_Y + MPD_POS_BUTTON_LR_4_Y) / 2) + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Y"))

        MPD_TEXT_L(Quantity_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y, MPD_TEXT_STATIC("1"))
        MPD_TEXT_L(Quantity_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, MPD_TEXT_STATIC("2"))
        MPD_TEXT_L(Quantity_4, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, MPD_TEXT_STATIC("4"))
        MPD_TEXT_L(Quantity_8, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("8"))
        MPD_TEXT_L(Quantity_12, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, MPD_TEXT_STATIC("12"))
        MPD_TEXT_L(Quantity_24, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y, MPD_TEXT_STATIC("24"))
        MPD_TEXT_C(Quantity_all, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("ALL"))

        class quantity_select_1 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_POPOUT), 1));
            MPD_BOX_L(Quantity_Select_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y, 1)
        };
        class quantity_select_2 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_POPOUT), 2));
            MPD_BOX_L(Quantity_Select_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_2_Y, 1)
        };
        class quantity_select_4 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_POPOUT), 4));
            MPD_BOX_L(Quantity_Select_4, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_3_Y, 1)
        };
        class quantity_select_8 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_POPOUT), 8));
            MPD_BOX_L(Quantity_Select_8, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, 1)
        };
        class quantity_select_12 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_POPOUT), 12));
            MPD_BOX_L(Quantity_Select_12, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y, 2)
        };
        class quantity_select_24 {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_POPOUT), 24));
            MPD_BOX_L(Quantity_Select_24, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y, 2)
        };
        class quantity_select_All {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_POPOUT), 99));
            MPD_BOX_C(Quantity_Select_ALL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, 3)
        };
    };
    class showVabs {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_WPN_POPOUT_MENU), 0));

        MPD_TEXT_L(Qty_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("QTY"))
        MPD_BOX_L(Qty, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 3)
        MPD_TEXT_L(Qty, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_RKT_SALVO))
        //R4
        MPD_BOX_BAR_L(TRAIN,    MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
        MPD_TEXT_L(TRAIN,      MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("TRAIN"))
        //R5
        MPD_TEXT_L(LRFD_label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("LRFD"))
        MPD_BOX_L(LRFD,        MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, 5)
        MPD_BOX_BAR_L(LRFD,    MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y)
        MPD_TEXT_L(LRFD,       MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("FIRST"))
        //R6
        MPD_ACQ_SRC(Acq, MFD_IND_WPN_ACQ_BOX, MFD_TEXT_IND_WPN_ACQ_SRC, Wpn_Acq)
        //B6
        MPD_TEXT_C(MANRNG_Label, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("MANRNG>"))
        MPD_TEXT_C(MANRNG,       MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("1000"))
    };
};