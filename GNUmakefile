TOPDIR = $(shell git rev-parse --show-toplevel)
PKG := $(notdir $(TOPDIR))
APP := $(PKG)

ifeq ($(wildcard std_mk/boilerplate.mk),)
$(info Initializing git submodules...)
$(shell set -x; git submodule update --init std_mk >&2)
ifeq ($(wildcard std_mk/boilerplate.mk),)
$(error git submodules failed)
endif
endif
include mk/shell-is-bash-one.mk
include mk/boilerplate-gnu.mk
include mk/boilerplate.mk
include mk/help2man.mk
include mk/sh-app.mk

VERSION := $(shell mk/changelog-version <$(CHANGELOG))
export VERSION

README := README.md
doc: $(README)
#GEN_README_USAGE := ./$(APP) --help | mk/esc_html
GEN_README_USAGE := pandoc man/man1/$(APP).1 --wrap=none --shift-heading-level-by=2 -t html5 | sed -ne '1,/SYNOPSIS/!p' | mk/help2man-pandoc-html-clean
$(README): man/man1/$(APP).1
	$(GEN_README_USAGE) | mk/update-file-part $(README) 2 '<a id="app_help"></a>' '<a id="app_help_end"></a>'

install:
	@printf %s\\n "Install prefix=$(prefix) DESTDIR=$(DESTDIR)"
	mkdir -p $(DESTDIR)$(mandir)/man/man1 $(DESTDIR)$(libexecdir)
	$(INSTALL_DATA) man/man1/$(APP).1 $(DESTDIR)$(mandir)/man/man1/$(APP).1
	./$(APP) --root=$(DESTDIR)$(libexecdir)/$(PKG) --create

home-install : prefix := $(HOME)/.local
home-install: install

release: all
	mk/gh-release-me $(APP) man/man1/$(APP).1

install-build-dep:
	@mk/apt-install-missing help2man '' pandoc '' shellcheck ''
.PHONY: install-build-dep
all: install-build-dep
