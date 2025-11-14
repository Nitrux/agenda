#!/usr/bin/env bash

set -x

### Update sources

wget -qO /etc/apt/sources.list.d/nitrux-depot.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux.depot
wget -qO /etc/apt/sources.list.d/nitrux-testing.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux.testing
wget -qO /etc/apt/sources.list.d/nitrux-unison.list https://raw.githubusercontent.com/Nitrux/iso-tool/legacy/configs/files/sources/sources.list.nitrux.unison

curl -L https://packagecloud.io/nitrux/depot/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/testing/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/unison/gpgkey | apt-key add -;

apt -qq update

### Install Package Build Dependencies #2

apt -qq -yy install --no-install-recommends \
	mauikit-calendar-git \
	mauikit-git

### Download Source

git clone --depth 1 --branch $AGENDA_BRANCH https://invent.kde.org/maui/agenda.git

### Compile Source

mkdir -p build && cd build

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
	-DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu ../agenda/

make -j$(nproc)

make install

### Run checkinstall and Build Debian Package

>> description-pak printf "%s\n" \
	'Calendar application built with MauiKit.' \
	'' \
	'Agenda works on desktops, Android and Plasma Mobile.' \
	''

checkinstall -D -y \
	--install=no \
	--fstrans=yes \
	--pkgname=agenda-git \
	--pkgversion=$PACKAGE_VERSION \
	--pkgarch=amd64 \
	--pkgrelease="1" \
	--pkglicense=LGPL-3 \
	--pkggroup=utils \
	--pkgsource=agenda \
	--pakdir=. \
	--maintainer=uri_herrera@nxos.org \
	--provides=agenda \
	--requires="akonadi-server,libc6,libkpim5akonadicore5,libkpim5akonadicontact5,libkpim5akonadicalendar5,libkf5coreaddons5,libkpim5eventviews5,libkf5i18n5,libkf5kiocore5,libmariadb3,libqt5core5a,libqt5gui5,libqt5qml5,libqt5sql5,libqt5widgets5,mariadb-common,mauikit-calendar-git \(\>= 3.1.0+git\),mauikit-git \(\>= 3.1.0+git\)" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
