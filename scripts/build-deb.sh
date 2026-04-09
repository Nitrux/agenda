#!/usr/bin/env bash

# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2025-2026 <Nitrux Latinoamericana S.C. <hello@nxos.org>>


# -- Exit on errors.

set -e


# -- Download Source

git clone --depth 1 --branch "$AGENDA_BRANCH" https://github.com/Nitrux/maui-agenda.git


# -- Compile Source

mkdir -p build && cd build

HOST_MULTIARCH=$(dpkg-architecture -qDEB_HOST_MULTIARCH)

cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_BSYMBOLICFUNCTIONS=OFF \
	-DQUICK_COMPILER=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_SYSCONFDIR=/etc \
	-DCMAKE_INSTALL_LOCALSTATEDIR=/var \
	-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" \
	-DCMAKE_VERBOSE_MAKEFILE=ON \
	-DCMAKE_INSTALL_LIBDIR="/usr/lib/${HOST_MULTIARCH}" \
	../maui-agenda/

make -j"$(nproc)"

make install


# -- Run checkinstall and Build Debian Package

>> description-pak printf "%s\n" \
	'MauiKit Image gallery manager.' \
	'' \
	'Agenda is a calendar application made for Android and Plasma Mobile.' \
	'' \
	'Agenda works under Android and GNU/Linux distros.' \
	'' \
	''

checkinstall -D -y \
    --install=no \
    --fstrans=yes \
    --pkgname=agenda \
    --pkgversion="$PACKAGE_VERSION" \
    --pkgarch="$(dpkg --print-architecture)" \
    --pkgrelease="1" \
    --pkglicense=LGPL-3 \
    --pkggroup=utils \
    --pkgsource=agenda \
    --pakdir=. \
    --maintainer=uri_herrera@nxos.org \
    --provides=agenda \
    --requires="mauikit \(\>= 4.0.2\),mauikit-calendar (\>= 4.0.2\),qml6-module-qtcore,qml6-module-qtquick-effects" \
    --nodoc \
    --strip=no \
    --stripso=yes \
    --reset-uids=yes \
    --deldesc=yes
