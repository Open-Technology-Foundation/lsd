# Makefile - Install lsd
# BCS1212 compliant

PREFIX  ?= /usr/local
BINDIR  ?= $(PREFIX)/bin
MANDIR  ?= $(PREFIX)/share/man/man1
COMPDIR ?= /etc/bash_completion.d
DESTDIR ?=

.PHONY: all install uninstall check help

all: help

install:
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 lsd $(DESTDIR)$(BINDIR)/lsd
	install -d $(DESTDIR)$(MANDIR)
	install -m 644 lsd.1 $(DESTDIR)$(MANDIR)/lsd.1
	@if [ -d $(DESTDIR)$(COMPDIR) ]; then \
	  install -m 644 lsd.bash_completion $(DESTDIR)$(COMPDIR)/lsd; \
	fi
	@if [ -z "$(DESTDIR)" ]; then $(MAKE) --no-print-directory check; fi

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/lsd
	rm -f $(DESTDIR)$(MANDIR)/lsd.1
	rm -f $(DESTDIR)$(COMPDIR)/lsd

check:
	@command -v lsd >/dev/null 2>&1 \
	  && echo 'lsd: OK' \
	  || echo 'lsd: NOT FOUND (check PATH)'

help:
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@echo '  install     Install to $(PREFIX)'
	@echo '  uninstall   Remove installed files'
	@echo '  check       Verify installation'
	@echo '  help        Show this message'
	@echo ''
	@echo 'Install from GitHub:'
	@echo '  git clone https://github.com/Open-Technology-Foundation/lsd.git'
	@echo '  cd lsd && sudo make install'
