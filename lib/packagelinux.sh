#!/bin/bash
TARGET=linux_x64

GAME="ShapeRape.love"
ROOTDIR=$(pwd)

if ! [ -f $ROOTDIR/$GAME ]; then
    echo "Game not found in $GAME - please run \"make build\" first."
    exit 1
fi

echo -n "Packaging for $TARGET... "

PKGDIR=pkg/$TARGET
LIBDIR=lib/$TARGET
NAME=$(lua lib/get_title.lua)
BINARY=$(cd $LIBDIR && ls love*)

ext=."${BINARY##*.}"
if [[ $ext == ".love" ]]; then ext=""; fi

# prepare directory
mkdir -p $PKGDIR

cp $LIBDIR/* $PKGDIR
cd $PKGDIR
cat $ROOTDIR/ShapeRape.love >> "$BINARY"
mv "$BINARY" $NAME$ext

echo "DONE"