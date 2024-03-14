#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    APT_COMMAND="sudo apt-get"
else
    APT_COMMAND="apt-get"
fi

$APT_COMMAND update -q

# Common build dependencies.
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
    libwayland-dev \
    lintian


# Common Qt build headers.
$APT_COMMAND install -qy --no-install-recommends \
    libqt5svg5-dev \
    libqt5x11extras5-dev \
    qtbase5-dev \
    qtdeclarative5-dev \
    qtquickcontrols2-5-dev \
    qtquickcontrols2-5-dev \
    qtwayland5 \
    qtwayland5-dev-tools \
    qtwayland5-private-dev


# Build dependencies for MauiMan.
$APT_COMMAND install -qy --no-install-recommends \
    qtsystems5-dev


# Build dependencies for MauiKit.
$APT_COMMAND install -qy --no-install-recommends \
    libkf5i18n-dev \
    libkf5kio-dev \
    libkf5notifications-dev \
    libkf5solid-dev \
    libkf5syntaxhighlighting-dev \
    libxcb-icccm4-dev \
    libxcb-shape0-dev \
    nlohmann-json3-dev \
    qml-module-qtgraphicaleffects \
    qml-module-qtquick-controls2 \
    qml-module-qtquick-shapes


# Build dependencies for MauiKit Calendar.
$APT_COMMAND install -qy --no-install-recommends \
    libkf5akonadi-dev \
    libkf5akonadicontact-dev \
    libkf5akonadimime-dev \
    libkf5calendarsupport-dev \
    libkf5config-dev \
    libkf5coreaddons-dev \
    libkf5eventviews-dev \
    libkf5i18n-dev \
    libkf5kio-dev \


# Build dependencies for Agenda.
$APT_COMMAND install -qy --no-install-recommends \
    libkf5akonadi-dev \
    libkf5akonadicontact-dev \
    libkf5calendarsupport-dev \
    libkf5config-dev \
    libkf5coreaddons-dev \
    libkf5eventviews-dev \
    libkf5i18n-dev \
    libkf5kio-dev 