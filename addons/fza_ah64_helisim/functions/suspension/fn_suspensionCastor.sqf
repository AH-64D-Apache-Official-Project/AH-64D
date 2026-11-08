/* ----------------------------------------------------------------------------
Function: fza_suspension_fnc_suspensionCastor

Description:
    The tail wheel's swivel. Locked, the pin holds it along the aircraft's long axis.
    Unlocked, it trails behind its swivel axis and follows the direction it is moving,
    through a full 360 degrees. Selecting the lock does not centre the wheel: the pin
    only drops in once the wheel swings back near centre.

    The angle is clockwise from above, zero rolling straight ahead with the wheel
    trailing aft of the axis.

Parameters:
    _heli      - The helicopter [Object]
    _onGround  - The tail wheel is on the ground [Bool]
    _deltaTime - Frame time, s [Number]

Returns:
    [swivel angle in degrees, pin engaged]

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_helisim\functions\suspension\suspension.hpp"

params ["_heli", "_onGround", "_deltaTime"];

private _angle  = _heli getVariable "fza_suspension_castorAngle";
private _pinned = (_heli getVariable ["fza_ah64_tailWheelLock", true]) && {abs _angle <= SUSP_CASTOR_PIN_ANGLE};

if (_pinned) then {
    _angle = 0.0;
} else {
    if (_onGround) then {
        //Velocity at the wheel, as in fza_suspension_fnc_suspensionWheel.
        private _velModel = _heli vectorWorldToModel (velocity _heli);
        private _yawRate  = (_heli vectorWorldToModel (angularVelocity _heli)) select 2;
        private _velX     = (_velModel select 0) + (_yawRate * (SUSP_WHEEL_TAIL select 1));
        private _velY     = (_velModel select 1) - (_yawRate * (SUSP_WHEEL_TAIL select 0));
        private _speed    = vectorMagnitude [_velX, _velY, 0.0];

        //The wheel closes on its direction of travel over one trail length rolled. The exponential
        //keeps that stable at any speed and frame rate.
        if (_speed > 0.01) then {
            private _error = (((_velX atan2 _velY) - _angle + 540.0) % 360.0) - 180.0;
            _angle = _angle + (_error * (1.0 - exp (-_speed * _deltaTime / SUSP_CASTOR_TRAIL)));
        };

        //A wheel standing still on the ground stays put while the aircraft turns over it.
        _angle = _angle - (deg (_yawRate * _deltaTime));
        _angle = ((_angle + 540.0) % 360.0) - 180.0;
    };
};
_heli setVariable ["fza_suspension_castorAngle", _angle];

//Only when it has visibly moved: animateSource goes to every machine.
if (abs (_angle - (_heli getVariable "fza_suspension_castorAnimated")) > SUSP_CASTOR_ANIM_STEP) then {
    _heli setVariable ["fza_suspension_castorAnimated", _angle];
    _heli animateSource ["tailWheelCastor", _angle, true];
};

[_angle, _pinned]
