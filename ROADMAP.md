# Roadmap: Panic at the Green 🍅

## Project Overview

Panic at the Green is a 2D greenhouse simulator game that demonstrates the complexity of crop management. Players maintain optimal conditions (temperature, humidity, light, CO2) for growing tomato plants.

## Current Status

**Next Task**: US-003 - Build Environment Stats UI

## Task Board

| ID | Title | Assignee | Status | Notes |
|:---|:---|:---|:---|:---|
| US-001 | Initialize Godot Project Structure | opencode | ✅ Complete | Basic structure ready |
| US-002 | Create Simulation Core Singleton | opencode | ✅ Complete | All tests passing |
| US-003 | Build Environment Stats UI | — | ⏳ Pending | — |
| US-004 | Implement Equipment Base System | — | ⏳ Pending | — |
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
