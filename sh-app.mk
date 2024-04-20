check: shellcheck

SHELLCHECK := $(call pathsearch,shellcheck)
shellcheck: $(APP)
ifneq ($(SHELLCHECK),)
	$(SHELLCHECK) $(APP)
endif
.PHONY: shellcheck
