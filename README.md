# lsd - List Directory Tree

A lightweight bash wrapper for `tree` that provides sensible defaults for quick directory visualization.

## Overview

`lsd` displays directory trees with a focus on simplicity: **directories only, one level deep, directories first**. It eliminates the need to remember `tree` flags for common operations.

## Quick Install

Install with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/Open-Technology-Foundation/lsd/main/install.sh | sudo bash
```

Or using wget:

```bash
wget -qO- https://raw.githubusercontent.com/Open-Technology-Foundation/lsd/main/install.sh | sudo bash
```

This will install lsd, its manpage, and bash completion to `/usr/local`.

## Features

- Directories-only view by default (use `-a` to include files)
- Single-level depth by default (configurable with `-1` through `-9` or `-m`)
- Directories listed before files
- Optional detailed file listing with `--ls` flag
- Can pass through options directly to `tree` command
- Dual-mode design: works as standalone script or sourced function
- Proper error handling with validation
- BASH-CODING-STANDARD compliant

## Installation

**Requirements**: `tree` command must be installed

### Quick Installation (Recommended)

Use the provided Makefile to install all components:

```bash
# Install to /usr/local (default)
sudo make install

# Install to /usr
sudo make PREFIX=/usr install

# Check dependencies first
make check

# See all available options
make help
```

This installs:
- Script to `/usr/local/bin/lsd`
- Manpage to `/usr/local/share/man/man1/lsd.1`
- Bash completion to `/usr/local/share/bash-completion/completions/lsd`

To uninstall:
```bash
sudo make uninstall
```

### Manual Installation

```bash
# Make executable
chmod +x lsd

# Option 1: Copy to PATH
sudo cp lsd /usr/local/bin/

# Option 2: Source in your shell
source lsd  # Exports lsd() function

# Option 3: Add to shell config for persistent use
echo 'source lsd' >> ~/.bashrc              # If lsd is in PATH
# Or: echo 'source /path/to/lsd' >> ~/.bashrc  # For custom location

# Install manpage (optional)
sudo cp lsd.1 /usr/local/share/man/man1/
sudo mandb

# Install bash completion (optional)
sudo cp lsd.bash_completion /usr/local/share/bash-completion/completions/lsd
```

## Usage

```bash
lsd [OPTIONS] [PATH...] [--|--tree TREE_OPTIONS]
```

### Basic Examples

```bash
lsd                    # Current directory, directories only, 1 level
lsd -a                 # Include files in addition to directories
lsd -A                 # All files with detailed listing (combines -a --ls)
lsd /var /tmp          # Multiple paths
lsd -3 /home           # 3 levels deep
lsd -L 5 /usr          # 5 levels deep (same as -m 5)
lsd -a --ls /etc       # Files + directories with detailed listing
```

## Options

| Option | Description |
|--------|-------------|
| `-a`, `--all` | Show files and directories (default: directories only) |
| `-A` | Same as `-a --ls`; full listing for all files and directories |
| `-m`, `--maxdepth`, `-L`, `-l`, `--level N` | Traverse N levels (default: 1) |
| `-1` through `-9` | Shortcut for depth (e.g., `-3` = 3 levels) |
| `--ls` | Show detailed file listing (permissions, size, date) |
| `-n`, `--nocolor` | Disable color output |
| `-C`, `--color` | Enable color output |
| `--`, `--tree` | Pass remaining arguments directly to `tree` |
| `-V`, `--version` | Show version |
| `-h`, `--help` | Show help |

### Advanced Examples

```bash
# Files and directories, 2 levels, detailed listing
lsd -a -2 --ls ~/projects

# Quick full listing with -A option
lsd -A -3 /etc         # Same as: lsd -a -3 --ls /etc

# Pass custom tree options
lsd -- -L 5 -a -I 'node_modules|.git'

# Multiple directories with custom depth
lsd -4 /usr/local /opt

# Aggregate short options
lsd -a3 /home          # Equivalent to: lsd -a -3 /home
lsd -AC2 ~             # All files, color, 2 levels, detailed listing

# Directories only (default), no color
lsd -n /var/log

# All maxdepth aliases work the same
lsd -L 3 /home         # Same as -m 3, -l 3, or --level 3
```

## Bash Completion

Enable tab completion for lsd options and directories:

```bash
source lsd.bash_completion
```

Or install system-wide:
```bash
sudo cp lsd.bash_completion /etc/bash_completion.d/lsd
```

## Manual Page

A comprehensive Unix manual page is available in `lsd.1`.

**View without installing:**
```bash
man ./lsd.1
```

**Install system-wide:**
```bash
sudo cp lsd.1 /usr/local/man/man1/
sudo mandb  # Update man database
```

**Access after installation:**
```bash
man lsd
```

The manpage includes detailed descriptions of all options, examples, installation instructions, and technical notes about dual-mode functionality.

## Default Behavior

`lsd` invokes `tree` with:
- `-d` - Directories only (unless `-a|--all` specified)
- `-L 1` - Maximum depth 1 level
- `--dirsfirst` - List directories before files

With `--ls` flag, adds:
- `-pugsD` - Permissions, user, group, size, date
- `--timefmt=%y-%m-%dT%R` - ISO-style timestamp

## Dual Mode

**Standalone executable**: Run directly from PATH or local directory
```bash
lsd -3 /var
/usr/local/bin/lsd -a --ls /home
```

**Sourced function**: Use in shell sessions or scripts
```bash
source lsd
lsd -2 ~/projects
```

The script automatically detects execution mode using `${BASH_SOURCE[0]}` and adapts accordingly.

## Error Handling

The script validates:
- `tree` command availability (exit 127 if not found)
- Numeric level arguments (exit 22 for invalid values)
- Proper error messages to stderr

## Dependencies

- `tree` - Directory listing program
- Bash 4.0 or later

## License

See project repository for license information.

#fin
