#!/bin/bash
# Pre-commit hook for GDScript linting
# This script lints GDScript files before commit

set -e

echo "Linting GDScript files..."

# Get list of staged .gd files, excluding addons/
staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.gd$' | grep -v '^addons/' || true)

if [ -z "$staged_files" ]; then
    echo "No GDScript files to lint."
    exit 0
fi

# Check if gdlint is installed
if ! command -v gdlint &> /dev/null; then
    echo "Error: gdlint not found"
    echo "Install with: uv tool install gdtoolkit"
    exit 1
fi

# Lint files
echo "Files to lint:"
echo "$staged_files"
echo ""

if ! echo "$staged_files" | xargs gdlint; then
    echo ""
    echo "❌ Linting failed!"
    echo "Fix the issues above before committing."
    exit 1
fi

echo "✅ GDScript linting passed!"
exit 0
