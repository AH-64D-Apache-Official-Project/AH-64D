/* ----------------------------------------------------------------------------
Function: fza_mg_fnc_minigamePlaySfx

Description:
    Plays an Arma sound for a minigame SFX cue - CT_WEBBROWSER can't play Web Audio at all.
    Uses playSound (local, non-positional), matching the pattern used elsewhere in the mod for cockpit
    button-feedback sounds (e.g. fn_engineHandleControl.sqf, fn_doorToggle.sqf) - 3D-attached sounds
    (say3D/playSound3D) get heavily occluded by Arma's sealed-cockpit audio environment and are barely audible.

Parameters:
    _sfxName - string, one of "shoot" / "explosionSmall" / "explosionBig" / "death"

Returns:
    Nothing
---------------------------------------------------------------------------- */
params [["_sfxName", ""]];
if (profileNamespace getVariable ["fza_minigame_muted", false]) exitWith {};

private _sound = switch (_sfxName) do {
    case "shoot": {"fza_minigame_sfx_shoot"};
    case "explosionSmall": {"fza_minigame_sfx_explosionSmall"};
    case "explosionBig": {"fza_minigame_sfx_explosionBig"};
    case "death": {"fza_minigame_sfx_death"};
    default {""};
};
if (_sound == "") exitWith {};

playSound _sound;
