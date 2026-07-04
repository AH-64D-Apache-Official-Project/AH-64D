// Lightweight SQF→HTML bridge for FCR display pages (RMAP, TPM).
// These displays are one-directional: SQF pushes JSON data each frame via ExecJS.
// No score/music/net callbacks needed (unlike the minigame bridge).
// SQF calls: fzaFCRRmap.update(data) and fzaFCRTpm.update(data)
// Both are registered by their respective display scripts; this file is a no-op placeholder
// that ensures a consistent load order when both displays share a future common asset.
(function () {
    "use strict";
    // Ensure namespaces exist so ExecJS calls won't throw if update() is called before
    // the display script finishes registering itself (e.g. during rapid page transitions).
    if (!window.fzaFCRRmap) { window.fzaFCRRmap = { update: function () {} }; }
    if (!window.fzaFCRTpm)  { window.fzaFCRTpm  = { update: function () {} }; }
}());
