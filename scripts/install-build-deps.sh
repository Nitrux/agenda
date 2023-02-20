#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    APT_COMMAND="sudo apt-get"
else
    APT_COMMAND="apt-get"
fi

$APT_COMMAND update -q
$APT_COMMAND install -qy --no-install-recommends \
    appstream \
    automake \
    autotools-dev \
    build-essential \
    checkinstall \
    cmake \
    curl \
    devscripts \
    equivs \
    extra-cmake-modules \
    gettext \
    git \
    gnupg2 \
    libgit2-dev \
    libkf5akonadi-dev \
    libkf5akonadicontact-dev \
    libkf5calendarsupport-dev \
    libkf5config-dev \
    libkf5coreaddons-dev \
    libkf5eventviews-dev \
    libkf5i18n-dev \
    libkf5kio-dev \
    libqt5svg5-dev \
    libwayland-dev \
    lintian \
    qtbase5-dev \
    qtdeclarative5-dev \
    qtquickcontrols2-5-dev \
    qtwayland5 \
    qtwayland5-dev-tools \
    qtwayland5-private-dev