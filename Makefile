default: build

build:
	hugo

server:
	hugo server --buildDrafts --watch

.PHONY: default build server
