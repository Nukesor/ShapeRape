#!/bin/bash
TARGET=windows_x86

GAME="shaperape.love"
ROOTDIR=$(pwd)

if ! [ -f $ROOTDIR/$GAME ]; then
    echo "Game not found in $GAME - please run \"make build\" first."
    exit 1
fi

echo -n "Packaging for $TARGET... "

PKGDIR=pkg/$TARGET
LIBDIR=lib/$TARGET
NAME=$(lua lib/get_title.lua)
BINARY=love.exe
ext=.exe

if [[ $ext == ".love" ]]; then ext=""; fi

# prepare directory
mkdir -p $PKGDIR
cp $LIBDIR/* $PKGDIR
cd $PKGDIR
cat $ROOTDIR/$LIBDIR/$BINARY $ROOTDIR/shaperape.love > $NAME$ext

echo "DONE"
