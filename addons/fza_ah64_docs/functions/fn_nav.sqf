/* ----------------------------------------------------------------------------
Function: fza_docs_fnc_nav

Description:
    The manual's sections and pages, from CfgFzaDocs.

Parameters:
    None

Returns:
    [[section title, [[page title, path], ...]], ...] <ARRAY>

Examples:
    --- Code
    call fza_docs_fnc_nav
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
if (!isNil "fza_docs_navCache") exitWith {fza_docs_navCache};

fza_docs_navCache = ("true" configClasses (configFile >> "CfgFzaDocs" >> "Sections")) apply {
    [
        getText (_x >> "title"),
        ("true" configClasses (_x >> "Pages")) apply {[getText (_x >> "title"), getText (_x >> "path")]}
    ]
};
fza_docs_navCache
