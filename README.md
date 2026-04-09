# rrfs_lint — RRFS Code Norm Linter

A Python-based linter that checks shell scripts against RRFS coding standards.

## Quick Start

```bash
# Lint everything in the current directory (recursive)
rrfs_lint.py .

# Lint specific files
rrfs_lint.py scripts/exrrfs_fcst.sh jobs/JRRFS_FCST

# List all rules
rrfs_lint.py --list-rules

# Running with no arguments prints the help message
rrfs_lint.py
```

## Requirements

- Python 3.10+ (uses `list[str]` type hints and dataclasses)
- No external dependencies

## Rules

| ID       | Severity | Description |
|----------|----------|-------------|
| RRFS001  | warning  | Use `source` instead of `.` for sourcing files |
| RRFS002  | error    | Use `[[` instead of `[` |
| RRFS003  | error    | Use `==` instead of `=` for string comparison in `[[ ]]` |
| RRFS004  | warning  | Use `-s` instead of `-f` to check if a file exists and is not size zero |
| RRFS005  | warning  | Use `${NDATE}` for date arithmetic, not `date -d` (formatting existing dates with `date -d` is allowed) |
| RRFS006  | error    | Use 2 spaces for indentation; no TABs |
| RRFS007  | error    | Exported variables must start with uppercase (exception: err, pgm) |
| RRFS008  | error    | Use `:-` (not `:` alone) for default values in `${VAR:-default}` |
| RRFS009  | warning  | Use `${var}` instead of `$var` (except shell specials `$?`, `$!`, `$@`, etc.) |
| RRFS010  | warning  | Use `(( ))` instead of `[[ ]]` for arithmetic operations |
| RRFS011  | error    | Double-quote variables in `-z`/`-n` tests: `-z "${var}"` |
| RRFS012  | error    | Job files (`jobs/`) must start with the required header (comments between shebang and header lines are allowed) |
| RRFS013  | error    | Script files (`scripts/`) must start with the required header (comments between shebang and header lines are allowed) |
| RRFS014  | error    | Use `$(command)` instead of backticks |
| RRFS015  | warning  | Use `true`/`false` without quotes in assignments (only flags `="true"` and `="false"`, not comparisons) |
| RRFS016  | warning  | Use `${var^^}` to uppercase before comparing to `TRUE`/`FALSE`/`YES`/`NO` |
| RRFS017  | warning  | Use standard names: `PDY` not `YYYYMMDD`, `cyc` not `HH`, `subcyc` not `MM`, `CDATE` not `YYYYMMDDHH` |
| RRFS018  | error    | Call Python scripts directly with a shebang instead of `python script.py` |

## Command-Line Options

```
usage: rrfs_lint [-h] [--format {default,compact,json}] [--disable RULES]
                 [--enable RULES] [--no-recursive] [--list-rules]
                 [--severity {all,error,warning}] [paths ...]

positional arguments:
  paths                 Files or directories to check (default: .)

options:
  --format, -f          Output format: default, compact, json
  --disable RULES       Comma-separated rule IDs to disable globally
  --enable RULES        Only run these rules (comma-separated)
  --no-recursive        Don't recurse into directories
  --list-rules          List all available rules and exit
  --severity LEVEL      Filter: all, error, warning
```

### Examples

```bash
# Only check for tab and bracket issues
rrfs_lint.py --enable RRFS002,RRFS006 myscript.sh

# Skip the -f vs -s rule
rrfs_lint.py --disable RRFS004 .

# JSON output for CI integration
rrfs_lint.py --format json scripts/ > lint_results.json

# Only show errors (skip warnings)
rrfs_lint.py --severity error .
```

## Suppression Mechanism

Like `shellcheck`, you can suppress rules inline in your code.

### Inline suppression (same line)

```bash
. /etc/profile  # rrfslint: disable=RRFS001
```

### Next-line suppression

```bash
# rrfslint: disable-next-line=RRFS002
if [ -d /tmp ]; then
```

### File-level suppression (top of file)

Must appear in the initial comment block before any code:

```bash
#!/usr/bin/env bash
# rrfslint: file-disable=RRFS006,RRFS009
```

### Disable all rules for an entire file

```bash
#!/usr/bin/env bash
# rrfslint: file-disable=all
```

This skips the file entirely — no rules are checked.

### Multiple rules

Comma-separate rule IDs:

```bash
echo $foo  # rrfslint: disable=RRFS009,RRFS014
```

## Output Formats

### Default (GCC-style)

```
/path/to/file.sh:6:1: warning RRFS001: Use 'source' instead of '.' for better readability.
  . /etc/profile
  Suggestion: source /etc/profile
```

### Compact

```
/path/to/file.sh:6:1: [RRFS001] Use 'source' instead of '.' for better readability.
```

### JSON

```json
[
  {
    "file": "/path/to/file.sh",
    "line": 6,
    "column": 1,
    "rule": "RRFS001",
    "severity": "warning",
    "message": "Use 'source' instead of '.' for better readability.",
    "suggestion": "source /etc/profile",
    "source": ". /etc/profile"
  }
]
```

## CI Integration

The exit code is **1** if any violations are found, **0** if clean. Use this in CI pipelines:

```bash
rrfs_lint.py --format compact scripts/ jobs/
if [[ $? -ne 0 ]]; then
  echo "RRFS lint check failed"
  exit 1
fi
```

## Testing

Sample test files are provided in `tests/`:

```bash
# Run against the intentionally bad example
rrfs_lint.py tests/bad_example.sh

# Run against the suppression examples
rrfs_lint.py tests/suppressed_example.sh
rrfs_lint.py tests/file_suppressed_example.sh

# Run against the good examples (should pass clean)
rrfs_lint.py tests/jobs/ tests/scripts/
```
