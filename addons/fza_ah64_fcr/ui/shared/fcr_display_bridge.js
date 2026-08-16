// SQF→HTML bridge stubs for the FCR display pages (one-directional ExecJS pushes)
(function () {
    "use strict";
    // Stubs so ExecJS calls don't throw before the display script registers itself
    if (!window.fzaFCRRmap)  { window.fzaFCRRmap  = { update: function () {} }; }
    if (!window.fzaFCRTpm)   { window.fzaFCRTpm   = { update: function () {} }; }
    if (!window.fzaFCRScope) { window.fzaFCRScope = { update: function () {} }; }
}());
