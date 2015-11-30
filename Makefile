SHELL = /bin/sh


PACKAGE_VERSION = $(shell grep "LABEL version" Dockerfile | cut -d '"' -f2)

ORG := lovelysystems

all: docker

Makefile :
	@true

docker:
	docker build -t ${ORG}/elk:$(PACKAGE_VERSION) .

push: docker
	docker push ${ORG}/elk:$(PACKAGE_VERSION)

clean:
	@true

.PHONY: docker clean push
