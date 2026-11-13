#!/usr/bin/env bash

VERSION_CODE="10"
VERSION_NAME="0.0.10"

set -euo pipefail

edit_in_place() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        sed -E -i '' "$@"
    else
        sed -E -i "$@"
    fi
}

rm -rf .git/modules/src/rebase-apply
cd src
git am --whitespace=nowarn --keep-non-patch ../patches/*.patch

cp -R ../res/. app/src/main/res/
edit_in_place 's|applicationId = "[^"]*"|applicationId = "io.github.jqssun.btremote"|' app/build.gradle.kts
edit_in_place "s|versionCode = [0-9]+|versionCode = $VERSION_CODE|" app/build.gradle.kts
edit_in_place 's|versionName = "[^"]*"|versionName = "'"$VERSION_NAME"'"|' app/build.gradle.kts
edit_in_place 's|Android TV|macOS/iOS/iPadOS/tvOS/Windows/Linux|' app/src/main/res/values*/strings.xml
edit_in_place 's|<string name="app_name">[^<]*</string>|<string name="app_name">Bluetooth Remote</string>|' app/src/main/res/values*/strings.xml
edit_in_place 's|const val SOURCE_CODE_LINK = "[^"]*"|const val SOURCE_CODE_LINK = "https://github.com/jqssun/android-bt-remote"|' app/src/main/java/com/atharok/btremote/common/utils/Constants.kt
edit_in_place 's|const val WEB_SITE_LINK = "[^"]*"|const val WEB_SITE_LINK = "https://github.com/jqssun/android-bt-remote"|' app/src/main/java/com/atharok/btremote/common/utils/Constants.kt

# git reset --hard origin/HEAD && git clean -fdx
