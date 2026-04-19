// Skip during release - the archive hook handles it after signing
if HEMTT.is_release() {
    return;
}

let prefix = HEMTT.project().prefix();
let prefix_underscore = prefix + "_";
let duplicate = prefix_underscore + prefix_underscore;
let normalized = prefix_underscore;
let renamed = 0;
let scanned_dirs = 0;

let candidates = [
    HEMTT_OUT,
    HEMTT_OUT.join("build"),
    HEMTT_OUT.join("build").join("addons"),
    HEMTT_OUT.join("addons"),
    HEMTT_OUT.join("release"),
    HEMTT_OUT.join("release").join("addons")
];

for root in HEMTT_OUT.list() {
    if !root.is_dir() {
        continue;
    }
    candidates.push(root);
    candidates.push(root.join("addons"));
    for child in root.list() {
        if !child.is_dir() {
            continue;
        }
        candidates.push(child);
        candidates.push(child.join("addons"));
    }
}

for dir in candidates {
    if !dir.is_dir() {
        continue;
    }

    scanned_dirs += 1;
    for file in dir.list() {
        if !file.is_file() {
            continue;
        }
        let ext = file.file_ext();
        if ext != "pbo" && ext != "bisign" {
            continue;
        }

        let name = file.file_name();
        let new_name = name;
        // Fix doubled prefix: fza_ah64_fza_ah64_X -> fza_ah64_X
        new_name.replace(duplicate, normalized);
        // Fix misplaced prefix on non-prefixed addons: fza_ah64_fza_compat_X -> fza_compat_X
        if new_name == name {
            new_name.replace(prefix_underscore + "fza_", "fza_");
        }
        if new_name == name {
            continue;
        }

        let dst = dir.join(new_name);
        if dst.is_file() {
            dst.remove_file();
        }

        if file.move(dst) {
            renamed += 1;
            info("normalize_pbo_names: " + name + " -> " + new_name + " (" + dir.to_string() + ")");
        } else {
            warn("normalize_pbo_names: failed to rename " + name + " in " + dir.to_string());
        }
    }
}

info("normalize_pbo_names: scanned " + scanned_dirs.to_string() + " dirs, renamed " + renamed.to_string() + " file(s)");
