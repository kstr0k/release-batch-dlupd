# see https://www.gnu.org/prep/standards/html_node/Directory-Variables.html
prefix := /usr/local
sysconfdir  = $(prefix)/etc
datarootdir = $(prefix)/share
datadir = $(datarootdir)
mandir  = $(datarootdir)/man
docdir  = $(datarootdir)/$(PKG)
htmldir = $(datarootdir)/$(PKG)
exec_prefix = $(prefix)
bindir  = $(exec_prefix)/bin
sbindir = $(exec_prefix)/sbin
libdir  = $(exec_prefix)/lib
libexecdir = $(exec_prefix)/libexec

INSTALL := install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644
