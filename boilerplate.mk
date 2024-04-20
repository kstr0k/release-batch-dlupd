define NEWLINE


endef

# make won't not re-export to shell
TMPDIR ?= /tmp

# usage: $(call pathsearch,cmd1 cmd2 etc...)
pathsearch = $(shell command -v $(1) 2>/dev/null)

NOW_PERL := perl -e 'use warnings; use v5.28.0;'

CHANGELOG := $(wildcard doc/CHANGES.md)

all: doc check
check:
doc:
release: all
.PHONY: all check doc release
