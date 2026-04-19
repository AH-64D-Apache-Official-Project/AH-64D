// Generates version.hpp for each addon:
//   version = "X.Y.Z.B";
//   versionStr = "X.Y.Z.B";
//   versionAr[] = {X, Y, Z, B};
//   hash = "XXXXXXXX";
// The controls addon additionally gets:
//   pbos[] = {"fza_ah64_ase", "fza_ah64_audio", ...};

// --- Read git commit hash from .git directory ---
let head = HEMTT_RFS.join(".git").join("HEAD").open_file().read();
head.trim();  // trim() modifies in-place in Rhai

let full_hash = "";
if head.contains("ref: ") {
    let ref_path = head;
    ref_path.replace("ref: ", "");
    ref_path.trim();
    let parts = ref_path.split("/");
    let ref_file = HEMTT_RFS.join(".git");
    for part in parts {
        ref_file = ref_file.join(part);
    }
    if ref_file.is_file() {
        full_hash = ref_file.open_file().read();
        full_hash.trim();
    } else {
        // Fallback: check packed-refs
        let packed_path = HEMTT_RFS.join(".git").join("packed-refs");
        if packed_path.is_file() {
            let packed = packed_path.open_file().read();
            for line in packed.split("\n") {
                let l = line;
                l.trim();
                if l.len() > 0 && !l.contains("#") && l.contains(ref_path) {
                    full_hash = l.split(" ")[0];
                    break;
                }
            }
        }
    }
} else {
    // Detached HEAD contains the hash directly
    full_hash = head;
}

if full_hash.len() == 0 {
    fatal("Could not determine git commit hash");
}

let hash = full_hash.sub_string(0, 8);

// --- Enumerate addon folders ---
let addons_path = HEMTT_VFS.join("addons");
let entries = addons_path.list();

let addon_names = [];
for entry in entries {
    if entry.is_dir() {
        addon_names.push(entry.file_name());
    }
}
addon_names.sort();

// --- Build pbos[] array string (folder names are already the PBO names) ---
let pbos_parts = [];
for name in addon_names {
    pbos_parts.push("\"" + name + "\"");
}
let pbos_str = "";
for i in 0..pbos_parts.len() {
    if i > 0 {
        pbos_str += ", ";
    }
    pbos_str += pbos_parts[i];
}

// --- Write version.hpp to each addon ---
let controls_name = HEMTT.project().prefix() + "_controls";
let ver = HEMTT.project().version();
let ver_str = ver.major().to_string() + "." + ver.minor().to_string() + "." + ver.patch().to_string() + "." + ver.build().to_string();
let ver_ar = ver.major().to_string() + ", " + ver.minor().to_string() + ", " + ver.patch().to_string() + ", " + ver.build().to_string();
let version_lines = "version = \"" + ver_str + "\";\n";
version_lines += "versionStr = \"" + ver_str + "\";\n";
version_lines += "versionAr[] = {" + ver_ar + "};\n";
let hash_line = "hash = \"" + hash + "\";\n";
let rfs_addons_path = HEMTT_RFS.join("addons");
for name in addon_names {
    let version_file = addons_path.join(name).join("version.hpp");
    let out = version_file.create_file();
    let rfs_version_file = rfs_addons_path.join(name).join("version.hpp");
    let rfs_out = rfs_version_file.create_file();
    if name == controls_name {
        out.write(version_lines);
        out.write(hash_line);
        out.write("pbos[] = {" + pbos_str + "};\n");
        rfs_out.write(version_lines);
        rfs_out.write(hash_line);
        rfs_out.write("pbos[] = {" + pbos_str + "};\n");
    } else {
        out.write(version_lines);
        out.write(hash_line);
        rfs_out.write(version_lines);
        rfs_out.write(hash_line);
    }
}

print("Generated version.hpp for " + addon_names.len() + " addons (hash: " + hash + ")");
