# Panic at the Green - Greenhouse Farming RPG

## Overview

Panic at the Green is a **2D greenhouse farming RPG** where players control a character who must physically manage a tomato greenhouse. Walk around the farm, interact with equipment, tend to plants, hire workers, and balance the books to grow a successful business.

This game is being developed by a company that uses AI for crop management in real greenhouses. The game serves as both an educational tool and a way to understand the challenges of hands-on greenhouse management.

## Vision

The goal is to create a **character-driven farming simulation** that combines:
- **Physical exploration**: Walk inside/outside the greenhouse
- **Hands-on management**: Manually operate equipment and tend plants
- **Strategic decisions**: Hire workers, manage money, prioritize tasks
- **Real-world complexity**: Equipment breaks, plants need care, time is limited

Players experience the challenge of maintaining:
- **Temperature** (heating/cooling systems)
- **Humidity** (irrigation and ventilation)
- **Plant health** (watering, pruning, transplanting)
- **Equipment maintenance** (repairs and monitoring)
- **Economy** (wages, energy costs, tomato sales)

## Technical Context

- **Engine**: Godot 4.x
- **Language**: GDScript
- **Platform**: Web (HTML5) export for easy sharing
- **Art Style**: **2D Top-down Pixel Art** with Y-sorting (**Stardew Valley** inspired)
  - 16x16 or 32x32 pixel tiles
  - Modular "Lego" System for plants (Tomato)
  - Character sprites with directional animations
- **Camera**: Fixed top-down view following the player
- **Testing**: GUT (Godot Unit Test) framework for automated testing

## Art Assets Plan

### Batch 1: The Player Character (The Anchor)
- **Goal**: Define the art style and scale.
- **Content**: 4-directional Farmer (hat/overalls), Idle poses, Walk cycles.

### Batch 2: The Modular Tomato "Lego" System (The Hero Asset)
- **Goal**: Create stackable segments to build dynamic plants on the cocopeat base.
- **The Base Unit**: Cocopeat slab sitting on the drainage shell with the irrigation tube plugged in.
- **Middle Segments (Stackable)**: Tiling vertically on the grid (e.g., 16x16 or 32x32).
  - **State A**: Pruned Stem (Just stem and string, bare)
  - **State B**: Vegetative (Stem, string, lush leaves)
  - **State C**: Flowering (Stem, string, leaves, yellow flower clusters)
  - **State D**: Fruiting Green (Stem, string, leaves, small green tomatoes)
  - **State E**: Fruiting Red (Stem, string, leaves, ripe red cherry tomatoes)
- **Top Segments (Caps)**:
  - **State A**: Leafy Tip
  - **State B**: Flowering Tip

### Batch 3: The Greenhouse Structure (Tileset)
- **Goal**: Build the environment around the plants.
- **Content**: White floor cover, concrete paths, metal frame walls, glass texture, doors.

### Batch 4: Machinery & Equipment
- **Goal**: Technical details for environmental control.
- **Content**: Trutina sensor box, heat pumps, fans, water tank, hanging yellow traps.

### Batch 5: NPCs & UI
- **Goal**: Final polish.
- **Content**: The three workers (Technician, Gardener, Manager) and interface elements.

## Core Gameplay Loop

1. **Explore**: Walk around the greenhouse and surrounding area
2. **Monitor**: Check sensors and equipment status by walking to them
3. **Act**: Toggle equipment, water plants, prune, transplant
4. **Manage**: Hire workers to automate tasks (costs money)
5. **Profit**: Harvest and sell tomatoes, pay expenses
6. **Maintain**: Fix broken equipment or hire technicians

## Game World

### Areas
- **Greenhouse Interior**: Plant benches, irrigation controls, sensors
- **Greenhouse Exterior**: Heat pump, water tank, fan/vent stations
- **Workshop/Office**: Hire workers, view finances
- **Market**: Sell harvested tomatoes

### Key Objects
- **Equipment Stations**: Physical objects to walk to and interact with
- **Plant Benches**: Where tomato plants grow through stages
- **Sensor Stations**: Detailed environmental monitoring
- **Water Tank**: Source for manual watering

## Character System

### Player Character
- **Movement**: WASD or arrow keys, 4-directional
- **Actions**: Press 'E' to interact with nearby objects
- **Tools**: Carrying water can, pruning shears, etc.
- **Energy**: Optional stamina system limiting actions per day

### Worker System
Hire NPC workers to automate tasks:
- **Technician**: Repairs broken equipment
- **Gardener**: Waters and prunes plants
- **Manager**: Monitors equipment and toggles based on thresholds
- **General Worker**: Does basic tasks

Workers have:
- **Daily Wage**: Paid from your money
- **Skill Level**: Affects task speed and success
- **Work Area**: Assign to specific zones
- **Autonomy**: Will work independently once assigned

## Equipment Systems (Physical)

Equipment exists as **physical objects** in the world:

### Heat Pump (Outside)
- **Purpose**: Increases greenhouse temperature
- **Interaction**: Walk to control panel, set target temp, toggle on/off
- **Cost**: Money per hour when active
- **Maintenance**: Can break down, needs repair

### Fan & Vent (Greenhouse walls)
- **Purpose**: Decrease temperature and humidity
- **Interaction**: Toggle on/off at the station
- **Cost**: Money per hour when active

### Irrigation System (Inside)
- **Purpose**: Increases humidity and auto-waters plants
- **Interaction**: Control panel to set schedule and intensity
- **Water Tank**: Physical tank outside that needs refilling

### Sensors (Throughout)
- **Purpose**: Monitor temperature/humidity
- **Interaction**: Check detailed readings, set alert thresholds
- **Types**: Basic (current only), Advanced (trends and history)

## Plant System: Tomato

### Growth Stages
1. **Seedling** - Needs constant warmth and moisture
2. **Vegetative** - Needs space (transplant to larger pots)
3. **Flowering** - Needs optimal conditions for fruit set
4. **Fruiting** - Needs consistent watering
5. **Harvest** - Pick and sell!

### Manual Tasks
- **Watering**: Walk to water tank, fill can, walk to plant, water
- **Pruning**: Remove dead leaves to boost growth
- **Transplanting**: Move seedlings to larger pots
- **Harvesting**: Pick ripe tomatoes

### Plant Health
- Affected by environmental conditions
- Can die if neglected
- Shows visual state (wilting, healthy, thriving)

## Economy System

### Income
- **Selling Tomatoes**: Primary income source
- **Bonus**: Perfect conditions = premium price

### Expenses
- **Equipment Operation**: Per-hour costs for active equipment
- **Worker Wages**: Daily payments to hired workers
- **Repairs**: Fix broken equipment
- **Supplies**: Water, fertilizer, new seeds

### Financial Management
- Start with limited funds
- Must balance automation (workers) vs. doing it yourself
- Risk of bankruptcy if costs exceed income

## User Interface

### Always Visible
- **Status Panel**: Temperature, Humidity (top-right, styled)
- **Money Display**: Current funds (top-left)
- **Time**: Current time/day (top-center)

### Interaction UIs
- **Equipment Panel**: Appears when interacting with equipment
- **Plant Status**: Shows when interacting with plants
- **Worker Hub**: Office interface for hiring/managing
- **Shop/Market**: Buy supplies, sell tomatoes

## Art Style Guide

### Visual Style
- **Pixel Art**: 16-bit console aesthetic
- **Colors**: Warm, saturated, inviting
  - Greens: Vibrant plant greens
  - Browns: Warm wood and earth tones
  - Blues: Cool water and sky
- **Lighting**: Day/night cycle with color shifts

### Character Design
- **Player**: Simple farmer character with hat
- **Workers**: Color-coded outfits by type
- **Animations**: Walk cycles in 4 directions

### Environment
- **Greenhouse**: Wooden frame, glass panels, plant benches
- **Exterior**: Grass, dirt paths, equipment structures
- **Details**: Tools, water droplets, particle effects

## Success Criteria

Game is "playable" when:
1. ✅ Player can walk around and interact with objects
2. ✅ Can view and control equipment by walking to stations
3. ✅ Can manually tend plants (water, prune, harvest)
4. ✅ Economy works (earn/spend money)
5. ✅ Can hire workers to automate tasks
6. ✅ Win: Successfully grow and sell tomatoes profitably
7. ✅ Lose: Go bankrupt or all plants die

## Development Phases

### Phase 1: Core Movement & World
- Player character with movement
- Basic tilemap (greenhouse + outside)
- Camera following player

### Phase 2: Equipment & Interaction
- Place equipment in world as physical objects
- Proximity interaction system
- Equipment control UIs

### Phase 3: Plants & Tasks
- Tomato plants with growth stages
- Manual task system (water, prune, harvest)
- Plant health and death

### Phase 4: Economy & Workers
- Money system
- Worker hiring and management
- Selling tomatoes

### Phase 5: Polish
- Animations and sound
- Day/night cycle
- Visual polish

## Project Structure

```
~/personal/panic-at-the-green/
├── prd.md              # This file - project vision
├── prd.json            # Structured task list
├── ROADMAP.md          # Task tracking
├── AGENTS.md           # Code style guidelines
├── project.godot       # Godot project config
├── scenes/             # Game scenes (.tscn)
│   ├── main.tscn       # Main game world
│   ├── player.tscn     # Player character
│   ├── greenhouse.tscn # Greenhouse interior
│   └── ui/             # UI scenes
├── scripts/            # GDScript files (.gd)
│   ├── player.gd       # Player movement/control
│   ├── equipment/      # Equipment scripts
│   ├── plants/         # Plant system
│   ├── workers/        # Worker AI
│   └── economy/        # Money system
├── prefabs/            # Reusable components
├── tests/              # GUT test files
└── assets/             # Art, audio, resources
    ├── sprites/        # Character sprites
    ├── tiles/          # Tilemap assets
    └── audio/          # Sound effects & music
```

## Testing Requirements

- Player movement and collision
- Equipment interaction detection
- Plant growth logic
- Economy calculations
- Worker AI behavior
- Save/load system (if implemented)

## Future Enhancements (Post-MVP)

- Multiple crop types (cucumbers, peppers, lettuce)
- Weather patterns affecting greenhouse
- Pest and disease management
- Research/upgrades for equipment
- Seasonal changes
- Multiple greenhouse management
- AI advisor that suggests optimal settings
- Historical data graphs and analytics
