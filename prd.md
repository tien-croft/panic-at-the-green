# Panic at the Green - Greenhouse Simulator Game

## Overview

Panic at the Green is a 2D greenhouse simulator game that demonstrates the complexity of growing crops in controlled environments. The player takes on the role of a greenhouse manager who must maintain optimal growing conditions for tomato plants.

This game is being developed by a company that uses AI for crop management in real greenhouses. The company has developed AI models but currently lacks a proper testing environment (software and equipment integration not fully ready). They depend on Priva - an existing system that controls heat pumps, fans, and vents based on temperature thresholds. The game serves as both an educational tool and a way to understand the challenges of greenhouse management.

## Vision

The goal is to create a runnable game first, then iterate toward a more realistic simulator. While real-world accuracy is the long-term vision, the immediate priority is a playable game that captures the essence of greenhouse management challenges.

The game will show players how difficult it is to maintain the delicate balance of:
- Temperature (heating/cooling)
- Humidity (moisture control)
- Light intensity
- CO2 levels
- Irrigation/watering

## Technical Context

- **Engine**: Godot 4.x
- **Language**: GDScript
- **Platform**: Web (HTML5) export for easy sharing
- **Art Style**: 2D Top-down Pixel Art with Y-sorting (Stardew Valley inspired)
- **Testing**: GUT (Godot Unit Test) framework for automated testing

## Equipment Systems (Inspired by Priva)

The game features equipment that mimics real greenhouse control systems:

1. **Heat Pump** - Increases temperature
2. **Fan** - Decreases temperature and humidity
3. **Vent** - Decreases temperature, humidity, and CO2
4. **Irrigation System** - Increases humidity and provides water

Each equipment piece consumes energy/budget when active, adding a resource management layer.

## Crop: Tomato

The tomato plant will have multiple growth stages:
- Seedling
- Vegetative
- Flowering
- Fruiting

Each stage has different optimal environmental requirements. Poor conditions can stunt growth or kill the plant.

## Development Approach

This project uses an agent-based development approach:

1. **Conductor** (you) - Defines tasks and coordinates agents
2. **Agents** (opencode, gemini) - Execute individual tasks
3. **One task per instance** - Each agent instance handles exactly one task, then closes
4. **Fresh context for each task** - New context window for every task
5. **Knowledge preservation** - If a task cannot be completed, the agent writes lessons learned for the next run

## Project Structure

```
~/personal/panic-at-the-green/
├── prd.md              # This file - project vision and context
├── prd.json            # Structured task list in Chief format
├── ROADMAP.md          # Task tracking and lessons learned
├── AGENTS.md           # Guidelines for agentic coding agents
├── project.godot       # Godot project configuration
├── scenes/             # Game scenes (.tscn)
├── scripts/            # GDScript files (.gd)
├── prefabs/            # Reusable components
├── tests/              # GUT test files
└── assets/             # Art, audio, resources
```

## Testing Requirements

All simulation logic must have unit tests:
- Temperature/humidity calculations
- Equipment interactions
- Plant growth state transitions
- Edge cases (extreme values, zero conditions)

Run tests with: `godot --headless --script tests/gut_runner.gd`

## Design Notes

- Keep UI simple and readable - this is a simulator, not an action game
- Use clear visual indicators for environmental stats
- Provide immediate feedback when equipment is activated
- Balance realism with playability - don't make it too frustrating
- Consider adding a tutorial/help system for first-time players

## Success Criteria

The game is considered "runnable" when:
1. Player can view environmental conditions
2. Player can activate/deactivate equipment
3. Tomato plant grows through stages based on conditions
4. Win condition: Successfully grow a tomato to harvest
5. Lose condition: Plant dies from poor conditions

## Future Enhancements (Post-MVP)

- More realistic simulation (weather patterns, day/night cycles)
- Additional crops (cucumbers, peppers, lettuce)
- Pest management
- Disease modeling
- Economic simulation (market prices, operating costs)
- Multi-greenhouse management
- Historical data logging and graphing
- AI advisor that suggests optimal settings
