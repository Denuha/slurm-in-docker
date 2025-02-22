subdir = packages base controller worker database

.PHONY: all build clean lint test $(subdir)

all: build

build: $(subdir)

clean: $(subdir)
	rm -rf home/*
	rm -rf secret/*

test:
	$(MAKE) -C $@

lint:
	shellcheck **/*.sh

controller worker database: base

base: packages

$(subdir):
	$(MAKE) -C $@ $(MAKECMDGOALS)
