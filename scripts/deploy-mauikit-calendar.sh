#!/usr/bin/env bash

MAUIKIT_CALENDAR_VERSION=$([ -z $BRANCH_MAUIKIT_CALENDAR ] && echo "master" || echo $BRANCH_MAUIKIT_CALENDAR)

echo "Cloning Mauikit Calendar from branch $MAUIKIT_CALENDAR_VERSION"

git clone https://invent.kde.org/maui/mauikit-calendar.git --depth=1 -b $MAUIKIT_CALENDAR_VERSION

cd mauikit-calendar
mkdir -p build
cd build

cmake -DCMAKE_BUILD_TYPE="Release" \
    -DCMAKE_INSTALL_PREFIX="/usr" \
    ..

make -j$(nproc)
DESTDIR=/ make install
make install