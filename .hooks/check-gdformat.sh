#!/bin/bash
# Pre-commit hook for GDScript formatting check
# This script checks if GDScript files are properly formatted before commit

set -e

echo "Checking GDScript formatting..."

# Get list of staged .gd files, excluding addons/
staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.gd$' | grep -v '^addons/' || true)

if [ -z "$staged_files" ]; then
    echo "No GDScript files to check."
    exit 0
fi

# Check if gdformat is installed
if ! command -v gdformat &> /dev/null; then
    echo "Error: gdformat not found"
    echo "Install with: uv tool install gdtoolkit"
    exit 1
fi

# Check formatting
echo "Files to check:"
echo "$staged_files"
echo ""

if ! echo "$staged_files" | xargs gdformat --check; then
    echo ""
    echo "❌ Formatting check failed!"
    echo "Run 'make format' or 'gdformat <files>' to fix formatting."
    exit 1
fi

echo "✅ GDScript formatting check passed!"
exit 0
