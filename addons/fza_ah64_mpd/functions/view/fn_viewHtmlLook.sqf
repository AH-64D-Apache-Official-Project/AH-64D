/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_viewHtmlLook

Description:
    Applies BRT and DAY/NIGHT/MONO to an MPD's HTML page, through a filter
    over the whole page: its brightness scaled, and with MONO a colour matrix
    that leaves it green only. Pushed on a change, and again each second in
    case the page was still loading.

Parameters:
    _ctrl  - The page's browser control
    _light - The light let through, 0-1
    _mono  - MONO on

Returns:
    Nothing

Examples:
    --- Code
    [_ctrl, 0.5, true] call fza_mpd_fnc_viewHtmlLook
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_ctrl", "_light", "_mono"];

if (isNull _ctrl) exitWith {};
private _look = [(round (_light * 1000)) / 1000, _mono];
(_ctrl getVariable ["fza_mpd_lookSent", [[], -10]]) params ["_sent", "_tick"];
if (_sent isEqualTo _look && {diag_tickTime - _tick < 1}) exitWith {};
_ctrl setVariable ["fza_mpd_lookSent", [_look, diag_tickTime]];

// MONO: green from the colour's channels, red counted fully so red and yellow symbols stay bright; alpha unchanged
[_ctrl, format ["(function(b,m){var d=document,id='fzaMono';if(m&&!d.getElementById(id)){var n='http://www.w3.org/2000/svg',s=d.createElementNS(n,'svg'),f=d.createElementNS(n,'filter'),c=d.createElementNS(n,'feColorMatrix');s.setAttribute('width','0');s.setAttribute('height','0');s.style.position='absolute';f.setAttribute('id',id);f.setAttribute('color-interpolation-filters','sRGB');c.setAttribute('type','matrix');c.setAttribute('values','0.2 0.16 0.12 0 0 1 0.8 0.6 0 0 0 0 0 0 0 0 0 0 1 0');f.appendChild(c);s.appendChild(f);(d.body||d.documentElement).appendChild(s);}var v=(m?'url(#'+id+') ':'')+(b<1?'brightness('+b+')':'');d.documentElement.style.filter=v;})(%1,%2)", _look # 0, ["false", "true"] select _mono]] call fza_mpd_fnc_execJs;
