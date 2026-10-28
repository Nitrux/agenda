#!/usr/bin/env bash

# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2024-2025 <Nitrux Latinoamericana S.C. <hello@nxos.org>>


# -- Exit on errors.

set -euo pipefail


# -- Check if running as root.

if [ "$EUID" -ne 0 ]; then
    APT_COMMAND="sudo apt"
else
    APT_COMMAND="apt"
fi


# -- Install build packages.

$APT_COMMAND update -q
$APT_COMMAND install -y --no-install-recommends \
    appstream \
    automake \
    autotools-dev \
    build-essential \
    qt6-wayland-dev \
    qt6-svg-dev \
    qt6-multimedia-dev \
    libxkbcommon-dev \
    libxcb-shape0-dev \
    libxcb-icccm4-dev \
    libkf6windowsystem-dev \
    cmake \
    extra-cmake-modules \
    pkg-config \
    curl \
    devscripts \
    equivs \
    gettext \
    git \
    gnupg2 \
    libkf6config-dev \
    libkf6calendarcore-dev \
    libsecret-1-dev \
    libkf6coreaddons-dev \
    libkf6i18n-dev \
    libkf6kio-dev \
    libkf6notifications-dev \
    libkf6syntaxhighlighting-dev \
    lintian \
    qml6-module-qt5compat-graphicaleffects \
    qml6-module-qtquick-controls \
    qml6-module-qtquick-shapes \
    qt6-base-dev \
    qt6-5compat-dev \
    qt6-base-dev-tools \
    qt6-declarative-dev


# -- Add package from our repository.

mkdir -p /etc/apt/keyrings

curl -fsSL https://packagecloud.io/nitrux/mauikit/gpgkey | gpg --dearmor -o /etc/apt/keyrings/nitrux-mauikit.gpg

cat <<EOF > /etc/apt/sources.list.d/nitrux-mauikit.sources
Types: deb
Description: Nitrux MauiKit Repo
URIs: https://packagecloud.io/nitrux/mauikit/debian/
Suites: duke
Components: main
Signed-By: /etc/apt/keyrings/nitrux-mauikit.gpg
Enabled: yes
EOF

$APT_COMMAND update -q
$APT_COMMAND install -y --no-install-recommends \
    mauikit-accounts \
    mauikit-calendar \
    mauikit-filebrowsing
