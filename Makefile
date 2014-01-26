default: run

clean:
	@[[ ! -e shaperape.love ]] || rm shaperape.love
	@[[ ! -e pkg ]] || rm -r pkg        

build: clean
	@zip -r -0 shaperape.love data/*
	@cd src/ && zip -r ../shaperape.love *

run: build
	@love shaperape.love

package-windows:
	@lib/packagewin.sh

package-linux:
	@lib/packageunix.sh

package: package-linux package-windows