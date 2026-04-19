// Rename release zips from the HEMTT default naming to the public-facing names:
//   fza_ah64-{version}.zip -> ah64-{version}.zip
//   fza_ah64-latest.zip    -> ah64-latest.zip
//
// The "fza_ah64" internal prefix is stripped to produce the cleaner "ah64" name
// that is used for public distribution.

let releases = HEMTT_RFS.join("releases");
if !releases.is_dir() {
    return;
}

let prefix = HEMTT.project().prefix();   // "fza_ah64"
let version = HEMTT.project().version().to_string();  // e.g. "2.2.9.2"

// Build the short prefix: "fza_ah64" -> "ah64"
let short_prefix = prefix;
short_prefix.replace("fza_", "");

// Rename versioned zip
let old_versioned = releases.join(prefix + "-" + version + ".zip");
if old_versioned.is_file() {
    let new_versioned = releases.join(short_prefix + "-" + version + ".zip");
    if old_versioned.move(new_versioned) {
        info("rename_zips: " + prefix + "-" + version + ".zip -> " + short_prefix + "-" + version + ".zip");
    } else {
        fatal("rename_zips: failed to rename " + prefix + "-" + version + ".zip");
    }
}

// Rename latest zip
let old_latest = releases.join(prefix + "-latest.zip");
if old_latest.is_file() {
    let new_latest = releases.join(short_prefix + "-latest.zip");
    if old_latest.move(new_latest) {
        info("rename_zips: " + prefix + "-latest.zip -> " + short_prefix + "-latest.zip");
    } else {
        fatal("rename_zips: failed to rename " + prefix + "-latest.zip");
    }
}
