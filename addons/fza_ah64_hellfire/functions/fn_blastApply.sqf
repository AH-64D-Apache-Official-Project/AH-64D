/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_blastApply
Description: Applies blast damage to the units this machine owns, through ACE
    medical when it is loaded.
Parameters: _victims    - array of [unit, damage], damage 1 being lethal
            _source     - aircraft that fired
            _instigator - crew member that fired
Returns: Nothing
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_victims", "_source", "_instigator"];

private _killer = [_instigator, _source] select (isNull _instigator);
private _ace    = !isNil "ace_medical_fnc_addDamageToUnit";
{
    _x params ["_unit", "_damage"];
    if (!local _unit || {!alive _unit} || {!isDamageAllowed _unit}) then {continue};

    if (_ace) then {
        if !(_unit getVariable ["ace_medical_allowDamage", true]) then {continue};
        {
            [_unit, _damage * (_x # 1), _x # 0, "explosive", _killer] call ace_medical_fnc_addDamageToUnit;
        } forEach [["Body", 8], ["Head", 8], ["LeftArm", 3], ["RightArm", 3], ["LeftLeg", 3], ["RightLeg", 3]];
    } else {
        _unit setDamage [(damage _unit + _damage) min 1, true, _source, _instigator];
    };
} forEach _victims;
