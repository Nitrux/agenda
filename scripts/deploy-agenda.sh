#!/usr/bin/env bash

AGENDA_VERSION=$([ -z $BRANCH_AGENDA ] && echo "master" || echo $BRANCH_AGENDA)

echo "Cloning Agenda from branch $AGENDA_VERSION"

git clone https://invent.kde.org/maui/agenda.git --depth=1 -b $AGENDA_VERSION

cd agenda
cmake -DCMAKE_BUILD_TYPE="Release" \
    -DCMAKE_INSTALL_PREFIX="/usr"

make -j$(nproc)
make install