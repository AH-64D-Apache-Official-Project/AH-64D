class VABs_Mode_Rkt {
    condition =  __EVAL(format [STRINGIFY(EQ(user%1,2)), MFD_OFFSET + MFD_IND_WPN_SELECTED_WPN]);
    #define WPN_RKT_INVENTORY(className, invIndex, posY, nameSource, qtySource) \
    class className {\
        MPD_TEXT_R(Name, MPD_POS_BUTTON_L_X, posY - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_USER(nameSource)) \
        MPD_TEXT_R(Qty, MPD_POS_BUTTON_L_X, posY + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_USER(qtySource)) \
        class Box {\
            condition =  __EVAL(format [STRINGIFY(EQ(user%1,invIndex)), MFD_OFFSET + MFD_IND_WPN_SELECTED_RKT_INV]);\
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

    MPD_TEXT_L(Qty_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("QTY"))
    MPD_BOX_L(Qty, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 3)
    MPD_TEXT_L(Qty, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_RKT_SALVO))
};