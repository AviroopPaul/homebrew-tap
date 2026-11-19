# bleep: a little buddy for your Mac. Source: AviroopPaul/bleep (MIT); downloads: AviroopPaul/bleep-releases.
cask "bleep" do
  version "0.5.1"
  sha256 "73108c397f6c2a694cd221637ede182be6ab1ae16a5d73404c0e774e6ca388ab"

  url "https://github.com/AviroopPaul/bleep/releases/download/v#{version}/bleep-mac.dmg"
  name "bleep"
  desc "Little buddy that watches your coding agents, mail and calendar"
  homepage "https://bleep-omega.vercel.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # From 0.3.1, bleep updates itself (Settings > Updates).
  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "bleep.app"

  # bleep is signed with its own certificate, not an Apple Developer ID, so Gatekeeper would block
  # the quarantined copy (and macOS 15 has no right-click Open). Homebrew has already checked this
  # exact download against the sha256 above, so clear the quarantine flag and let it open normally.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/bleep.app"]
  end

  uninstall launchctl: "bleep",
            quit:      "site.avirooppaul.bleep"

  zap trash: [
    "~/.bleep",
    "~/Library/Caches/site.avirooppaul.bleep",
    "~/Library/LaunchAgents/bleep.plist",
    "~/Library/WebKit/bleep",
    "~/Library/WebKit/site.avirooppaul.bleep",
  ]

  caveats <<~EOS
    Press Cmd+Space and type bleep to open it. A short setup connects
    Claude Code, Google and your coding agents.

    Before you uninstall: if you installed the Claude Code hooks or Codex
    turn notices, remove them first in bleep Settings > Agents.
  EOS
end
