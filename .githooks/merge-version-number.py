#!/usr/bin/env python3
"""
HEMTT version merge driver.

Git passes three temp file paths:
  %O  - base (common ancestor)
  %A  - ours  (modified in-place to produce the merged result)
  %B  - theirs

Rules per field:
  minor  ->  additive: ours + (theirs - base); if changed from base, reset patch=0 and build=0
  patch  ->  additive: ours + (theirs - base); if changed from base, reset build=0
  build  ->  additive: ours + (theirs - base), unless minor or patch changed
"""
import sys
import re


def read_field(content, field):
    m = re.search(rf"^{field} = (\d+)$", content, re.MULTILINE)
    return int(m.group(1)) if m else None


def set_field(content, field, value):
    return re.sub(rf"^{field} = \d+$", f"{field} = {value}", content, flags=re.MULTILINE)


base_path, ours_path, theirs_path = sys.argv[1], sys.argv[2], sys.argv[3]

base_content  = open(base_path).read()
ours_content  = open(ours_path).read()
theirs_content = open(theirs_path).read()

# Read all fields from all three versions
fields = {}
for name in ("major", "minor", "patch", "build"):
    fields[name] = {
        "base":   read_field(base_content,   name),
        "ours":   read_field(ours_content,   name),
        "theirs": read_field(theirs_content, name),
    }

# Fall back to a normal git conflict if any field is unreadable
if any(None in v.values() for v in fields.values()):
    sys.exit(1)

b = fields["minor"]["base"];   o = fields["minor"]["ours"];  t = fields["minor"]["theirs"]
merged_minor = o + (t - b)
minor_changed = merged_minor > b

b = fields["patch"]["base"];   o = fields["patch"]["ours"];  t = fields["patch"]["theirs"]
merged_patch = o + (t - b)
patch_changed = merged_patch > b

b = fields["build"]["base"];   o = fields["build"]["ours"];  t = fields["build"]["theirs"]
if minor_changed:
    # minor bump — reset patch and build
    merged_patch = 0
    merged_build = 0
elif patch_changed:
    # patch bump — reset build only
    merged_build = 0
else:
    merged_build = o + (t - b)

result = ours_content
result = set_field(result, "minor", merged_minor)
result = set_field(result, "patch", merged_patch)
result = set_field(result, "build", merged_build)

open(ours_path, "w").write(result)

print(
    f"version-merge: "
    f"minor={fields['minor']['ours']}+{fields['minor']['theirs']}-{fields['minor']['base']}->{merged_minor}  "
    f"patch={fields['patch']['ours']}+{fields['patch']['theirs']}-{fields['patch']['base']}->{merged_patch}  "
    f"build={fields['build']['ours']}+{fields['build']['theirs']}-{fields['build']['base']}->{merged_build}"
)
