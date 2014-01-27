#!/bin/bash
TARGET=$1
NAME=$(lua lib/get_title.lua)
GAME="$NAME.love"
ROOTDIR=$(pwd)

if ! [ -f $ROOTDIR/$GAME ]; then
    echo "Game not found in $GAME - please run \"make build\" first."
    exit 1
fi

echo -n "Packaging for $TARGET... "

PKGDIR=pkg/$TARGET
LIBDIR=lib/$TARGET

rm -rf $PKGDIR
mkdir -p $PKGDIR

cp -r $LIBDIR/* $PKGDIR

if [ $TARGET = "linux_x64" ]; then
	cp $ROOTDIR/$NAME.love $PKGDIR 
	echo "DONE"
elif [ $TARGET = "windows_x86" ]; then
	BINARY=love.exe
	ext=.exe

	if [[ $ext == ".love" ]]; then ext=""; fi

	cd $PKGDIR
	cat $ROOTDIR/$LIBDIR/$BINARY $ROOTDIR/ShapeRape.love > $NAME$ext

	echo "DONE"
elif [ $TARGET = "osx_x64" ]; then
	ext=.app

	cd $PKGDIR
	[[ ! -e $NAME$ext ]] || rm -r $NAME$ext
	cp -r $ROOTDIR/$LIBDIR/love.app $ROOTDIR/$PKGDIR/$NAME$ext
	cp $ROOTDIR/$GAME $ROOTDIR/$PKGDIR/$NAME$ext/Contents/Resources/$GAME

	echo "DONE"
fi

