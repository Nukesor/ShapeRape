default: run

clean:
	@[[ ! -e name.love ]] || rm name.love
	@[[ ! -e pkg ]] || rm -r pkg        

build: clean
	@zip -r -0 MAVE.love data/*
	@cd src/ && zip -r ../name.love *

run: build
	@love name.love
