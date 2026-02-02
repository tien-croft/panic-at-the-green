.PHONY: help test test-verbose test-file lint format typecheck build build-web clean setup check install-gut install-tools setup-hooks

# Default target
help:
	@echo "Available commands:"
	@echo "  make test         - Run all tests"
	@echo "  make test-verbose - Run tests with verbose output"
	@echo "  make test-file    - Run a specific test file (set FILE=path/to/test.gd)"
	@echo "  make lint         - Lint all GDScript files (requires gdtoolkit)"
	@echo "  make format       - Format all GDScript files (requires gdtoolkit)"
	@echo "  make typecheck    - Check static typing in GDScript files"
	@echo "  make build        - Build for web export"
	@echo "  make build-web    - Build for web (alias)"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make setup        - Setup project dependencies"
	@echo "  make check        - Run format-check + typecheck + lint + test"
	@echo "  make install-gut  - Install GUT testing framework"
	@echo "  make install-tools- Install dev tools (gdtoolkit) with uv"
	@echo "  make setup-hooks  - Setup pre-commit hooks"
	@echo "  make editor       - Open Godot editor"
	@echo "  make run          - Run the game"

# Test commands
test:
	@echo "Running tests..."
	godot --headless -s addons/gut/gut_cmdln.gd

test-verbose:
	@echo "Running tests with verbose output..."
	godot --headless -s addons/gut/gut_cmdln.gd -glog=3

test-file:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make test-file FILE=tests/unit/test_example.gd"; \
		exit 1; \
	fi
	@echo "Running test file: $(FILE)"
	godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://$(FILE)

# Linting and formatting (requires gdtoolkit: uv tool install gdtoolkit)
lint:
	@echo "Linting GDScript files..."
	@if command -v gdlint >/dev/null 2>&1; then \
		gdlint scripts/; \
	else \
		echo "gdlint not found. Install with: uv tool install gdtoolkit"; \
		exit 1; \
	fi

format:
	@echo "Formatting GDScript files..."
	@if command -v gdformat >/dev/null 2>&1; then \
		gdformat scripts/ tests/; \
	else \
		echo "gdformat not found. Install with: uv tool install gdtoolkit"; \
		exit 1; \
	fi

format-check:
	@echo "Checking GDScript formatting..."
	@if command -v gdformat >/dev/null 2>&1; then \
		gdformat --check scripts/ tests/ || (echo "Run 'make format' to fix formatting"; exit 1); \
	else \
		echo "gdformat not found. Install with: uv tool install gdtoolkit"; \
		exit 1; \
	fi

# Static type checking
typecheck:
	@echo "Checking static typing in GDScript files..."
	@.hooks/check-typing.sh

# Install development tools
install-tools:
	@echo "Installing development tools with uv..."
	@if command -v uv >/dev/null 2>&1; then \
		uv tool install gdtoolkit; \
	else \
		echo "uv not found. Install uv first: https://github.com/astral-sh/uv"; \
		exit 1; \
	fi

# Setup pre-commit hooks
setup-hooks:
	@echo "Setting up pre-commit hooks..."
	@if command -v uv >/dev/null 2>&1; then \
		uv tool install pre-commit; \
		pre-commit install; \
	else \
		echo "uv not found. Install uv first: https://github.com/astral-sh/uv"; \
		exit 1; \
	fi

# Build commands
build: build-web

build-web:
	@echo "Building for web export..."
	@mkdir -p build
	godot --headless --export-release "Web" ./build/index.html
	@echo "Build complete: build/"

clean:
	@echo "Cleaning build artifacts..."
	rm -rf build/
	rm -rf .godot/
	find . -name "*.tmp" -delete
	find . -name "*.import" -delete

# Setup and checks
setup: install-gut install-tools setup-hooks
	@echo "Setup complete!"
	@echo "Make sure Godot 4.x is installed and in your PATH"
	@echo "Tools installed via uv: gdtoolkit (gdformat, gdlint), pre-commit"

install-gut:
	@echo "Installing GUT (Godot Unit Test)..."
	@echo "GUT must be installed from Godot Asset Library:"
	@echo "1. Open Godot Editor"
	@echo "2. Click 'AssetLib' tab"
	@echo "3. Search for 'GUT'"
	@echo "4. Download and install"
	@echo "5. Enable in Project Settings -> Plugins"
	@echo ""
	@echo "Or install manually:"
	@echo "git clone https://github.com/bitwes/Gut.git addons/gut"

check: format-check typecheck lint test
	@echo "All checks passed!"

# Development commands
editor:
	godot --editor

run:
	godot

run-headless:
	godot --headless
