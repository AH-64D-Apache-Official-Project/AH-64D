/* ----------------------------------------------------------------------------
Function: fza_mg_fnc_minigamePlaySfx

Description:
    Plays a non-positional Arma sound for a minigame SFX cue via playSoundUI - CT_WEBBROWSER can't play Web Audio, and 3D-attached sounds get inaudibly occluded inside the sealed cockpit.

Parameters:
    _sfxName - string, one of "shoot" / "explosionSmall" / "explosionBig" / "death", or any CfgSounds class name directly
    _volume - number, optional, playSoundUI's own multiplier range (0..5), default 1

Returns:
    Nothing
---------------------------------------------------------------------------- */
params [["_sfxName", ""], ["_volume", 1]];
if (profileNamespace getVariable ["fza_minigame_muted", false]) exitWith {};

// Short-hand aliases for older callers; anything else (e.g. Doom's "fza_doom_sfx_pistol") is used as the CfgSounds class name directly.
private _sound = switch (_sfxName) do {
    case "shoot": {"fza_minigame_sfx_shoot"};
    case "explosionSmall": {"fza_minigame_sfx_explosionSmall"};
    case "explosionBig": {"fza_minigame_sfx_explosionBig"};
    case "death": {"fza_minigame_sfx_death"};
    default {_sfxName};
};
if (_sound == "") exitWith {};

playSoundUI [_sound, _volume];
