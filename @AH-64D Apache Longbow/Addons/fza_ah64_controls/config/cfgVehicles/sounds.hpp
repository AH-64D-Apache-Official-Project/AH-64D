class Sounds
{
        class EngineExt
        {
            sound[] = {"\fza_ah64_controls\data\audio\Engine", 1, 1.000000, 1200};
            frequency = "rotorSpeed";
            volume = "camPos*((rotorSpeed-0.72)*4)";
        };
        class RotorExt
        {
            sound[] = {"\fza_ah64_controls\data\audio\Ext_Rotor.ogg", 1, 1.000000, 1200};
            frequency = "rotorSpeed * (1 - rotorThrust/5)";
            volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
        };
        class EngineClose
        {
            sound[] = {"\fza_ah64_controls\data\audio\Engine_Close.ogg", 1, 1.000000, 1200};
            frequency = "rotorSpeed";
            volume = "camPos*((rotorSpeed-0.72)*4)";
        };
        class RotorClose
        {
            sound[] = {"\fza_ah64_controls\data\audio\Rotor_Close.ogg", 1, 1.000000, 1200};
            frequency = "rotorSpeed * (1 - rotorThrust/5)";
            volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
        };
        class RotorSwist
        {
            sound[] = {"A3\Sounds_F\vehicles\air\Heli_Attack_01\swist", 0.500000, 1, 300};
            frequency = 1;
            volume = "camPos * (rotorThrust factor [0.7, 0.9])";
        };
        class TailRotor
        {
            cone[] = {3, 1.57, 3, 1.57};
            frequency = "rotorSpeed";
            sound[] = {"\fza_ah64_controls\data\audio\Ext_Tail_Rotor.ogg", 3, 1, 1200};
            volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
        };
        class Distance
        {
            sound[]  = {"\fza_ah64_controls\data\audio\Engine_Far.ogg", 4, 1, 3500};
            frequency = "rotorSpeed";
            volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
        };
        class FarDistance
        {
            sound[]  = {"\fza_ah64_controls\data\audio\Rotor_Far.ogg", 4, 1, 3500};
            frequency = "rotorSpeed";
            volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
        };
        class EngineInt
        {
            sound[] = {"\fza_ah64_controls\data\audio\Int_Engine.ogg", 1, 1.000000};
            frequency = "rotorSpeed";
            volume = "(1-camPos)*((rotorSpeed-0.75)*4)";
        };
        class RotorInt
        {
            sound[] = {"\fza_ah64_controls\data\audio\Int_Rotor.ogg", 1, 1};
            frequency = "rotorSpeed * (1 - rotorThrust/5)";
            volume = "(1-camPos)*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
        };
        class TransmissionDamageExt_phase1
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_1", 1.000000, 1.000000, 150};
            frequency = "0.66 + rotorSpeed / 3";
            volume = "camPos * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
        };
        class TransmissionDamageExt_phase2
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_2", 1.000000, 1.000000, 150};
            frequency = "0.66 + rotorSpeed / 3";
            volume = "camPos * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
        };
        class TransmissionDamageInt_phase1
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_1", 1.000000, 1.000000, 150};
            frequency = "0.66 + rotorSpeed / 3";
            volume = "(1 - camPos) * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
        };
        class TransmissionDamageInt_phase2
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_2", 1.000000, 1.000000, 150};
            frequency = "0.66 + rotorSpeed / 3";
            volume = "(1 - camPos) * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
        };
        class rotorLowAlarmInt
        {
            sound[] = {"\fza_ah64_audio\audio\systems\bt_rotor_rpm_low.ogg", 1, 1.000000};
            frequency = 1;
            volume = "engineOn * (1 - camPos) * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
        };
        class scrubLandInt
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\wheelsInt", 1.000000, 1.000000, 100};
            frequency = 1;
            volume = "2 * (1-camPos) * (scrubLand factor[0.02, 0.05]) * (1 - (lateralMovement factor [0.7,1]))";
        };
        class scrubLandExt
        {
            sound[] = {"A3\Sounds_F\dummysound", 1.000000, 1.000000, 100};
            frequency = 1;
            volume = "camPos * (scrubLand factor[0.02, 0.05]) * (1 - (lateralMovement factor [0.7,1]))";
        };
        class scrubBuildingInt
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\wheelsInt", 1.000000, 1.000000, 100};
            frequency = 1;
            volume = "(1-camPos) * (scrubBuilding factor[0.02, 0.05]) * (1 - (lateralMovement factor [0.7,1]))";
        };
        class scrubBuildingExt
        {
            sound[] = {"A3\Sounds_F\dummysound", 1.000000, 1.000000, 100};
            frequency = 1;
            volume = "camPos * (scrubBuilding factor[0.02, 0.05])";
        };
        class scrubTreeInt
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubTreeInt", 1.000000, 1.000000, 100};
            frequency = 1;
            volume = "(1 - camPos) * ((scrubTree) factor [0, 0.01])";
        };
        class scrubTreeExt
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubTreeExt", 1.000000, 1.000000, 100};
            frequency = 1;
            volume = "camPos * ((scrubTree) factor [0, 0.01])";
        };
        class RainExt
        {
            sound[] = {"\fza_ah64_controls\data\audio\Ext_Rain.ogg", 1.000000, 1.000000, 100};
            frequency = 1;
            volume = "camPos * (rain - rotorSpeed/2) * 2";
        };
        class RainInt
        {
            sound[] = {"\fza_ah64_controls\data\audio\Int_Rain.ogg", 1.000000, 1.000000, 100};
            frequency = 1;
            volume = "(1-camPos)*(rain - rotorSpeed/2)*2";
        };
        class SlingLoadDownExt
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownEXT", 1.258925, 1.000000, 500};
            frequency = 1;
            volume = "camPos*(slingLoadActive factor [0,-1])";
        };
        class SlingLoadUpExt
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineupEXT", 1.258925, 1.000000, 500};
            frequency = 1;
            volume = "camPos*(slingLoadActive factor [0,1])";
        };
        class SlingLoadDownInt
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownINT", 1.000000, 1.000000, 500};
            frequency = 1;
            volume = "(1-camPos)*(slingLoadActive factor [0,-1])";
        };
        class SlingLoadUpInt
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineUpINT", 1.000000, 1.000000, 500};
            frequency = 1;
            volume = "(1-camPos)*(slingLoadActive factor [0,1])";
        };
        class WindInt
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\wind_closed", 0.398107, 1.000000, 50};
            frequency = 1;
            volume = "(1-camPos)*(speed factor[5, 50])*(speed factor[5, 50])";
        };
        class GStress
        {
            sound[] = {"A3\Sounds_F\vehicles\noises\vehicle_stress2b", 0.354813, 1.000000, 50};
            frequency = 1;
            volume = "engineOn * (1-camPos) * ((gmeterZ factor[1.5, 2.5]) + (gmeterZ factor[0.5, -0.5]))";
        };
        class ETL_VRS_Shake_01
        {
            sound[]   = {"\fza_ah64_controls\data\audio\CreakingAirFrame.ogg", 1, 1};
            frequency = "CustomSoundController3";
            volume    = "(1-camPos)*rotorSpeed*CustomSoundController4";
        };
        class ETL_VRS_Shake_02
        {
            sound[]   = {"A3\Sounds_F\vehicles\noises\vehicle_stress3", 1, 1};
            frequency = "CustomSoundController3";
            volume    = "(1-camPos)*rotorSpeed*CustomSoundController4";
        };
};