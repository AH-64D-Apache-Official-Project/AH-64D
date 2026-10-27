/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_r2tTexture

Description:
    The texture of a sensor render target, the same wherever it is shown (HDU,
    MPD) so the sensor is rendered once. It keeps the screen's aspect. A render
    target ignores a non-square size, so the TADS texture is larger by the power
    of two nearest the screen's aspect, which shrinks its stretched texels.
    The screen's aspect is the one measured outside any ui() display
    (fza_ihadss_screenAspect): inside one, as an MPD's draw is, the screen
    commands describe that display's texture instead.

Parameters:
    _target - The render target, from the aircraft's RenderTargets

Returns:
    The texture

Examples:
    --- Code
    _picture ctrlSetText (["fza_ah64_tadscam_dtv"] call fza_ihadss_fnc_r2tTexture)
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_target"];

// The DTV is rendered by a script camera while it is shown (fza_ihadss_fnc_dtvCamera), on mission time
if (_target == "fza_ah64_tadscam_dtv") then {fza_ihadss_dtvShownAt = time};

private _aspect = missionNamespace getVariable ["fza_ihadss_screenAspect", (safeZoneW / pixelW) / (safeZoneH / pixelH)];
private _size   = 1024;
if (_target in ["fza_ah64_tadscam_flir", "fza_ah64_tadscam_dtv"]) then {_size = 1024 * 2 ^ (round (ln _aspect / ln 2) max 0)};
format ["#(argb,%1,%1,1)r2t(%2,%3)", round _size, _target, _aspect]
