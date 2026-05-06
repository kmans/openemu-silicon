## What's New in 1.1.0

This is a meaningful step up from the 1.0.x line — a working RetroArch bridge, RetroAchievements on more systems, and a fix for the silent core-update problem that's been frustrating people for weeks.

---

### Cores not updating? Try 1.1.0 first.

If you've been seeing "Update Available" on a core and the install seems to do nothing, or you've noticed your cores feel stuck on old versions even though new ones have shipped — this release fixes that. The update pipeline was fetching stale upstream feeds (some pointing at x86_64-only binaries) instead of this fork's own. After installing 1.1.0, your existing core installations are migrated automatically on first launch and the right updates start flowing in.

If you've held off on bug reports because "nothing seems to land anyway," **please update and see if your specific issue is already fixed.** A lot of the work below has been waiting in shipped cores you haven't been getting.

---

### Libretro Bridge — bring your own RetroArch cores ⚡ *(Experimental — testers wanted)*

OpenEmu Silicon now ships a **Libretro Bridge** built by Nick Blackmon and [pystIC](https://github.com/pystIC) — a translation layer that lets you run RetroArch / libretro cores directly inside OpenEmu, without per-core ports.

**Working in my testing in 1.1.0:**

- **PSP** via PPSSPP-libretro
- **Atari 2600** via libretro cores
- **Commodore 64** via VICE-libretro

**Not yet working — known limits, more work needed before these are recommended:**

- **Dreamcast via Flycast-libretro.** The libretro path for Flycast isn't usable today. *Use the built-in native Flycast core for Dreamcast — it's working smoothly in 1.1.0 (see below).*
- **Hardware-rendered cores in general** (anything requiring OpenGL or Vulkan). Software-rendered cores are the sweet spot today.
- Other libretro cores beyond the working list above haven't been validated. They may work, may not — testing welcome.

How it works: download cores through RetroArch (or grab them from the libretro buildbot), and OpenEmu's bridge loads those `.dylib` files and translates between the libretro API and OpenEmu's native interface — input, video, audio, save states, and core options handled automatically. The per-system stubs that route games to the bridge auto-refresh on launch when the bundled bridge updates, so you don't need to reinstall anything.

**This is experimental.** Beyond the per-core unknowns above, two general gotchas:

- **Some input mapping configurations on libretro cores can trigger crashes** (see Known Issues below).
- Cores that override their declared default options used to lose those defaults until you opened settings — fixed in 1.1.0, but worth a sanity check on any core with unusual defaults.

**I'd genuinely value testing help.** If you've got hardware to throw at a system above (or a different libretro core entirely), please try it and open issues with what works and what doesn't — especially crashes with full reproduction steps.

→ **[Setup guide and supported cores list](https://github.com/nickybmon/OpenEmu-Silicon/wiki/Using-RetroArch-Cores)**

---

### RetroAchievements — Phase 2 🏆 *(Testing help welcome)*

Two more system families now earn RetroAchievements automatically while you play:

**Nintendo 64 (Mupen64Plus)** — N64 achievements are live. Log in once in Preferences → Achievements and your existing token carries over.

**PlayStation, PC Engine, Lynx, Neo Geo Pocket (Mednafen)** — PSX (including multi-disc games), PC Engine / TurboGrafx-16, Atari Lynx, and Neo Geo Pocket Color are all supported.

The full list of RA-supported systems is now: GBA, GB / GBC, SNES, NES, Genesis / Mega Drive / CD / SG-1000, Master System / Game Gear, N64, PSX, PC Engine, Lynx, and NGP.

**These are working in my testing**, but RA is sensitive to per-game memory layouts and edge cases. If you play a lot of one of these systems and have time to verify achievements actually trigger on a game you know — please do, and file an issue if anything looks wrong (achievements not triggering, triggering at the wrong moment, etc.). Reproductions with game name + region + emulator core help a lot.

---

### Other improvements

**Native Flycast core no longer needs a second launch.** Dreamcast games on the built-in Flycast core (the one that ships with OpenEmu — distinct from the experimental Flycast-libretro path) now boot correctly the first time. Combined with the JIT re-enable, Dreamcast on the native core feels right again.

**Cheats persist across sessions** — User-added cheat codes are now saved to disk and re-applied automatically when a game loads. They were silently discarded between sessions before.

**ScreenScraper recognises 16 more systems** — Covers, screenshots, and metadata now fetch correctly for systems whose IDs were missing from the mapping table.

**Window resizing no longer leaves ghost content layers** — Maximising or resizing the main window could leave semi-transparent artifacts from the previous layout. The content view is now correctly redrawn on resize.

**Google Drive cloud saves** — *(Built but not yet active for users.)* The implementation that stores saves in a visible top-level "OpenEmu Saves" folder in your Drive is complete in this release, but Google Drive sign-in is currently waiting on Google's app verification process before it becomes available to general users. Once verification completes, it'll go live without needing a new OpenEmu update.

---

## Bug Fixes

- **Multi-core systems no longer silently default to RetroArch.** On SNES, Arcade, and Commodore 64, OpenEmu was quietly picking the RetroArch (bridge) core even when a native core was installed and selected. The native core is now used as expected when chosen.
- **No more phantom "Update Available" loops.** A previous core release advertised new versions in the update feed but shipped the previous binaries — installs would "succeed" without anything changing, and the app kept offering the same update on every launch. The feed now matches what's actually in each release, and existing installations migrate to the corrected feed on first launch of 1.1.0.
- **Libretro cores now honour their author-declared default options.** Cores with sensible defaults (PPSSPP and others) had those defaults overridden with empty values until the user explicitly touched each setting. Defaults take effect immediately.
- **RetroArch core stubs stay in sync with the bundled bridge.** When the bridge is updated, the per-system stubs auto-refresh on launch — no reinstall needed.
- **ROM files can now be re-imported after deletion.** Deleting a game from your library and trying to add the same ROM again was silently skipped because the stale database entry was still present. The entry is cleaned up on delete so re-import works.
- **Game Scanner now has a Cancel button.** The "Resolve Issues" sheet that appears when imports need attention previously had no way to dismiss it without resolving every item.
- **Window resizing no longer leaves ghost content layers.** Maximising or resizing the main window could leave semi-transparent artifacts.
- **Dreamcast games no longer play at half speed (27fps).** The Flycast JIT compiler was disabled, halving performance. JIT is re-enabled and the dynamic frame timeout is restored.
- **Dreamcast games no longer show a black screen on second launch.** A Flycast option override applied during `loadGame` was being reset before it took effect. The override now sticks.
- **PSX multi-disc games no longer require a manual `.m3u` file.** Mednafen now auto-generates the playlist for multi-disc sets so they load without any setup.
- **Input Monitoring permission is now correctly detected at launch.** If Input Monitoring was already granted before launch, OpenEmu would show the permission prompt again and controllers would not respond. Fixed.
- **Keychain reads no longer block the main thread.** Loading the RetroAchievements token at launch could cause a brief freeze, especially on first run. Tokens are now cached in memory after the first read.
- **Cheats are saved and re-applied on game start.** User-added cheat codes were lost between sessions. Enabled cheats are now persisted to disk and automatically re-applied when the game loads.
- **Preferences no longer shows duplicate ColecoVision rows.** The Cores tab was resolving system names incorrectly, producing ghost rows for ColecoVision and a few other systems.
- **FCEU games render correctly when running from a Release build.** Pixels were not being written to the framebuffer on the execute path used by Release and notarised builds, causing a black screen.
- **RetroArch cores are visible in the core picker and stay visible after selection.** On SNES, Arcade, and C64, selecting a RetroArch (bridge) core caused it to vanish from the picker, making it impossible to reselect.
- **"Check for Update" in the core picker now works.** Tapping it previously produced no visible effect. It now fetches the correct appcast for each installed core and shows an update badge when one is available.
- **Snes9x (RetroArch) no longer crashes on load.** A null pointer was being passed to the core options interface; it now receives an empty string, which the core handles correctly.
- **Libretro cores no longer crash from unrecognised selector messages.** Hardened the bridge against input subsystems sending selectors the bridge didn't yet implement.

---

## Known Issues

- **Some input mapping configurations can crash libretro / RetroArch cores.** The bridge has been hardened in 1.1.0 against the most common cases, but specific mapping setups can still bring a core down. If you hit this, falling back to default mappings should keep you stable while a fix lands. Tracking — please file an issue with the core, the system, and the exact mapping that triggers it.
- **Hardware-rendered libretro cores (OpenGL / Vulkan) are not supported yet.** Software-rendered cores are where the bridge is solid today.

---

## Core Updates

These core updates ship automatically via the in-app updater (Preferences → Cores). You do not need to reinstall OpenEmu to receive them.

- **Mednafen 1.26.3** — RetroAchievements support added for PlayStation, PC Engine / TurboGrafx-16, Atari Lynx, and Neo Geo Pocket Color. Multi-disc PSX games no longer require a manually created `.m3u`. PSX save RAM (memory card scratchpad) and PC Engine CD console detection are also fixed.

- **Mupen64Plus 2.5.12** — RetroAchievements support added for Nintendo 64. Memory address reads used by the achievement system are corrected, and address validation is deferred until emulated RAM is live so games don't stall on load.

- **Flycast 2.4.1** — Fixes a regression that caused Dreamcast games to run at roughly half speed (27fps). JIT was inadvertently disabled in the previous release; it is re-enabled here alongside the correct dynamic frame timeout. Also fixes a black screen that could appear when loading a Dreamcast game for the second time in a session.

- **FCEU 2.6.8** — Fixes a black screen that affected NES games when running from a notarised or Release build. Pixels were not being written to the framebuffer on the code path used by distribution builds, making every NES game appear blank. Did not affect Debug builds, which is why it was not caught sooner.
