params ["_activeWarn", "_mpdText"];

if (_mpdText in _activeWarn) then {
    _activeWarn deleteAt _mpdText;
};
