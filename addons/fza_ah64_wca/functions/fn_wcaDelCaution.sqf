params ["_activeCaut", "_ufdText"];

if (_ufdText in _activeCaut) then {
    _activeCaut deleteAt _ufdText;
};
