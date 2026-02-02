# Roadmap: Panic at the Green 🍅

## Project Overview

Panic at the Green is a 2D greenhouse simulator game that demonstrates the complexity of crop management. Players maintain optimal conditions (temperature, humidity, light, CO2) for growing tomato plants.

## Current Status

**Next Task**: US-004 - Implement Equipment Base System

## Task Board

| ID | Title | Assignee | Status | Notes |
|:---|:---|:---|:---|:---|
| US-001 | Initialize Godot Project Structure | opencode | ✅ Complete | Basic structure ready |
| US-002 | Create Simulation Core Singleton | opencode | ✅ Complete | All tests passing |
| US-003 | Build Environment Stats UI | opencode | ✅ Complete | UI in top-right, 13 tests |
| US-004 | Implement Equipment Base System | opencode | ✅ Complete | 16 tests passing |
| US-005 | Create Heat Pump Equipment | — | ⏳ Pending | — |
| US-006 | Create Fan Equipment | — | ⏳ Pending | — |
| US-007 | Create Vent Equipment | — | ⏳ Pending | — |
| US-008 | Create Irrigation Equipment | — | ⏳ Pending | — |
| US-009 | Create Greenhouse Tilemap | — | ⏳ Pending | — |
| US-010 | Implement Tomato Plant Growth | — | ⏳ Pending | — |
| US-011 | Add Win/Lose Conditions | — | ⏳ Pending | — |
| US-012 | Create Equipment Control Panel UI | — | ⏳ Pending | — |
| US-013 | Configure Web Export | — | ⏳ Pending | — |
| US-014 | Add Sound Effects and Polish | — | ⏳ Pending | — |

## Lessons Learned & Blockers

### Session Log

#### 2026-02-02 - Implement Equipment Base System (US-004)
**Agent**: opencode
**Task**: Create base equipment class so all greenhouse equipment follows a consistent interface
**Status**: ✅ Complete

**What was done**:
- Created `scripts/equipment_base.gd` with EquipmentBase class
- Implemented properties: `energy_cost` (float, default 1.0), `active` (bool, default false)
- Implemented methods: `activate()`, `deactivate()`, `can_activate()`, `_on_activate()`, `_on_deactivate()`
- Added `set_active()` method for direct state changes with signal emission
- Equipment only activates if `can_activate()` returns true (guard condition)
- Added `state_changed` signal that emits with the new active state (bool parameter)
- Created comprehensive unit tests in `tests/unit/test_equipment_base.gd` (16 tests)
- All tests passing, formatting and linting verified with `make check`

**Key decisions**:
- Equipment extends Node (not Autoload) since equipment will be instanced per scene
- `can_activate()`, `_on_activate()`, `_on_deactivate()` are virtual methods meant for subclass override
- Signal only emits when state actually changes (not on redundant activate/deactivate calls)
- Direct property setting (`active = true`) doesn't emit signals - use `set_active()` for that
- Pattern mirrors SimulationCore design for consistency

**Test coverage**:
- Initial state (inactive by default, energy_cost = 1.0)
- Activation/deactivation behavior
- Signal emission on state changes
- No signal emission when already in target state
- `can_activate()` returning false prevents activation
- Callback methods (`_on_activate`, `_on_deactivate`) invoked correctly
- Direct property setting vs `set_active()` behavior
- Energy cost modification

**Blockers encountered**: None
- All acceptance criteria met
- Tests, formatting, and linting all pass
- 
#### 2026-02-02 - Build Environment Stats UI Re-verification (US-003)
**Agent**: opencode
**Task**: Re-verify Environment UI implementation is complete and all checks pass
**Status**: ✅ Verified - Implementation complete and operational

**What was verified**:
- Environment UI scene exists (`scenes/environment_ui.tscn`) with temperature and humidity displays
- UI properly positioned in top-right corner via CanvasLayer in main scene
- Real-time updates working through Simulation singleton signals
- Visual feedback (color coding) for optimal vs. out-of-range values
- All 34 tests passing (11 Environment UI tests + 21 Simulation Core tests + 2 example tests)
- Code formatting and linting verified with `make check`
- Static typing verified throughout all GDScript files

**Acceptance criteria verified**:
- ✅ UI scene created (environment_ui.tscn)
- ✅ Temperature display with clear visual indicator
- ✅ Humidity display with clear visual indicator
- ✅ Real-time updates when simulation values change
- ✅ UI positioned clearly on screen (top-right corner)
- ✅ Visual feedback when values are outside optimal ranges

**Blockers encountered**: None - feature fully implemented and tested

#### 2026-02-02 - Build Environment Stats UI Verification (US-003)
**Agent**: opencode
**Task**: Verify Environment UI implementation for displaying temperature and humidity
**Status**: ✅ Verified - All acceptance criteria met

**What was verified**:
- Environment UI scene exists (`scenes/environment_ui.tscn`) with temperature and humidity displays
- UI positioned in top-right corner via CanvasLayer in main scene
- Real-time updates working through Simulation singleton signals
- Visual feedback (color coding) for optimal vs. out-of-range values
- All 34 tests passing (11 Environment UI tests + 21 Simulation Core tests + 2 example tests)
- Code formatting and linting verified with `make check`
- Static typing verified throughout all GDScript files

**Files verified**:
- `scripts/environment_ui.gd` - UI logic with signal connections
- `scenes/environment_ui.tscn` - UI layout with labels and icons
- `tests/unit/test_environment_ui.gd` - 11 comprehensive unit tests
- `scenes/main.tscn` - Main scene includes EnvironmentUI in CanvasLayer

**Acceptance criteria status**:
- ✅ UI scene created (environment_ui.tscn)
- ✅ Temperature display with clear visual indicator
- ✅ Humidity display with clear visual indicator
- ✅ Real-time updates when simulation values change
- ✅ UI positioned clearly on screen (top-right corner)
- ✅ Visual feedback when values are outside optimal ranges

**Blockers encountered**: None - feature already fully implemented and tested

#### 2026-02-02 - Build Environment Stats UI (US-003)
**Agent**: opencode
**Task**: Create UI to display temperature and humidity from Simulation singleton
**Status**: ✅ Complete

**What was done**:
- Created `scripts/environment_ui.gd` as a Control class that displays environmental stats
- Created `scenes/environment_ui.tscn` with temperature and humidity labels in top-right corner
- Connected to Simulation singleton signals for real-time updates
- Implemented color-coded feedback (neutral/warning) when values outside optimal ranges
- Created comprehensive unit tests in `tests/unit/test_environment_ui.gd` (13 tests)
- Updated `scenes/main.tscn` to include EnvironmentUI in a CanvasLayer
- All 34 tests passing, formatting and linting verified

**Key decisions**:
- UI positioned in top-right corner for easy visibility (offset 20px from edges)
- Used unique node names (%) for reliable references in the scene
- Optimal ranges: 18-25°C for temperature, 60-80% for humidity
- Color coding: neutral (light gray) for optimal, warning (yellow) for out of range
- Format: one decimal place (e.g., "22.5°C", "65.0%")
- Added getter methods for labels to facilitate testing
- Disabled simulation decay in tests to avoid floating-point precision issues

**Test coverage**:
- Initialization and node references
- Initial value display from Simulation
- Real-time updates via signals (temperature and humidity)
- Display formatting (one decimal place)
- Color changes for values outside optimal ranges
- Multiple rapid updates handling
- Signal disconnection cleanup

**Blockers encountered**: None

#### 2026-02-01 - Create Simulation Core Singleton (US-002)
**Agent**: opencode
**Task**: Create simulation engine that tracks temperature and humidity
**Status**: ✅ Complete

**What was done**:
- Created `scripts/simulation_core.gd` as an Autoload singleton
- Implemented temperature tracking with getter/setter (float, Celsius)
- Implemented humidity tracking with getter/setter (float, percentage 0-100)
- Added signals: `temperature_changed`, `humidity_changed` emitted on value changes
- Implemented time-based decay system for natural condition drift toward targets
- Created comprehensive unit tests in `tests/unit/test_simulation_core.gd` (21 tests)
- Updated `project.godot` to register SimulationCore as Autoload
- Created `.gdlintrc` configuration to exclude test files from certain linting rules
- All 21 tests passing, formatting and linting verified

**Key decisions**:
- Used exponential decay formula for natural condition drift (smooth transitions)
- Temperature has absolute zero validation (-273.15°C minimum)
- Humidity clamped to 0-100% range
- Signals only emitted when values actually change (not on same-value sets)
- Default values: 20°C temperature, 50% humidity
- Decay rates configurable (default 0.1 per second)

**Test coverage**:
- Initial values, getters/setters, property setters
- Signal emission and non-emission when unchanged
- Boundary conditions (humidity clamping, temperature validation)
- Target conditions and decay rates configuration
- Natural decay behavior (gradual change, no overshoot)
- Error handling (push_error for invalid temperature)

**Blockers encountered**: None
- All acceptance criteria met
- Tests, formatting, and linting all pass

#### 2026-02-01 - Test, Lint, Build Infrastructure Setup
**Agent**: opencode
**Task**: Setup test, lint, and build infrastructure
**Status**: ✅ Complete

**What was done**:
- Created tests/ directory with unit/ and integration/ subdirectories
- Created `.gutconfig.json` for GUT test configuration
- Created sample test files (test_example.gd, test_simulation_core.gd)
- Created Makefile with commands: test, test-file, test-verbose, lint, format, build, clean, check
- Created GitHub Actions workflow (`.github/workflows/ci.yml`) for CI/CD
- Created `export_presets.cfg` for web export configuration
- Updated AGENTS.md with comprehensive command documentation
- Updated ROADMAP.md quick reference with Makefile commands

**Key decisions**:
- Using GUT (Godot Unit Test) framework for testing
- Using gdtoolkit (gdformat/gdlint) for code quality
- Using Makefile as unified command interface
- GitHub Actions will run tests and linting on push/PR
- Web export configured for HTML5 builds

**Blockers encountered**: None
- GUT needs to be installed manually or via `git clone`
- Export templates need to be downloaded for builds

#### 2026-02-01 - Pre-commit Hooks and uv Setup
**Agent**: opencode
**Task**: Setup pre-commit hooks and migrate to uv
**Status**: ✅ Complete

**What was done**:
- Updated Makefile to use `uv tool install` instead of `pip install`
- Created `.pre-commit-config.yaml` with pre-commit hooks configuration
- Created `.hooks/` directory with custom hook scripts:
  - `check-gdformat.sh` - Validates GDScript formatting
  - `check-gdlint.sh` - Lints GDScript files
  - `check-godot-files.sh` - Validates Godot project files
- Added `make install-tools` command to install gdtoolkit via uv
- Added `make setup-hooks` command to install and configure pre-commit
- Updated AGENTS.md with uv and pre-commit documentation
- Updated Makefile help text with new commands

**Key decisions**:
- Using **uv** (from Astral) instead of pip for faster, reliable tool installation
- Pre-commit hooks run automatically on `git commit` to ensure code quality
- Hooks check: formatting (gdformat), linting (gdlint), file validation

#### 2026-02-01 - Static Typing, Typecheck, and Ralphy Config Update
**Agent**: opencode
**Task**: Add typecheck command, update ralphy config for opencode with model preferences
**Status**: ✅ Complete

**What was done**:
- Added `make typecheck` command to check static typing in GDScript files
- Created `.hooks/check-typing.sh` pre-commit hook to enforce static typing
- Updated pre-commit config to run typing check FIRST (before format/lint)
- Updated `.ralphy/config.yaml` to:
  - Reference `prd.json` instead of `prd.md`
  - Configure for **opencode** as primary engine
  - Document model preferences: kimi-2.5-free (default), glm-4.7-free, minimax-2.1-free (fallbacks)
  - Add strict static typing rules to ralphy rules section
  - Update project info (Godot 4.x, GDScript)
- Enhanced AGENTS.md Type Safety section with REQUIRED label and examples
- Updated `make check` to include typecheck (format + typecheck + lint + test)
- Updated quick reference commands in both AGENTS.md and ROADMAP.md

**Key decisions**:
- **Static typing is REQUIRED** - No exceptions, all code must be fully typed
- Type checking runs **FIRST** in pre-commit hooks (blocks commit if untyped)
- Ralphy configured to use **opencode** with specific model preferences
- Model fallback order: kimik-k2.5-free → glm-4.7-free → minimax-2.1-free
- Usage: `ralphy --opencode --json prd.json --model opencode/kimi-k2.5-free --branch-per-task`

**Blockers encountered**: None
- Note: Godot doesn't have a built-in typechecker, so we use grep-based checks
- This validates that type annotations are present, not that they're correct
- Godot editor will catch actual type errors during compilation
- Can skip hooks with `git commit --no-verify` in emergencies
- Setup is one-time: `make setup-hooks` then hooks run automatically

**Blockers encountered**: None

#### 2026-02-01 - Update to Godot 4.6
**Agent**: opencode
**Task**: Update project from Godot 4.2 to Godot 4.6
**Status**: ✅ Complete

**What was done**:
- Updated `project.godot` - changed `config/features` from "4.2" to "4.6"
- Updated `.github/workflows/ci.yml` - changed `GODOT_VERSION` from 4.2.2 to 4.6.0
- Updated `README.md` - changed prerequisite from "4.2 or later" to "4.6 or later"
- Verified all other documentation references use "Godot 4.x" (which remains correct)

**Key decisions**:
- Project now targets Godot 4.6 as minimum version
- GitHub Actions CI will use Godot 4.6.0
- Export templates need to match 4.6.0 version

**Blockers encountered**: None

#### 2026-02-01 - prd.json and AGENTS.md Setup
**Agent**: opencode
**Task**: Update project documentation to Chief format
**Status**: ✅ Complete

**What was done**:
- Created comprehensive prd.md with full project context
- Rewrote prd.json to follow Chief format with 14 user stories
- Updated AGENTS.md with Godot 4.x/GDScript style guidelines
- Updated ROADMAP.md with proper tracking format

**Key decisions**:
- Using Chief-style PRD format with userStories array
- Each story has acceptance criteria, priority, passes, and inProgress flags
- Agent-based development: one task per instance, fresh context each time
- US-001 marked complete (project structure already exists)

**Blockers encountered**: None

## Agent Guidelines

### For Conductor (You)

1. **Pick next task**: Find first story with `passes: false` and lowest priority
2. **Spawn agent**: Run one agent instance per task
3. **Provide context**: Give agent the specific user story from prd.json
4. **Track results**: Update this ROADMAP after each session

### For Agents

**When you complete a task**:
1. Update `prd.json`: Set `passes: true`, `inProgress: false`
2. Update `ROADMAP.md`: Mark task complete, add session log entry
3. Include test output if tests were run
4. Note any deviations from original plan

**If you cannot complete a task**:
1. Document what was attempted
2. Write specific "Lessons Learned" - what would help next agent
3. Update `prd.json`: Keep `passes: false`, set `inProgress: false`
4. Note any partial progress made

**Before starting work**:
1. Read `prd.json` to understand the full project
2. Read `AGENTS.md` for code style guidelines
3. Read your specific user story from `prd.json`
4. Check `ROADMAP.md` for any related lessons learned

## Quick Reference

### Run Tests
```bash
make test
# OR
godot --headless -s addons/gut/gut_cmdln.gd
```

### Run Single Test
```bash
make test-file FILE=tests/unit/test_example.gd
# OR
godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/unit/test_example.gd
```

### Lint, Format & Typecheck
```bash
make lint         # Check code style
make format       # Fix code formatting
make format-check # Check without fixing
make typecheck    # Check static typing (REQUIRED)
make check        # Run all checks (format + typecheck + lint + test)
```

### Setup
```bash
make install-tools  # Install gdtoolkit via uv
make setup-hooks    # Setup pre-commit hooks
```

### Ralphy (Agent Orchestration)
```bash
# Run with opencode (default model, creates branch per task)
ralphy --opencode --json prd.json --branch-per-task

# Run with specific model and branch-per-task
ralphy --opencode --json prd.json --model opencode/kimi-k2.5-free --branch-per-task

# Run with fallback models
ralphy --opencode --json prd.json --model opencode/glm-4.7-free --branch-per-task
ralphy --opencode --json prd.json --model opencode/minimax-2.1-free --branch-per-task

# Create PRs for each task (optional)
ralphy --opencode --json prd.json --model opencode/kimi-k2.5-free --branch-per-task --create-pr
```

### Build & Run
```bash
make build       # Build for web
make editor      # Open Godot editor
make run         # Run the game
```

## Definition of Done

A user story is complete when:
- [ ] All acceptance criteria are met
- [ ] Code follows AGENTS.md style guidelines
- [ ] Unit tests pass (if applicable)
- [ ] Manual testing confirms feature works
- [ ] prd.json updated: `passes: true`
- [ ] ROADMAP.md updated with session log
