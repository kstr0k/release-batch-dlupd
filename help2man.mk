doc: man
man: man/man1/$(APP).1
.PHONY: man
man/man1/$(APP).1: $(APP) $(CHANGELOG)
	help2man --version-string='$(VERSION)' --no-info ./$(APP) -o $@
