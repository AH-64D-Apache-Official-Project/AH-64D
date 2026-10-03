// RELEASE GUARD: refuse to build a release while the dev-only .sqfc exclude is active.
//
// project.toml carries `exclude = ["**/*.sqfc"]` under [files] so that -filePatching
// works during development (Arma prefers a .sqfc over its matching .sqf, so a PBO
// carrying bytecode silently ignores loose source edits). That exclude is GLOBAL - it
// applies to release too - so leaving it in would ship PBOs stripped of their compiled
// SQF, losing the performance the bytecode exists to provide.
//
// A shipped release regressing on script performance is both easy to do by accident and
// hard to notice afterwards, so this fails the release LOUDLY rather than letting it
// through. Comment out the exclude in project.toml to ship.

let toml = HEMTT_RFS.join(".hemtt").join("project.toml");

if !toml.is_file() {
    // Nothing to check against - do not block the release on a missing file.
    return;
}

let contents = toml.open_file().read();

// Look for the exclude on a line that is not commented out. Rhai's string API here is
// minimal - index_of/sub_string only - so the comment test is "does a '#' appear before
// the first 'sqfc' on this line".
let offending = false;
for line in contents.split("\n") {
    let at = line.index_of("sqfc");
    if at < 0 {
        continue;
    }
    let hash = line.index_of("#");
    if hash < 0 || hash > at {
        offending = true;
    }
}

if offending {
    fatal("RELEASE BLOCKED: the dev-only `**/*.sqfc` exclude is still active in .hemtt/project.toml.\n" +
          "  It exists so -filePatching works during development, but [files] exclude is global,\n" +
          "  so releasing with it would ship PBOs without precompiled SQF bytecode.\n" +
          "  Comment out that exclude entry in project.toml, then re-run the release.");
}

print("release guard: .sqfc exclude is not active, bytecode will be packed normally");
