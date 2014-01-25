default: run

clean:
	@[[ ! -e shaperape.love ]] || rm shaperape.love
	@[[ ! -e pkg ]] || rm -r pkg        

build: clean
	@zip -r -0 shaperape.love data/*
	@cd src/ && zip -r ../shaperape.love *

run: build
	@love shaperape.love
