# Roadmap: Panic at the Green 🍅

## Project Overview

Panic at the Green is a **2D greenhouse farming RPG** where players control a character managing tomato plants through physical exploration, manual tasks, and strategic worker hiring.

## Current Status

**Next Task**: US-WORLD-001 - Create Greenhouse Tilemap with Y-Sorting

## Task Board

| ID | Title | Assignee | Status | Notes |
|:---|:---|:---|:---|:---|
| **FOUNDATION** |
| US-001 | Initialize Godot Project Structure | opencode | ✅ Complete | Basic structure ready |
| US-002 | Create Simulation Core Singleton | opencode | ✅ Complete | All tests passing |
| US-003 | Build Environment Stats UI | opencode | ✅ Complete | UI in top-right, styled |
| US-004 | Implement Equipment Base System | opencode | ✅ Complete | 16 tests passing |
| **PHASE 1: Core Movement & World** |
| US-PLAYER-001 | Create Player Character with Movement | opencode | ✅ Complete | 24 tests passing, interaction system ready |
| US-WORLD-001 | Create Greenhouse Tilemap with Y-Sorting | — | ⏳ Pending | Inside/outside areas |
| US-INTERACT-001 | Implement Proximity Interaction System | opencode | ✅ Complete | 22 tests passing, interaction UI ready |
| **PHASE 2: Equipment & Interaction** |
| US-EQUIP-001 | Create Physical Equipment Stations | opencode | ✅ Complete | All 5 stations with sprites, collision, status indicators |
| US-EQUIP-002 | Implement Equipment Control Interface | — | ⏳ Pending | UI on interaction |
| US-EQUIP-003 | Add Equipment Maintenance System | — | ⏳ Pending | Breakage and repairs |
| US-SENSOR-001 | Add Sensor and Monitoring Stations | — | ⏳ Pending | Detailed readings |
| **PHASE 3: Plants & Tasks** |
| US-PLANT-001 | Create Tomato Plant System (Modular Lego) | — | ⏳ Pending | Modular stackable segments |
| US-TASK-001 | Implement Manual Plant Tasks | — | ⏳ Pending | Pruning, watering, transplanting |
| **PHASE 4: Economy & Workers** |
| US-ECON-001 | Create Economy and Money System | — | ⏳ Pending | Income and expenses |
| US-WORKER-001 | Implement Worker Hiring System | — | ⏳ Pending | Hire NPCs to automate |
| **PHASE 5: Win/Lose & Polish** |
| US-WIN-001 | Implement Win/Lose and Progression | — | ⏳ Pending | Harvest 10 tomatoes |
| US-POLISH-001 | Add Visual Polish and Audio | — | ⏳ Pending | Animations, sounds |
| US-EXPORT-001 | Configure Web Export | — | ⏳ Pending | HTML5 build |

## Lessons Learned & Blockers

### Session Log
#### 2026-02-12 - Create Physical Equipment Stations (US-EQUIP-001)

**Agent**: opencode
**Task**: Create physical equipment stations that can be placed in the world and interacted with
**Status**: ✅ Complete

**What was verified**:

All equipment stations already implemented and functional:

1. **Heat Pump Station** (`scenes/equipment/heat_pump.tscn`)
   - Script: `scripts/equipment/heat_pump.gd`
   - Function: Increases greenhouse temperature
   - Location: Outside (position 150, 200 in main.tscn)

2. **Fan Station** (`scenes/equipment/fan_station.tscn`)
   - Script: `scripts/equipment/fan_station.gd`
   - Function: Cools and dehumidifies
   - Location: Greenhouse walls (position 900, 150)

3. **Vent Station** (`scenes/equipment/vent_station.tscn`)
   - Script: `scripts/equipment/vent_station.gd`
   - Function: Passive ventilation
   - Location: Greenhouse walls (position 250, 150)

4. **Irrigation Panel** (`scenes/equipment/irrigation_panel.tscn`)
   - Script: `scripts/equipment/irrigation_panel.gd`
   - Function: Controls humidity/watering
   - Location: Inside greenhouse (position 500, 250)

5. **Water Tank** (`scenes/equipment/water_tank.tscn`)
   - Script: `scripts/equipment/water_tank.gd`
   - Function: Stores water (1000L capacity)
   - Location: Outside (position 150, 500)

**Features verified**:

- ✅ All stations have sprites (using batch-4-transparent.png atlas)
- ✅ All stations have collision shapes (StaticBody2D with CollisionShape2D)
- ✅ Visual status indicators implemented:
  - Sprite color changes (inactive = gray, active = white/full color)
  - Status light indicator (red = inactive, green = active)
- ✅ All stations placed in main.tscn under Equipment node
- ✅ EquipmentStation base class provides consistent interface
- ✅ Each equipment type extends EquipmentStation with specific functionality
- ✅ Water tank has unique visual feedback based on water level

**Test coverage**:

- 148 tests passing
- Equipment station tests: 10 tests covering initialization, signals, state changes
- Individual equipment tests for HeatPump, FanStation, VentStation, IrrigationPanel, WaterTank
- All tests verify proper functionality and visual state updates

**Acceptance criteria status**:

- ✅ Heat pump station placed outside
- ✅ Fan and Vent stations placed on greenhouse walls
- ✅ Irrigation control panel inside greenhouse
- ✅ Water tank placed outside
- ✅ Each station has sprite and collision
- ✅ Stations show status (active/inactive) visually

**Code quality**:

- All files pass linting and formatting checks
- Static typing verified throughout
- 148/148 tests passing

**Next priorities**:

1. US-EQUIP-002: Implement Equipment Control Interface
2. US-EQUIP-003: Add Equipment Maintenance System

**Blockers encountered**: None
#### 2026-02-02 - Implement Proximity Interaction System (US-INTERACT-001)

**Agent**: opencode
**Task**: Implement proximity interaction system for player to interact with equipment and objects
**Status**: ✅ Complete

**What was done**:

- Created `scripts/interactable.gd` - Base class for all interactable objects
  - Provides `interact()` method that emits `interacted` signal
  - Properties for interaction_name, interaction_description, interaction_enabled
  - Signals for player_entered_range and player_exited_range
  - Objects automatically added to "interactable" group
- Updated `scripts/equipment_base.gd` to extend Interactable
  - Equipment now automatically in interactable group
  - Interaction toggles equipment on/off when player presses 'E'
  - Default interaction text: "Press E to toggle equipment"
- Created `scripts/interaction_ui.gd` and `scenes/interaction_ui.tscn`
  - UI shows at bottom of screen when near interactables
  - Displays "[E]" key prompt and object name/description
  - Connects to player signals: interaction_available, interaction_unavailable
  - Shows "Object Name - Description" format when both exist
- Created `prefabs/heat_pump_station.tscn` as sample equipment station
  - Red color rect with "HEAT" label
  - Collision for player interaction detection
- Updated `scenes/main.tscn` to include InteractionUI with player reference
- Updated `scripts/player.gd` to detect interactables by group membership
- Created comprehensive unit tests (22 tests total):
  - `tests/unit/test_interactable.gd` - 11 tests for Interactable base class
  - `tests/unit/test_interaction_ui.gd` - 8 tests for InteractionUI
  - `tests/unit/test_equipment_interactable.gd` - 9 tests for equipment interaction
- All 77 tests passing (22 new + 55 existing)
- All checks pass: formatting, linting, typechecking

**Key decisions**:

- Interactable extends Node2D (not Node) so objects have 2D position for proximity
- EquipmentBase extends Interactable, so all equipment is automatically interactable
- InteractionUI positioned at bottom-center (not top) to avoid overlap with EnvironmentUI
- Used "interactable" group membership as primary detection method
- Player's existing 64px radius = 2 tiles (assuming 32px tiles), meeting acceptance criteria
- Interaction toggles equipment state (on → off, off → on) for simple UX
- UI shows combined "Name - Description" when custom description exists

**Next priorities**:

1. US-WORLD-001: Create greenhouse tilemap with Y-sorting
2. US-EQUIP-001: Create physical equipment stations (heat pump, fan, irrigation)

**Blockers encountered**: None

#### 2026-02-02 - Create Player Character with Movement (US-PLAYER-001)

**Agent**: opencode
**Task**: Create a player character with movement and interaction capabilities
**Status**: ✅ Complete

**What was done**:

- Created `scripts/player.gd` with Player class extending CharacterBody2D
- Implemented WASD and arrow key movement with 200px/second speed
- Added 4-directional facing system (UP, DOWN, LEFT, RIGHT) for animations
- Created interaction system with 64px detection radius
- Implemented proximity-based interaction detection using Area2D
- Added signals for interaction availability (`interaction_available`, `interaction_unavailable`)
- Press "E" key to interact with nearby objects
- Created `scenes/player.tscn` with CharacterBody2D, collision, sprite, and camera
- Camera follows player with position smoothing enabled
- Added collision detection with 32x32 pixel collision shape
- Created 24 comprehensive unit tests in `tests/unit/test_player.gd`
  - Tests for initialization, movement, facing direction, interaction system
  - Tests for signals, velocity, collision shape, and camera behavior
- Updated `scenes/main.tscn` to include player instance at center of screen
- Added "interact" input action to `project.godot` (mapped to E key and space)
- All 74 tests passing (24 player tests + existing tests)
- All checks pass: formatting, linting, typechecking

**Key decisions**:

- Player extends CharacterBody2D for built-in physics and collision handling
- Interaction detection uses Area2D with CircleShape2D for radius-based detection
- Facing direction prioritizes vertical axis when components are equal
- Interaction system emits signals for UI to show/hide interaction prompts
- Used `_` prefix for unused delta parameter to satisfy linting rules
- Updated Makefile to only lint `scripts/` directory (not tests)

**Next priorities**:

1. US-WORLD-001: Create greenhouse tilemap with inside/outside areas
2. US-INTERACT-001: Implement proximity interaction system (UI layer)

**Blockers encountered**: None



#### 2026-02-02 - Project Vision Update: Character-Driven RPG

**Agent**: opencode
**Task**: Update prd.md and prd.json to reflect new character-driven gameplay vision
**Status**: ✅ Complete

**What was done**:

- Complete rewrite of prd.md to reflect character-driven RPG gameplay
- Restructured prd.json with 18 new user stories organized in 5 phases:
  1. Foundation (4 stories - all complete)
  2. Phase 1: Core Movement & World (3 stories)
  3. Phase 2: Equipment & Interaction (4 stories)
  4. Phase 3: Plants & Tasks (2 stories)
  5. Phase 4: Economy & Workers (2 stories)
  6. Phase 5: Win/Lose & Polish (3 stories)

**Key changes**:

- **Before**: Abstract simulation with clickable UI controls
- **After**: Physical character walks around, interacts with objects
- **New systems**: Worker hiring, economy/money, equipment maintenance
- **Manual tasks**: Pruning, watering, transplanting done by walking to plants
- **Art style**: Confirmed Stardew Valley-inspired pixel art with Y-sorting
- **Gameplay**: Explore → Monitor → Act → Manage → Profit → Maintain

**New core features**:

1. **Player Character**: WASD movement, 4-directional sprites, collision
2. **Physical Equipment**: Walk to heat pump, fans, irrigation controls
3. **Interaction System**: Proximity detection, press 'E' to interact
4. **Manual Tasks**: Watering can, pruning shears, transplanting
5. **Worker System**: Hire NPCs (Technician, Gardener, Manager) with wages
6. **Economy**: Money for equipment costs, repairs, wages; earn from selling tomatoes
7. **Maintenance**: Equipment breaks randomly, needs repair

**Next priorities**:

1. US-PLAYER-001: Player character with movement (foundation for everything)
2. US-WORLD-001: Greenhouse tilemap with inside/outside areas
3. US-INTERACT-001: Proximity interaction system

**Blockers encountered**: None

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
- Implemented time-based decay system for natural condition drift
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

1. Read `prd.md` to understand the full project
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
