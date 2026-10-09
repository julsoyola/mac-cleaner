#!/bin/zsh
setopt NULL_GLOB

echo "=== Starting macOS Cleanup ==="
echo "Initial Disk Usage:"
df -h /

echo "\n[1/7] Emptying Trash & Messages Attachments..."
rm -rf ~/.Trash/* 2>/dev/null
find ~/Library/Messages/Attachments -mindepth 1 -delete 2>/dev/null

echo "[2/7] Cleaning Homebrew & Developer Caches..."
if command -v brew &>/dev/null; then
  brew cleanup --prune=all 2>/dev/null
fi
rm -rf ~/Library/Caches/Homebrew/* 2>/dev/null
rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null
rm -rf ~/Library/Developer/CoreSimulator/Caches/* 2>/dev/null

echo "[3/7] Clearing VS Code & Chrome Caches..."
rm -rf ~/Library/Application\ Support/Code/User/workspaceStorage/* 2>/dev/null
rm -rf ~/Library/Application\ Support/Code/CachedData/* 2>/dev/null
rm -rf ~/Library/Caches/Google/Chrome/* 2>/dev/null

echo "[4/7] Removing Stale Downloads..."
rm -rf ~/Downloads/app 2>/dev/null

echo "[5/7] Optional Gaming Cache Removal..."
read -q "REPLY?Delete Minecraft and CurseForge mod assets? (y/N): "
echo ""
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  rm -rf ~/Library/Application\ Support/minecraft 2>/dev/null
  rm -rf ~/Library/Application\ Support/CurseForge 2>/dev/null
  echo "Gaming assets removed."
fi

echo "[6/7] Thinning APFS Local Snapshots (Sudo required)..."
sudo tmutil thinlocalsnapshots / 999999999999 4

echo "\n[7/7] Cleanup Complete!"
echo "Final Disk Usage:"
df -h /
