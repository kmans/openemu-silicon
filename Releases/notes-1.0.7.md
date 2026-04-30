## What's New in 1.0.7

### RetroAchievements — Phase 1 🏆

OpenEmu Silicon now supports [RetroAchievements](https://retroachievements.org) for 9 cores across 7 systems. Log in once in **Preferences → Achievements** with your RetroAchievements account and earn achievements automatically as you play.

**Supported systems in this release:**

| System | Core(s) |
|--------|---------|
| Game Boy Advance | mGBA |
| Game Boy / Game Boy Color | mGBA, Gambatte |
| Super Nintendo | SNES9x, BSNES |
| NES / Famicom | FCEU, Nestopia |
| Genesis / Mega Drive | GenesisPlus |
| Master System / Game Gear | GenesisPlus |
| Sega CD / SG-1000 | GenesisPlus |

Your login token is stored securely in your Keychain and propagated automatically to each supported core when a game loads — no per-game setup needed. When you unlock an achievement, an in-game banner appears at the bottom of the screen with the achievement name and point value.

For setup instructions, supported game lists, and troubleshooting, see the [RetroAchievements wiki page](https://github.com/nickybmon/OpenEmu-Silicon/wiki/RetroAchievements).

More cores are on the way — see the [Phase 2 & 3 rollout tracker](https://github.com/nickybmon/OpenEmu-Silicon/issues/258) for what's coming next.

---

### Play With… — per-launch core selection

Right-click any game in your library and choose **Play With…** to pick which core launches it, without changing your default. The submenu only appears when more than one core is installed for that system.

This pairs especially well with RetroAchievements: if a system has both an RA-supported core (like GenesisPlus for Genesis) and a non-RA core (like picodrive), you can choose which one to use for each session.

---

## Bug Fixes

- **3DO / 4DO now appears in the console list.** A bundle identifier bug caused the 4DO plugin to be silently dropped at launch — 3DO games were completely inaccessible. This is fixed, and auto-updates for the 4DO core will now work correctly.
- **SNES rewind no longer produces a blank screen.** The rewind path was rendering the current frame before restoring the saved state, so rewinding looked like a freeze. Frame order is now correct.
- **PSX games no longer show a black bar on the right side of the screen.** Mednafen's active display area was left-aligned inside a wider fixed framebuffer, leaving unrendered pixels visible. The active area is now centered.
- **N64 GameShark cheat codes now work.** Codes were parsed correctly but never applied to the emulator. Always-on code variants are also handled, so codes that required a physical GameShark button now activate automatically.
- **Dreamcast games no longer run faster than real-time.** The Flycast SH4 thread was unconstrained — it had no back-pressure from the audio system. Audio now acts as the natural throttle, restoring correct game speed and fixing the severely distorted audio that came with it.
- **NES games on the FCEU core now render with correct colors.** A regression in FCEU 2.6.6 caused all palette entries used by the PPU to be filled with grey, making every NES game look washed out. The correct palette entries are now populated.
- **ScreenScraper fetch errors are now visible.** When ScreenScraper is unreachable, returns a rate-limit error, or rejects credentials, Preferences → Cover Art now shows the error instead of silently doing nothing.
