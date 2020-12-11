#ifndef PYLONS_H
#define PYLONS_H

#define PYLON_1 0
#define PYLON_2 7
#define PYLON_3 14
#define PYLON_4 21
#define PYLON_SIZE 7

#define PYLON_ZONEA 0
#define PYLON_ZONEB 1
#define PYLON_ZONEE 2
#define PYLON_HF_UL 3
#define PYLON_HF_UR 4
#define PYLON_HF_LL 5
#define PYLON_HF_LR 6

#define PYLON_ROCKETS(_pylNum) ([PYLON_ZONEA, PYLON_ZONEB, PYLON_ZONEE] apply {_x + _pylNum})
#define PYLON_MISSILES(_pylNum) ([PYLON_HF_UL, PYLON_HF_UR, PYLON_HF_LL, PYLON_HF_LR] apply {_x + _pylNum})

#define PYLON_TO_STANDARD(val) ((val)-1)
#define PYLON_FROM_STANDARD(val) ((val)+1)
#endif