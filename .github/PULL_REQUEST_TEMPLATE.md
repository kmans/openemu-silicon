## What does this PR do?

<!-- One or two sentences describing the change. What problem does it solve, or what does it add? -->

## What did you test?

<!-- How did you verify this works? Which game(s), system(s), or workflow(s) did you test with? -->

## Which cores or systems are affected?

<!-- List the emulation cores or systems this change touches, if any. If it's a general app change, say so. -->

## Did you use AI tools?

<!-- We're fully open to AI-assisted contributions — just be transparent about it. Did you use Claude, Copilot, Cursor, or anything else? If so, briefly describe how. (e.g. "Used Claude to draft the fix, reviewed and tested it myself.") -->

## Linked issues

<!-- Use "Fixes #N" to auto-close an issue on merge, or "Related to #N" to soft-link -->

Fixes #

---

## How to test locally

**1. Navigate to your local clone and check out this PR**

```bash
cd ~/Documents/Cursor/Open\ Emu
gh pr checkout <PR_NUMBER> --repo nickybmon/OpenEmu-Silicon
```

**2. Build** — replace `-scheme OpenEmu` with the scheme that covers your change (e.g. `"OpenEmu + Flycast"` for Flycast; add `clean` before `build` for C++ cores)

```bash
xcodebuild \
  -workspace OpenEmu-metal.xcworkspace \
  -scheme OpenEmu \
  -configuration Debug \
  -destination 'platform=macOS,arch=arm64' \
  build 2>&1 | tail -20
```

**3. Launch** (and optionally install a rebuilt core plugin first)

```bash
BUILD_PRODUCTS=$(xcodebuild \
  -workspace OpenEmu-metal.xcworkspace \
  -scheme OpenEmu \
  -configuration Debug \
  -showBuildSettings 2>/dev/null \
  | awk '/^\s+BUILT_PRODUCTS_DIR/{print $3; exit}')

open "$BUILD_PRODUCTS/OpenEmu.app"
```

If this PR touches a core, install it before launching:

```bash
cp -R "$BUILD_PRODUCTS/<CoreName>.oecoreplugin" \
  ~/Library/Application\ Support/OpenEmu/Cores/<CoreName>.oecoreplugin
codesign --force --sign - \
  ~/Library/Application\ Support/OpenEmu/Cores/<CoreName>.oecoreplugin
```

<!-- Replace <PR_NUMBER> and add any PR-specific setup here (BIOS files, permissions to revoke, specific ROM to test with). -->

---

## PR checklist

- [ ] Branched from an up-to-date `main` (ran `git fetch origin && git merge origin/main`)
- [ ] Build passes: `xcodebuild -workspace OpenEmu-metal.xcworkspace -scheme OpenEmu -configuration Debug -destination 'platform=macOS,arch=arm64' build`
- [ ] Tested on Apple Silicon (M1 / M2 / M3 / M4 Mac)
- [ ] No build logs, binaries, or credentials committed
- [ ] Copyright headers preserved on all modified files
- [ ] New files (if any) include the BSD 2-Clause license header
