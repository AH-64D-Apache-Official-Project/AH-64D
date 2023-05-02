#include "\fza_ah64_dms\headers\constants.h"

//TSD Pages
#define TSD_ROOT                [0, 0]
#define TSD_SHOW                [1, 0]

//--Waypoint sub-page selections
#define TSD_WPT                 [2, 0]
#define TSD_WPT_ADD             [2, 1]
//--Delete
#define TSD_WPT_DEL_NOPOINTSEL  [2, 2]
#define TSD_WPT_DEL_POINTSEL    [2, 3]
//--Edit
#define TSD_WPT_EDT_NOPOINTSEL  [2, 4]
#define TSD_WPT_EDT_POINTSEL    [2, 5]
#define TSD_WPT_STO             [2, 6]
#define TSD_WPT_XMIT            [2, 7]

//Route sub-page selections     
#define TSD_RTE                 [3, 0]
#define TSD_RTE_ADD             [3, 1]
#define TSD_RTE_DEL             [3, 2]
//--Direct
#define TSD_RTE_DIR_NOPOINTSEL  [3, 3]
#define TSD_RTE_DIR_POINTSEL    [3, 4]
#define TSD_RTE_RVW             [3, 5]
#define TSD_RTE_RTM             [3, 6]                   

//Threat sub-page selections    
#define TSD_THRT                [4, 0]
#define TSD_THRT_ADD            [4, 1]
//--Delete
#define TSD_THRT_DEL_NOPOINTSEL [4, 2]
#define TSD_THRT_DEL_POINTSEL   [4, 3]
//--Edit
#define TSD_THRT_EDT_NOPOINTSEL [4, 4]
#define TSD_THRT_EDT_POINTSEL   [4, 5]
#define TSD_THRT_STO            [4, 6]
#define TSD_THRT_XMIT           [4, 7]

//FCR Page
#define FCR_ROOT                [5, 0]

//ASE Page
#define ASE_ROOT                [6, 0]

//DTU Pages
#define DTU_ROOT                0
#define DTU_LOAD_STATUS         1