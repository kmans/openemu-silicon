cask "openemu-silicon" do
  version "1.1.1"
  sha256 "54acaae04ebfe51a30ac0d7eb1d436a85730e3cb1c446f1ed8b33e282c80a139"

  url "https://github.com/nickybmon/OpenEmu-Silicon/releases/download/v#{version}/OpenEmu-Silicon.dmg"
  name "OpenEmu Silicon"
  desc "Native Apple Silicon port of the OpenEmu multi-system emulator"
  homepage "https://github.com/nickybmon/OpenEmu-Silicon"

  livecheck do
    url "https://raw.githubusercontent.com/nickybmon/OpenEmu-Silicon/main/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "OpenEmu.app"

  zap trash: [
    "~/Library/Application Support/OpenEmu",
    "~/Library/Application Support/org.openemu.OEXPCCAgent.Agents",
    "~/Library/Caches/org.openemu.OpenEmu",
    "~/Library/HTTPStorages/org.openemu.OpenEmu",
    "~/Library/HTTPStorages/org.openemu.OpenEmu.binarycookies",
    "~/Library/Preferences/org.openemu.OpenEmu.plist",
    "~/Library/Saved Application State/org.openemu.OpenEmu.savedState",
  ]
end
