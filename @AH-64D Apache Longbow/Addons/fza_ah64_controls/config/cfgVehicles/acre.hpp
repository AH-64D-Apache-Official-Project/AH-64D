class AcreIntercoms
{
    class Intercom_1
    {
        displayName         = "Intercom (ICS)";
        shortName           = "ICS";
        allowedPositions[]  = {"crew"};
        disabledPositions[] = {};
        masterPositions[]   = {"crew"};  // Seats with master stations have the possibility of broadcasting a message in that network
        limitedPositions[]  = {"cargo"}; // Despite not having regular access to the network, units in cargo positions can have limited connections to communicate with the crew. These positions do not transmit automatically in the limited network; units in this position must toggle the functionality manually.
        numLimitedPositions = 3;         // This is the number of simultaneous connections that units defined in the previous array can have
        connectedByDefault  = 0;         // The intercom initial configuration is enabled upon entering a vehicle
    };
};

acre_hasInfantryPhone              = 1;              // 1 - enabled, 0 - disabled
acre_infantryPhoneDisableRinging   = 1;              // If set to 1, the ringing funtionality will not be available
acre_infantryPhoneCustomRinging[]  = {};             // An array used in order to override the default sound for the ringing functionality
acre_infantryPhoneIntercom[]       = {"intercom_1"}; // List of intercom names (intercom_1, intercom_2) or "all" in order to specify which intercom networks the phone can connect to
acre_infantryPhoneControlActions[] = {"intercom_1"}; // Only those units in "intercom_1" can have access to ringing functionality
acre_eventInfantryPhone            = "";

class AcreRacks
{
    class Rack_1
    {
        displayName         = "ARC-186 (VHF)";      // Name is displayed in the interaction menu.
        shortName           = "VHF";
        allowedPositions[]  = {"driver","gunner"};  // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
        componentName       = "ACRE_VRC103";
        disabledPositions[] = {};
        defaultComponents[] = {};                   // Use this to attach simple components like Antennas. Not yet fully implemented
        mountedRadio        = "ACRE_PRC117F";       // Predefined mounted radio
        isRadioRemovable    = 0;
        intercom[]          = {};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
    };
    class Rack_2
    {
        displayName         = "ARC-164 (UHF)";      // Name is displayed in the interaction menu.
        shortName           = "UHF";
        allowedPositions[]  = {"driver","gunner"};  // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
        componentName       = "ACRE_VRC103";
        disabledPositions[] = {};
        defaultComponents[] = {};                   // Use this to attach simple components like Antennas. Not yet fully implemented
        mountedRadio        = "ACRE_PRC117F";       // Predefined mounted radio
        isRadioRemovable    = 0;
        intercom[]          = {};                   // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
    };
    class Rack_3
    {
        displayName         = "ARC-201D (FM1)";    // Name is displayed in the interaction menu.
        shortName           = "FM1";
        allowedPositions[]  = {"driver","gunner"}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
        componentName       = "ACRE_SEM90";
        disabledPositions[] = {};
        defaultComponents[] = {};                  // Use this to attach simple components like Antennas. Not yet fully implemented
        mountedRadio        = "ACRE_SEM70";        // Predefined mounted radio
        isRadioRemovable    = 0;
        intercom[]          = {};                  // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
    };
    class Rack_4
    {
        displayName         = "ARC-201D (FM2)";    // Name is displayed in the interaction menu.
        shortName           = "FM2";
        allowedPositions[]  = {"driver","gunner"}; // Who can configure the radio and open the radio GUI. Same wildcards as the intercom. It also allows transmitting/receiving
        componentName       = "ACRE_SEM90";
        disabledPositions[] = {};
        defaultComponents[] = {};                  // Use this to attach simple components like Antennas. Not yet fully implemented
        mountedRadio        = "ACRE_SEM70";        // Predefined mounted radio
        isRadioRemovable    = 0;
        intercom[]          = {};                  // All units in intercom will be able to hear/send transmittions (ACE3 interaction menu) but they cannot manipulate the radio (GUI interface)
    };
};