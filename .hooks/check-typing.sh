#!/bin/bash
# Pre-commit hook to check for static typing in GDScript files
# This script ensures all functions and variables have type annotations

set -e

echo "Checking static typing in GDScript files..."

# Get list of staged .gd files, excluding addons/
staged_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.gd$' | grep -v '^addons/' || true)

if [ -z "$staged_files" ]; then
    echo "No GDScript files to check."
    exit 0
fi

echo "Files to check:"
echo "$staged_files"
echo ""

# Check for untyped function parameters
untyped_params=$(echo "$staged_files" | xargs grep -n "func.*(.*[^:]\+[^)]*)" 2>/dev/null | grep -v "->" || true)
if [ -n "$untyped_params" ]; then
    echo "❌ ERROR: Found functions without proper type annotations:"
    echo "$untyped_params"
    echo ""
    echo "All function parameters and return types must be explicitly typed."
    echo "Example: func my_function(param: int) -> void:"
    exit 1
fi

# Check for untyped variables (var without :)
untyped_vars=$(echo "$staged_files" | xargs grep -n "^\s*var\s\+\w\+\s*=" 2>/dev/null | grep -v "#" || true)
if [ -n "$untyped_vars" ]; then
    echo "❌ ERROR: Found variables without type annotations:"
    echo "$untyped_vars"
    echo ""
    echo "All variables must have explicit type annotations."
    echo "Example: var my_var: int = 0"
    exit 1
fi

# Check for functions without return type annotation
untyped_returns=$(echo "$staged_files" | xargs grep -n "func\s\+\w\+\s*(" 2>/dev/null | grep -v "->" || true)
if [ -n "$untyped_returns" ]; then
    echo "❌ ERROR: Found functions without return type annotations:"
    echo "$untyped_returns"
    echo ""
    echo "All functions must have explicit return type annotations."
    echo "Example: func my_function() -> void:"
    exit 1
fi

echo "✅ Static typing check passed!"
exit 0
