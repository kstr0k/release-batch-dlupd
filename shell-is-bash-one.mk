.ONESHELL:
ifeq ($(shell command -v bash 2>/dev/null),)
.SHELLFLAGS := -u -e -c
else
SHELL := bash
.SHELLFLAGS := -o pipefail -uec
endif
