#!/bin/bash
TARGET=macintosh_x64

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
ext=.app

# prepare directory
mkdir -p $PKGDIR

cp $LIBDIR/ $PKGDIR
cd $PKGDIR
[[ ! -e $NAME$ext ]] || rm -r $NAME$ext
cp -r $ROOTDIR/$LIBDIR/love.app $ROOTDIR/$PKGDIR/$NAME$ext
cp $ROOTDIR/$GAME $ROOTDIR/$PKGDIR/$NAME$ext/Contents/Resources/$GAME

echo "DONE"