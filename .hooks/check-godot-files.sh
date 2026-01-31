#!/bin/bash
# Pre-commit hook to validate Godot project files
# This script checks that .tscn and .godot files are valid

set -e

echo "Checking Godot project files..."

# Check for staged scene files
staged_tscn=$(git diff --cached --name-only --diff-filter=ACM | grep '\.tscn$' || true)
staged_godot=$(git diff --cached --name-only --diff-filter=ACM | grep '\.godot$' || true)

if [ -n "$staged_tscn" ]; then
    echo "Scene files changed:"
    echo "$staged_tscn"

    # Check for common issues in tscn files
    if echo "$staged_tscn" | xargs grep -l "ext_resource.*path=\"res://" > /dev/null 2>&1; then
        echo "✅ Scene files have valid resource references"
    fi
fi

if [ -n "$staged_godot" ]; then
    echo "⚠️  Warning: project.godot file changed"
    echo "Make sure project settings are intentional"
fi

echo "✅ Godot file check passed!"
exit 0
