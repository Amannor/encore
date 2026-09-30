#!/bin/sh
# Archive Encore, zip it, and write a SHA-256 plus a short bill of materials.
# Usage: scripts/release.sh [version]
# version defaults to CFBundleShortVersionString. Pass 0.1.0 or v0.1.0.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
plist="$root/Spectacle/Supporting Files/Info.plist"
version=${1:-$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$plist")}
version=${version#v}
bundled=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$plist")
if [ "$version" != "$bundled" ]; then
  echo "version $version does not match Info.plist $bundled" >&2
  exit 1
fi

archive="$root/build/Encore.xcarchive"
out="$root/dist"
rm -rf "$archive"
mkdir -p "$out"

xcodebuild \
  -scheme Spectacle \
  -configuration Release \
  -destination 'platform=macOS' \
  -archivePath "$archive" \
  -derivedDataPath "$root/build/DerivedData" \
  archive \
  ONLY_ACTIVE_ARCH=NO \
  CODE_SIGN_IDENTITY=-

app="$archive/Products/Applications/Encore.app"
zip="$out/Encore-$version.zip"
rm -f "$zip" "$out/Encore-$version.sha256" "$out/Encore-$version.sbom.txt"
ditto -c -k --keepParent "$app" "$zip"
shasum -a 256 "$zip" > "$out/Encore-$version.sha256"

sbom="$out/Encore-$version.sbom.txt"
{
  echo "name: Encore"
  echo "version: $version"
  echo "bundle-id: $(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app/Contents/Info.plist")"
  echo "git: $(git -C "$root" rev-parse HEAD)"
  echo "sparkle: not linked"
  echo "spm: none (no Package.resolved)"
  echo "frameworks:"
  find "$app/Contents" -name '*.framework' -o -name '*.dylib' | sed "s|^$app/||" || true
  echo "linked:"
  otool -L "$app/Contents/MacOS/Encore"
  echo "archs: $(lipo -archs "$app/Contents/MacOS/Encore")"
  echo "signature:"
  codesign -dv --verbose=2 "$app" 2>&1
  if strings "$app/Contents/MacOS/Encore" | grep -q 'spectacleapp.com'; then
    echo "spectacleapp.com: PRESENT"
    exit 1
  fi
  echo "spectacleapp.com: absent"
} > "$sbom"

echo "wrote $zip"
cat "$out/Encore-$version.sha256"
