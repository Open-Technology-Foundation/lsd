# Makefile for lsd - List Directory Tree
# Part of the Okusi Group file utilities

# Installation paths
PREFIX ?= /usr/local
DESTDIR ?=

BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1
COMPLETIONDIR = $(PREFIX)/share/bash-completion/completions

# Files to install
SCRIPT = lsd
MANPAGE = lsd.1
COMPLETION = lsd.bash_completion

# Installation commands
INSTALL = install
INSTALL_PROGRAM = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 0644

# Default target
.DEFAULT_GOAL := help

#=============================================================================
# Targets
#=============================================================================

.PHONY: help
help:
	@echo "lsd - List Directory Tree"
	@echo ""
	@echo "Available targets:"
	@echo "  make help          - Show this help message"
	@echo "  make check         - Check dependencies (tree command)"
	@echo "  make install       - Install all components (requires sudo)"
	@echo "  make uninstall     - Remove all installed components (requires sudo)"
	@echo "  make test          - Run basic functionality tests"
	@echo "  make clean         - Remove temporary files"
	@echo ""
	@echo "Installation paths (current settings):"
	@echo "  PREFIX=$(PREFIX)"
	@echo "  Script:     $(DESTDIR)$(BINDIR)/$(SCRIPT)"
	@echo "  Manpage:    $(DESTDIR)$(MANDIR)/$(MANPAGE)"
	@echo "  Completion: $(DESTDIR)$(COMPLETIONDIR)/lsd"
	@echo ""
	@echo "Usage examples:"
	@echo "  sudo make install                    # Install to /usr/local"
	@echo "  sudo make PREFIX=/usr install        # Install to /usr"
	@echo "  make DESTDIR=/tmp/staging install    # Stage installation"
	@echo "  sudo make uninstall                  # Remove all components"

.PHONY: check
check:
	@echo "◉ Checking dependencies..."
	@command -v tree >/dev/null 2>&1 || \
		{ echo "✗ Error: 'tree' command not found. Install with: sudo apt install tree"; exit 1; }
	@command -v bash >/dev/null 2>&1 || \
		{ echo "✗ Error: 'bash' not found."; exit 1; }
	@echo "✓ All dependencies satisfied"
	@echo "  - tree: $$(command -v tree)"
	@echo "  - bash: $$(bash --version | head -n1)"

.PHONY: install
install: check install-script install-man install-completion
	@echo ""
	@echo "✓ Installation complete!"
	@echo ""
	@echo "Usage:"
	@echo "  lsd              # List current directory"
	@echo "  lsd -3 /var      # List /var, 3 levels deep"
	@echo "  lsd -A /etc      # All files with detailed listing"
	@echo "  man lsd          # View manual page"
	@echo ""
	@echo "To enable bash completion, start a new shell or run:"
	@echo "  source $(COMPLETIONDIR)/lsd"

.PHONY: install-script
install-script:
	@echo "◉ Installing script..."
	$(INSTALL) -d $(DESTDIR)$(BINDIR)
	$(INSTALL_PROGRAM) $(SCRIPT) $(DESTDIR)$(BINDIR)/$(SCRIPT)
	@echo "✓ Installed: $(DESTDIR)$(BINDIR)/$(SCRIPT)"

.PHONY: install-man
install-man:
	@echo "◉ Installing manpage..."
	$(INSTALL) -d $(DESTDIR)$(MANDIR)
	$(INSTALL_DATA) $(MANPAGE) $(DESTDIR)$(MANDIR)/$(MANPAGE)
	@echo "✓ Installed: $(DESTDIR)$(MANDIR)/$(MANPAGE)"
	@if [ -z "$(DESTDIR)" ] && command -v mandb >/dev/null 2>&1; then \
		echo "◉ Updating man database..."; \
		mandb -q 2>/dev/null || true; \
		echo "✓ Man database updated"; \
	fi

.PHONY: install-completion
install-completion:
	@echo "◉ Installing bash completion..."
	$(INSTALL) -d $(DESTDIR)$(COMPLETIONDIR)
	$(INSTALL_DATA) $(COMPLETION) $(DESTDIR)$(COMPLETIONDIR)/lsd
	@echo "✓ Installed: $(DESTDIR)$(COMPLETIONDIR)/lsd"

.PHONY: uninstall
uninstall:
	@echo "◉ Uninstalling lsd..."
	@if [ -f "$(DESTDIR)$(BINDIR)/$(SCRIPT)" ]; then \
		rm -f $(DESTDIR)$(BINDIR)/$(SCRIPT); \
		echo "✓ Removed: $(DESTDIR)$(BINDIR)/$(SCRIPT)"; \
	else \
		echo "  (script not installed)"; \
	fi
	@if [ -f "$(DESTDIR)$(MANDIR)/$(MANPAGE)" ]; then \
		rm -f $(DESTDIR)$(MANDIR)/$(MANPAGE); \
		echo "✓ Removed: $(DESTDIR)$(MANDIR)/$(MANPAGE)"; \
	else \
		echo "  (manpage not installed)"; \
	fi
	@if [ -f "$(DESTDIR)$(COMPLETIONDIR)/lsd" ]; then \
		rm -f $(DESTDIR)$(COMPLETIONDIR)/lsd; \
		echo "✓ Removed: $(DESTDIR)$(COMPLETIONDIR)/lsd"; \
	else \
		echo "  (completion not installed)"; \
	fi
	@if [ -z "$(DESTDIR)" ] && command -v mandb >/dev/null 2>&1; then \
		echo "◉ Updating man database..."; \
		mandb -q 2>/dev/null || true; \
		echo "✓ Man database updated"; \
	fi
	@echo ""
	@echo "✓ Uninstallation complete"

.PHONY: test
test:
	@echo "◉ Running basic functionality tests..."
	@echo ""
	@echo "▸ Test 1: Script syntax check"
	@bash -n $(SCRIPT) && echo "  ✓ Syntax OK" || { echo "  ✗ Syntax error"; exit 1; }
	@echo ""
	@echo "▸ Test 2: Help output"
	@./$(SCRIPT) -h >/dev/null 2>&1 && echo "  ✓ Help works" || { echo "  ✗ Help failed"; exit 1; }
	@echo ""
	@echo "▸ Test 3: Version output"
	@./$(SCRIPT) -V >/dev/null 2>&1 && echo "  ✓ Version works" || { echo "  ✗ Version failed"; exit 1; }
	@echo ""
	@echo "▸ Test 4: Basic execution (current directory)"
	@./$(SCRIPT) >/dev/null 2>&1 && echo "  ✓ Basic execution works" || { echo "  ✗ Execution failed"; exit 1; }
	@echo ""
	@echo "▸ Test 5: Depth option"
	@./$(SCRIPT) -3 . >/dev/null 2>&1 && echo "  ✓ Depth option works" || { echo "  ✗ Depth option failed"; exit 1; }
	@echo ""
	@echo "▸ Test 6: Manpage syntax"
	@man --warnings -E UTF-8 -l -Tutf8 -Z $(MANPAGE) >/dev/null 2>&1 && \
		echo "  ✓ Manpage syntax OK" || { echo "  ✗ Manpage has errors"; exit 1; }
	@echo ""
	@echo "✓ All tests passed!"

.PHONY: clean
clean:
	@echo "◉ Cleaning temporary files..."
	@rm -f *~ *.bak .*.swp
	@echo "✓ Clean complete"

#fin
