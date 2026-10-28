#!/usr/bin/env bash

# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2024-2025 <Nitrux Latinoamericana S.C. <hello@nxos.org>>


# -- Exit on errors.

set -euo pipefail

# -- Prepare source.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"
export PATH="/usr/lib/qt6/bin:$PATH"
PACKAGE_VERSION="${PACKAGE_VERSION:?PACKAGE_VERSION must be supplied by CI}"
TARGET_ARCH="${TARGET_ARCH:-$(dpkg --print-architecture)}"

# -- Download Source

git clone --depth 1 --branch "${AGENDA_BRANCH}" https://github.com/Nitrux/maui-agenda.git "$repo_root/maui-agenda"
source_dir="$repo_root/maui-agenda"

# -- Configure build.

# MauiKit software must be built with CMake and ECM; never use Meson.
build_dir="$repo_root/build"
cmake_dir="$build_dir/cmake"
stage_dir="$build_dir/package"
rm -rf "$cmake_dir" "$stage_dir"
mkdir -p "$build_dir"

cmake_args=(
    -DCMAKE_INSTALL_PREFIX=/usr
    -DCMAKE_BUILD_TYPE=Release
)
if [ "$(dpkg-architecture -qDEB_HOST_ARCH)" = "amd64" ]; then
    cmake_args+=("-DCMAKE_CXX_FLAGS=-march=x86-64-v3")
fi

# -- Compile Source

cmake -S "$source_dir" -B "$cmake_dir" "${cmake_args[@]}"
cmake --build "$cmake_dir" --parallel "$(nproc)"

# -- Install source to DESTDIR.

DESTDIR="$stage_dir" cmake --install "$cmake_dir"

# -- Create DEBIAN control file.

mkdir -p "$stage_dir/DEBIAN"
cat > "$stage_dir/DEBIAN/control" <<CONTROL
Package: agenda
Version: ${PACKAGE_VERSION}
Section: utils
Priority: optional
Architecture: ${TARGET_ARCH}
Maintainer: uri_herrera@nxos.org
Provides: agenda
Depends: libc6,libkf6calendarcore6,libkf6configcore6,libkf6coreaddons6,libkf6i18n6,libkf6kiocore6,libqt6core6t64,libqt6dbus6,libqt6gui6,libqt6network6,libqt6qml6,libqt6quick6,libqt6quickcontrols2-6,libqt6sql6,libqt6svg6,libqt6widgets6,libsecret-1-0,mauikit (>= 4.0.5),mauikit-accounts (>= 4.0.5),mauikit-calendar (>= 4.0.5),mauikit-filebrowsing (>= 4.0.5),qml6-module-org-kde-calendarcore,qml6-module-org-kde-kirigami,qml6-module-qtcore,qml6-module-qtquick,qml6-module-qtquick-controls,qml6-module-qtquick-effects,qml6-module-qtquick-layouts,qml6-module-qtquick-shapes
Description: agenda
 agenda
CONTROL

# -- Create .deb.

dpkg-deb --build --root-owner-group "$stage_dir" "$build_dir/agenda_${PACKAGE_VERSION}_${TARGET_ARCH}.deb"
