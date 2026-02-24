# Asset Batches Documentation

This document defines the content and goals for the five asset batches used in "Panic at the Green".

## Batch 1: The Player Character (The Anchor)
**Goal:** Define the art style and scale.
**Content:**
- 4-directional Farmer (hat/overalls)
- Idle poses
- Walk cycles

## Batch 2: The Modular Tomato "Lego" System (The Hero Asset)
**Goal:** Create stackable segments to build dynamic plants on the cocopeat base.
**Content:**
- All segments designed to tile vertically seamlessly on a grid (e.g., 16x16 or 32x32 blocks).
- **The Base Unit:** The cocopeat slab sitting on the drainage shell with the irrigation tube plugged in. The very bottom of the plant stem starts here.
- **Middle Segments (Stackable):** The core building blocks. Each will have the vertical support string visible.
    - **State A: Pruned Stem** (Just stem and string, bare)
    - **State B: Vegetative** (Stem, string, lush leaves)
    - **State C: Flowering** (Stem, string, leaves, yellow flower clusters)
    - **State D: Fruiting Green** (Stem, string, leaves, small green tomatoes)
    - **State E: Fruiting Red** (Stem, string, leaves, ripe red cherry tomatoes)
- **Top Segments (Caps):** The growing tip that sits on top of the highest middle segment.
    - **State A: Leafy Tip**
    - **State B: Flowering Tip**

## Batch 3: The Greenhouse Structure (Tileset)
**Goal:** Build the environment around the plants.
**Content:**
- White floor cover
- Concrete paths
- Metal frame walls
- Glass texture
- Doors

## Batch 4: Machinery & Equipment
**Goal:** Add the technical details from the diagram.
**Content:**
- Trutina sensor box
- Heat pumps
- Fans
- Water tank
- Hanging yellow traps

## Batch 5: NPCs & UI
**Goal:** Final polish.
**Content:**
- Three workers
- Interface elements
