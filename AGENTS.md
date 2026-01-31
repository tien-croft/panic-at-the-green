# Agent Guidelines for Panic at the Green

This is a Godot 4.x project using GDScript. It's a 2D greenhouse simulator where players maintain optimal conditions for tomato plants.

## How to Start Working

1. **Read your task**: Check `prd.json` for the user story assigned to you
2. **Understand context**: Read `prd.md` for project background and vision
3. **Check history**: Look at `ROADMAP.md` for lessons learned from previous attempts
4. **Follow style guide**: This file contains coding standards for GDScript
5. **One task per session**: Complete your assigned user story, then stop

## Project Structure

```
~/personal/panic-at-the-green/
├── project.godot          # Main Godot project file
├── prd.json              # Product requirements document
├── prd.md                # Project vision and context
├── ROADMAP.md            # Task tracking and lessons learned
├── Makefile              # Build/test/lint commands
├── .gutconfig.json       # GUT test configuration
├── .pre-commit-config.yaml # Pre-commit hooks config
├── export_presets.cfg    # Godot export settings
├── .hooks/               # Pre-commit hook scripts
├── scenes/               # Scene files (.tscn)
├── scripts/              # GDScript files (.gd)
├── prefabs/              # Reusable scene components
├── tests/                # Test files
│   ├── unit/             # Unit tests
│   └── integration/      # Integration tests
└── assets/               # Art, audio, and other resources
```

## Quick Commands (Makefile)

Use `make` for all common tasks:

```bash
# See all available commands
make help

# Run all tests
make test

# Run a specific test file
make test-file FILE=tests/unit/test_example.gd

# Run tests with verbose output
make test-verbose

# Format code
make format

# Lint code
make lint

# Check static typing
make typecheck

# Run all checks (format + typecheck + lint + test)
make check

# Build for web
make build

# Clean build artifacts
make clean

# Open Godot editor
make editor

# Run the game
make run

# Install development tools
make install-tools

# Setup pre-commit hooks
make setup-hooks
```

## Build/Run Commands

```bash
# Run the game in the editor
godot --editor
make editor

# Run the game (headless, for testing)
godot --headless
make run-headless

# Export for web (requires export template configured)
godot --export-release "Web" ./build/index.html
make build
```

## Test Commands

This project uses GUT (Godot Unit Test) for testing. Configuration is in `.gutconfig.json`.

```bash
# Run all tests
make test
# OR
godot --headless -s addons/gut/gut_cmdln.gd

# Run a specific test file
make test-file FILE=tests/unit/test_simulation_core.gd
# OR
godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/unit/test_simulation_core.gd

# Run tests with verbose output
make test-verbose
# OR
godot --headless -s addons/gut/gut_cmdln.gd -glog=3
```

### Installing GUT

If GUT is not installed:
1. Open Godot Asset Library
2. Search for "GUT" (Godot Unit Test)
3. Download and install to `res://addons/gut/`
4. Enable in Project Settings > Plugins

Or install via command line:
```bash
git clone --depth 1 --branch godot_4 https://github.com/bitwes/Gut.git addons/gut
```

## Linting and Formatting

This project uses **gdtoolkit** for code quality, installed via **uv** (fast Python package manager):

### Installing Tools with uv

```bash
# Install uv first (if not already installed)
# See: https://github.com/astral-sh/uv

# Install gdtoolkit (provides gdformat and gdlint)
uv tool install gdtoolkit
# Or use make:
make install-tools
```

### Running Checks

```bash
# Format all GDScript files
make format
# OR
gdformat scripts/ tests/

# Lint all GDScript files
make lint
# OR
gdlint scripts/ tests/

# Check formatting without making changes
make format-check

# Run all checks (format + lint + test)
make check
```

## Pre-commit Hooks

This project uses pre-commit hooks to ensure code quality before each commit:

### Setup

```bash
# Install pre-commit hooks (one-time setup)
make setup-hooks
# OR manually:
uv tool install pre-commit
pre-commit install
```

### What Hooks Check

Pre-commit automatically runs these checks on staged files in order:

1. **Static Typing** ⭐ **FIRST** - Ensures all GDScript has explicit type annotations
2. **GDScript Formatting** - Ensures code follows gdformat style
3. **GDScript Linting** - Checks for style issues with gdlint
4. **Godot File Validation** - Validates .tscn and .godot files
5. **Trailing Whitespace** - Removes trailing spaces
6. **JSON/YAML Validation** - Ensures config files are valid
7. **Large File Check** - Prevents committing files > 1MB

### Manual Hook Execution

```bash
# Run hooks on all files (not just staged)
pre-commit run --all-files

# Run specific hook
pre-commit run gdformat-check

# Skip hooks (emergency only)
git commit --no-verify
```

**Note**: If a hook fails, fix the issues and commit again. The hooks will run automatically.

## Code Style Guidelines

### GDScript Conventions

- **Naming**: Use `snake_case` for variables, functions, signals, and file names
- **Classes**: Use `PascalCase` for class names and node types
- **Constants**: Use `CONSTANT_CASE` for constants
- **Private**: Prefix private methods/variables with underscore: `_private_var`

### File Organization

```gdscript
# 1. Tool and class_name
tool
class_name MyClass
extends BaseClass

# 2. Signals (alphabetical order)
signal health_changed(new_health)
signal died

# 3. Enums
enum State { IDLE, WALKING, RUNNING }

# 4. Constants
const MAX_HEALTH = 100
const DAMAGE_COOLDOWN = 0.5

# 5. Exported variables (grouped by category)
@export var max_speed: float = 300.0
@export var acceleration: float = 50.0

@export_category("Combat")
@export var attack_damage: int = 10
@export var attack_range: float = 50.0

# 6. Regular variables (grouped by use)
var _velocity: Vector2 = Vector2.ZERO
var _current_health: int = MAX_HEALTH

# 7. Onready variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# 8. Built-in virtual methods
func _ready() -> void:
    _initialize()

func _process(delta: float) -> void:
    _update_movement(delta)

# 9. Public methods
func take_damage(amount: int) -> void:
    _current_health -= amount
    health_changed.emit(_current_health)

# 10. Private methods
func _initialize() -> void:
    pass
```

### Type Safety (REQUIRED)

**ALL code MUST use static typing. No exceptions.**

- **ALWAYS** use static typing with `->` for return types and `:` for variable types
- **ALWAYS** use `-> void` for methods that don't return values
- **ALWAYS** explicitly type all function parameters
- **ALWAYS** explicitly type all variables (even with obvious initial values)
- **NEVER** use dynamic typing or rely on type inference

**Examples:**
```gdscript
# ✅ CORRECT - fully typed
func calculate_damage(base: int, multiplier: float) -> int:
    var result: int = int(base * multiplier)
    return result

# ✅ CORRECT - void return type
func set_temperature(value: float) -> void:
    var previous: float = _temperature
    _temperature = value

# ❌ INCORRECT - missing types
func calculate_damage(base, multiplier):
    var result = base * multiplier
    return result

# ❌ INCORRECT - missing return type
func set_temperature(value: float):
    _temperature = value
```

**Verification:**
```bash
# Check typing before committing
make typecheck

# Run full check (includes typecheck)
make check
```

**Pre-commit hook**: The `check-typing` hook will block commits with untyped code.

### Comments

- Use `##` for documentation comments (shown in editor tooltips)
- Use `#` for inline comments explaining complex logic
- Document exported variables with tooltips

### Error Handling

- Use `assert()` for debug-only checks that should never fail
- Use `push_error()` or `push_warning()` for runtime issues
- Return early on error conditions (guard clauses)
- Example:
  ```gdscript
  func set_temperature(value: float) -> void:
      if value < ABSOLUTE_ZERO:
          push_error("Temperature below absolute zero!")
          return
      _temperature = value
  ```

### Scene Organization

- Main scene: `res://scenes/main.tscn`
- Group related nodes using empty Node parents
- Name nodes descriptively: `PlayerSprite` not `Sprite2D2`
- Use node groups for logical collections: `add_to_group("equipment")`

## Project-Specific Patterns

### Simulation Core Architecture

This project uses a singleton (Autoload) pattern for the simulation engine:

1. Create `scripts/simulation_core.gd` as an Autoload
2. Add to Project Settings > Autoload as `Simulation`
3. Expose signals for state changes:
   ```gdscript
   signal temperature_changed(new_temp: float)
   signal humidity_changed(new_humidity: float)
   ```

### Equipment Pattern

All equipment should follow this interface:

```gdscript
class_name EquipmentBase
extends Node

@export var energy_cost: float = 1.0
@export var active: bool = false

func activate() -> void:
    if not can_activate():
        return
    active = true
    _on_activate()

func deactivate() -> void:
    active = false
    _on_deactivate()

func can_activate() -> bool:
    return true  # Override in subclass

func _on_activate() -> void:
    pass  # Override in subclass

func _on_deactivate() -> void:
    pass  # Override in subclass
```

## Testing Guidelines

- Test simulation logic in isolation (pure functions)
- Use `await` for time-based tests
- Mock equipment interactions for unit tests
- Test edge cases: extreme temperatures, zero humidity, etc.

## Git Workflow

- Never commit `.godot/` folder (already in .gitignore)
- Never commit `*.import` files
- Include `.tscn` and `.gd` files in commits
- Update `ROADMAP.md` when completing tasks
