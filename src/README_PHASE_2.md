# Phase 2: Statue Creation and Management 🗿

## Overview
Phase 2 introduces the core puzzle mechanic: turning into a statue. This allows the player to create platforms, hold buttons (future), and solve spatial puzzles.

## Features Implemented

### 1. Statue Mechanic
- **Creation**: Press `C` or `X` to turn into a statue.
- **Result**:
  - A stone copy of the player is created at the current location.
  - The player is instantly **respawned** at the level start (Soft Reset).
  - The statue remains as a permanent object in the world.

### 2. Statue Physics
- **Heavy Gravity**: Statues fall faster than the player (gravity 1500 vs 980).
- **Pushable**: The player can push statues horizontally.
- **Friction**: Statues have high friction and will stop sliding when not pushed.

### 3. Statue Management
- **Limit**: Maximum of **15** statues can exist at once.
- **FIFO**: If a 16th statue is created, the oldest one is removed.
- **Manager**: A `StatueManager` node tracks all statues in the level.

### 4. Level Systems
- **Soft Reset**: Creating a statue respawns the player but keeps the world state (statues).
- **Hard Reset**: Pressing `R` reloads the level state, clearing ALL statues.

## Controls
- **WASD / Arrows**: Move and Jump
- **C / X**: Turn into Statue (and respawn)
- **R**: Restart Level (clears all statues)

## Technical Details
- **Statue Scene**: `res://scenes/interactables/statue.tscn` (CharacterBody2D)
- **Manager Script**: `res://scripts/managers/statue_manager.gd`
- **Player Updates**: Added `statue_scene` instancing and pushing logic.

## Known Issues / Future Work
- Statue sprite is currently a tinted placeholder.
- No sound effects for creation/pushing yet.
- Interactive buttons/doors will be added in Phase 3.
