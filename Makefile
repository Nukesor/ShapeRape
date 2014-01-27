default: run

clean:
	@[[ ! -e ShapeRape.love ]] || rm ShapeRape.love
	@[[ ! -e pkg ]] || rm -r pkg        

build: clean
	@zip -r -0 ShapeRape.love data/*
	@cd src/ && zip -r ../ShapeRape.love *

run: build
	@love ShapeRape.love

package-windows:
	@lib/package.sh windows_x86

package-linux:
	@lib/package.sh linux_x64

package-mac:
	@lib/package.sh osx_x64

package: package-linux package-windows package-mac
