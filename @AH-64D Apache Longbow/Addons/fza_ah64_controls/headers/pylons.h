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

PYLON_TO_STANDARD(val) ((val)-1)
PYLON_FROM_STANDARD(val) ((val)+1)
#endif