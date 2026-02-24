# Panic at the Green 🍅

A 2D greenhouse simulator game that demonstrates the complexity of crop management. Players must maintain optimal growing conditions (temperature, humidity, light, CO2) for tomato plants to survive and thrive.

![Godot 4.x](https://img.shields.io/badge/Godot-4.x-blue.svg)
![GDScript](https://img.shields.io/badge/Language-GDScript-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## About

This game was created to showcase the challenges of greenhouse management - the same challenges faced by real agricultural operations. Built by a company using AI for crop management, this simulator demonstrates why maintaining the perfect environment is harder than it looks.

### Features

- 🌡️ **Dynamic Environment** - Temperature and humidity fluctuate naturally
- 🔧 **Equipment Management** - Control heat pumps, fans, vents, and irrigation
- 🌱 **Plant Growth Stages** - Guide tomatoes from seedlings to harvest
- ⚡ **Resource Management** - Balance energy costs with plant health
- 🎮 **Web Export** - Play directly in your browser

## Quick Start

### Prerequisites

- [Godot 4.x](https://godotengine.org/download) (4.6 or later recommended)
- [uv](https://github.com/astral-sh/uv) (for development tools)
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/panic-at-the-green.git
   cd panic-at-the-green
   ```

2. **Setup development tools**

   ```bash
   make setup
   ```

3. **Install GUT (Godot Unit Test)**

   ```bash
   # Via Godot Asset Library
   # 1. Open Godot Editor
   # 2. Click AssetLib tab
   # 3. Search for "GUT"
   # 4. Download and install
   # 5. Enable in Project Settings -> Plugins

   # Or manually
   git clone --depth 1 --branch v9.5.0 https://github.com/bitwes/Gut.git addons/gut
   ```

## Running the Game

### Development Mode

```bash
# Open in Godot Editor
make editor

# Or run directly
make run
```

### Production Build (Web)

```bash
# Build for web export
make build

# Output will be in build/ directory
```

To serve the web build locally:

```bash
cd build
python3 -m http.server 8000
# Open http://localhost:8000 in your browser
```

## Development

### Project Structure

```
panic-at-the-green/
├── project.godot          # Godot project configuration
├── prd.json              # Product requirements (user stories)
├── prd.md                # Project documentation
├── ROADMAP.md            # Development tracking
├── AGENTS.md             # Coding guidelines for AI agents
├── Makefile              # Build automation
├── scenes/               # Game scenes (.tscn)
├── scripts/              # GDScript source files
├── prefabs/              # Reusable components
├── tests/                # Unit and integration tests
│   ├── unit/
│   └── integration/
└── assets/               # Art, audio, and resources
```

### Makefile Commands

```bash
# Testing
make test                    # Run all tests
make test-file FILE=...      # Run specific test file
make test-verbose            # Run tests with verbose output

# Code Quality
make format                  # Format all GDScript files
make lint                    # Lint all GDScript files
make typecheck               # Check static typing
make check                   # Run all checks (format + typecheck + lint + test)

# Build & Run
make build                   # Build for web export
make editor                  # Open Godot editor
make run                     # Run the game
make clean                   # Clean build artifacts

# Setup
make install-tools           # Install gdtoolkit via uv
make setup-hooks             # Setup pre-commit hooks
```

### Code Standards

This project enforces strict code quality standards:

1. **Static Typing (REQUIRED)** - All GDScript must have explicit type annotations
2. **Formatting** - Code must pass `gdformat` checks
3. **Linting** - Code must pass `gdlint` checks
4. **Tests** - All simulation logic must have unit tests

Pre-commit hooks automatically check these standards before every commit.

### Running Tests

```bash
# Run all tests
make test

# Run specific test file
make test-file FILE=tests/unit/test_simulation_core.gd

# Run with verbose output
make test-verbose
```

## Agent-Based Development

This project uses **Ralphy** for orchestrating AI agents to complete tasks:

### Running with Ralphy

```bash
# Run with default model (kimi-k2.5-free)
ralphy --opencode --json prd.json --branch-per-task

# Run with specific model
ralphy --opencode --json prd.json --model opencode/kimi-k2.5-free --branch-per-task

# Run with fallback models
ralphy --opencode --json prd.json --model opencode/glm-4.7-free --branch-per-task
ralphy --opencode --json prd.json --model opencode/minimax-2.1-free --branch-per-task

# Create PRs for each task (optional)
ralphy --opencode --json prd.json --model opencode/kimi-k2.5-free --branch-per-task --create-pr
```

### Task Management

Tasks are defined in `prd.json` following the Chief PRD format:

- Each user story has a unique ID (e.g., US-001)
- Acceptance criteria define completion
- Priority determines execution order
- `passes` flag tracks completion status

## How to Play

1. **Start the game** - The greenhouse starts with baseline conditions
2. **Monitor conditions** - Watch temperature and humidity displays
3. **Activate equipment** - Use controls to adjust the environment:
   - **Heat Pump** - Increases temperature
   - **Fan** - Decreases temperature and humidity
   - **Vent** - Decreases temperature, humidity, and CO2
   - **Irrigation** - Increases humidity and provides water
4. **Grow your plant** - Maintain optimal conditions for each growth stage
5. **Win/Lose** - Successfully harvest your tomato before it dies!

### Optimal Conditions for Tomatoes

| Growth Stage | Temperature | Humidity |
| ------------ | ----------- | -------- |
| Seedling     | 20-25°C     | 70-80%   |
| Vegetative   | 22-26°C     | 60-70%   |
| Flowering    | 20-24°C     | 50-60%   |
| Fruiting     | 22-26°C     | 50-60%   |

## Troubleshooting

### GUT Not Found

If tests fail with "GUT not found":

```bash
git clone --depth 1 --branch v9.5.0 https://github.com/bitwes/Gut.git addons/gut
```

### Export Templates Missing

If web build fails:

1. Open Godot Editor
2. Editor → Manage Export Templates
3. Download templates for your Godot version

### Pre-commit Hooks Not Running

If hooks aren't executing:

```bash
make setup-hooks
# Or manually:
uv tool install pre-commit
pre-commit install
```

## Contributing

This project uses an agent-based development workflow:

1. Check `prd.json` for incomplete user stories
2. Pick the next task (lowest priority with `passes: false`)
3. Run ralphy to spawn an agent for that task
4. Agent completes task and updates documentation
5. Review changes and merge

See `AGENTS.md` for detailed coding standards and guidelines.

## License

MIT License - See LICENSE file for details.

## Credits

Created by a team passionate about bringing AI-driven agriculture to life through gaming.

---

**Happy Growing! 🌱**
