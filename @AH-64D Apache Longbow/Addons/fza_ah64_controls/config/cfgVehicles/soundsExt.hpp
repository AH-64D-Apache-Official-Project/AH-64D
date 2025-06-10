class SoundsExt
{
    class Sounds
    {
        class EngineExt
        {
            sound[] = {"\fza_ah64_model\audio\Engine", 1, 1.000000, 1200};
            frequency = "rotorSpeed";
            volume = "camPos*((rotorSpeed-0.72)*4)";
        };
        class RotorExt
        {
            sound[] = {"\fza_ah64_model\audio\Ext_Rotor.ogg", 1, 1.000000, 1200};
            frequency = "rotorSpeed * (1 - rotorThrust/5)";
            volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
        };
        class EngineClose
        {
            sound[] = {"\fza_ah64_model\audio\Engine_Close.ogg", 1, 1.000000, 1200};
            frequency = "rotorSpeed";
            volume = "camPos*((rotorSpeed-0.72)*4)";
        };
        class RotorClose
        {
            sound[] = {"\fza_ah64_model\audio\Rotor_Close.ogg", 1, 1.000000, 1200};
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
            sound[] = {"\fza_ah64_model\audio\Ext_Tail_Rotor.ogg", 3, 1, 1200};
            volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
        };
        class Distance
        {
            sound[]  = {"\fza_ah64_model\audio\Engine_Far.ogg", 4, 1, 3500};
            frequency = "rotorSpeed";
            volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
        };
        class FarDistance
        {
            sound[]  = {"\fza_ah64_model\audio\Rotor_Far.ogg", 4, 1, 3500};
            frequency = "rotorSpeed";
            volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
        };
        class EngineInt
        {
            sound[] = {"\fza_ah64_model\audio\Int_Engine.ogg", 1, 1.000000};
            frequency = "rotorSpeed";
            volume = "(1-camPos)*((rotorSpeed-0.75)*4)";
        };
        class RotorInt
        {
            sound[] = {"\fza_ah64_model\audio\Int_Rotor.ogg", 1, 1};
            frequency = "rotorSpeed * (1 - rotorThrust/5)";
            volume = "(1-camPos)*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
        };
        class TransmissionDamageExt_phase1
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_1", 1.000000, 1.000000, 200};
            frequency = "0.66 + rotorSpeed / 3";
            volume = "camPos * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
        };
        class TransmissionDamageExt_phase2
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_2", 1.000000, 1.000000, 200};
            frequency = "0.66 + rotorSpeed / 3";
            volume = "camPos * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
        };
        class TransmissionDamageInt_phase1
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_1", 1.000000, 1.000000, 200};
            frequency = "0.66 + rotorSpeed / 3";
            volume = "(1 - camPos) * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
        };
        class TransmissionDamageInt_phase2
        {
            sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_2", 1.000000, 1.000000, 200};
            frequency = "0.66 + rotorSpeed / 3";
            volume = "(1 - camPos) * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
        };
    };
};