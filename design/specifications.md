Here is a detailed, phase-based specification you can hand to an AI coding agent to build this game in Godot, step by step.[1][2][3]

***

## High-level game spec

- **Engine**: Godot 4.x, 2D project.[3]
- **Genre**: Cozy, thinky 2D puzzle platformer.  
- **Core mechanic**: Player can turn into a statue at any time.  
  - When turning into a statue:
    - A **new statue** is created at the player’s position, with the player’s current facing and animation frame, then frozen.  
    - The **player respawns** at the level’s spawn point (soft reset).  
- **Soft reset rules**:
  - **Reset**: Buttons, switches, doors, pushable blocks and other interactive objects return to their default state.  
  - **Persist**: Statues remain where they were created and keep their physical effects (e.g., pressing buttons, weighing platforms).  
  - **Unaffected**: Moving platforms, enemies, projectiles, environmental hazards (like saws) keep their current positions and velocities.  
- **Statue rules**:
  - Statues are exact stone versions of the player sprite.  
  - Statues are affected by gravity and are heavier than the player (fall faster, exert more force on physics objects).  
  - Statues are solid colliders and can be:
    - Stood on.
    - Used as platforms to gain extra height.
    - Used as weights on pressure plates / platforms.
    - Pushed like heavy pushable blocks.  
  - Player can create up to **15 statues** in a level; creating a 16th removes the **oldest** statue.  
  - Restarting a level or loading another level **removes all statues**.

- **Input**:
  - Movement: **WASD** and **arrow keys** (both mapped).  
  - Jump: e.g., **Space**.  
  - Interact: **Space** or **Z** (same action).  
  - Turn into statue: dedicated key (e.g., **C** or **X**).  
  - Restart level: **R**.  

- **Movement**:
  - Player uses `CharacterBody2D`. Godot-standard horizontal movement with gravity and jump.[2]
  - Abilities:
    - Run, jump, wall jump.  
    - Coyote time: 3–5 frames after leaving a ledge where jump is still valid.  
    - Fairly tight but not punishing wall jumps (tuned later).  

- **World and visuals**:
  - Warm, overgrown ancient ruins.  
  - Plants, mossy bricks, soft ambient music.  
  - 2D pixel art, low-res tilemaps, simple lighting/ambient shading.  

- **Structure and goals**:
  - 10–15 levels for first release.  
  - Levels grouped into themed **worlds** (e.g., Courtyard, Sunken Halls, Sky Temple).  
  - **Exit door** at the end of each level; reaching it completes the level.  
- **Stars / progression**:
  - Each level has **4 stars**:
    - 3 stars based on **statue usage**:
      - Example thresholds (per level, configurable):  
        - 3 stars: use ≤ N_statues_3.  
        - 2 stars: use ≤ N_statues_2.  
        - 1 star: level completion.  
    - 1 star based on **time**:
      - Complete level within a target time (per-level value).  
  - Constraints are visible during play:
    - HUD shows:  
      - Statues used / thresholds (e.g., `Statues: 2 (≤3 for 3★)`).  
      - Timer and time-star target (e.g., `Time: 00:20 / 00:30`).  
  - Progression:
    - Stars **gate worlds/levels** (e.g., World 2 requires 20 stars).  
    - Game remembers **best per-star completion across runs**:
      - If a player once earns the time star and later earns a better statue count, both are permanently recorded.  

- **Softlock policy**:
  - It is allowed to create **softlock situations** (e.g., blocking a critical passage with statues).  
  - Player can always press **Restart** to reset the level (clearing statues).  

***

## Phase 0 – Project setup

**Goal**: Create a clean Godot 4 project oriented for a 2D puzzle platformer, with basic structure and autoloads in place.[3]

### Requirements

1. **Project configuration**
   - New Godot 4 project, 2D.  
   - Setup:
     - Display resolution and stretch mode appropriate for pixel art (e.g., 320x180 or 480x270, scaled up).  
     - Enable pixel snap / correct filtering for crisp sprites.  

2. **Autoloads (singletons)**
   - `GameState`:
     - Tracks unlocked levels, stars per level, and global options.
   - `SceneLoader`:
     - Handles loading/unloading scenes and transitions (optional fade).  

3. **Input map**
   - Define these actions:
     - `"move_left"` → A, Left.  
     - `"move_right"` → D, Right.  
     - `"move_up"` → W, Up (for ladders/menus).  
     - `"move_down"` → S, Down.  
     - `"jump"` → Space.  
     - `"interact"` → Space, Z.  
     - `"statue"` → C, X.  
     - `"restart_level"` → R.  
     - `"ui_accept"`, `"ui_cancel"` for menus, mapped as usual.  

4. **Project folders**
   - Use a clear structure:
     - `res://scenes/`  
       - `player/`  
       - `levels/`  
       - `ui/`  
       - `world/`  
       - `interactables/`  
       - `environment/`  
     - `res://scripts/`  
     - `res://art/`  
       - `tilesets/`  
       - `characters/`  
       - `props/`  
     - `res://audio/`  

***

## Phase 1 – Core character controller

**Goal**: Implement a solid, reusable 2D platformer character with run, jump, wall jump, gravity, and coyote time.[4][2]

### Requirements

1. **Player scene**
   - Node setup:
     - `Player` (extends `CharacterBody2D`).
       - `Sprite2D` or `AnimatedSprite2D` for the pixel-art player.  
       - `CollisionShape2D` for body.  
       - Optional: `RayCast2D` or similar helpers for wall detection.  
   - Script: `Player.gd`.
     - Exported variables:
       - `speed` (horizontal speed).  
       - `jump_velocity`.  
       - `gravity`.  
       - `max_fall_speed`.  
       - `coyote_time_frames` (e.g., 3–5).  
       - `wall_jump_velocity` (vector or components).  
     - State fields:
       - `velocity: Vector2`.  
       - `coyote_timer` in seconds or frames.  
       - `jump_buffer_timer` (optional, to buffer jump input).  
       - Flags for `is_on_wall`, `wall_direction`.  

2. **Movement behavior**
   - Horizontal:
     - Read `Input.get_axis("move_left","move_right")` and apply to `velocity.x`.  
     - Optionally smooth acceleration/deceleration.  
   - Gravity:
     - Each physics frame, add `gravity * delta` to `velocity.y` up to `max_fall_speed`.  
   - Ground detection & coyote time:
     - Use `is_on_floor()` from `CharacterBody2D` to reset `coyote_timer`.  
     - Allow jump if either:
       - On floor, or  
       - `coyote_timer > 0`.  
   - Jump:
     - On `Input.is_action_just_pressed("jump")`, if allowed, set `velocity.y = jump_velocity`.  
   - Wall detection & wall jump:
     - Detect contact with walls on left/right based on collision results or raycasts.  
     - Allow wall jump when:
       - Not on floor, touching wall, and `jump` pressed.  
     - Wall jump sets `velocity.y` and horizontal component away from the wall.  

3. **Simple test level**
   - Create a test scene:
     - `MainTest` with a `TileMap` for ground.  
     - Add `Player` and set starting position.  
   - Verify:
     - Walking, jumping, wall jumping feel responsive.  
     - Coyote time works.  

***

## Phase 2 – Statue creation and management

**Goal**: Implement the statue mechanic, soft reset behavior, and statue limits.

### Requirements

1. **Statue scene**
   - `Statue` (extends `CharacterBody2D` or `RigidBody2D`; use `CharacterBody2D` for consistency).  
   - Node setup:
     - `Sprite2D` or `AnimatedSprite2D` (re-use player sprite with stone palette/overlay).  
     - `CollisionShape2D`.  
   - Behavior:
     - No active input; it is static except for gravity and external pushes.  
     - Uses its own `gravity` and `max_fall_speed` adjusted higher than player (falls faster, feels heavier).  
     - Can be pushed horizontally by the player:
       - Treat as a heavy moveable object with friction.  

2. **Statue creation from player**
   - In `Player.gd`:
     - On `Input.is_action_just_pressed("statue")`:
       - Instantiate a `Statue` instance.  
       - Set its position to player’s current position.  
       - Copy facing direction for appropriate sprite orientation.  
       - Add it to the current level scene under a container node (e.g., `StatuesRoot`).  
       - Notify a statue manager to register the new statue.  
       - Call a function to perform a soft reset:
         - Reset player to spawn position.  
         - Reset interactive objects.  
         - Do **not** reset moving platforms/enemies.  

3. **Statue manager**
   - Create `StatueManager` script or a node in each level:
     - Maintains an ordered list/array of active statues.  
     - On adding new statue:
       - Append to list.  
       - If list length > 15, remove and free the **oldest** instance.  
   - Provides:
     - `reset_statues()` for full clearing (used on level restart/load).  

4. **Soft reset implementation**
   - Define an interface for interactive objects (buttons, switches, doors, pushable blocks), e.g., using groups:
     - Each interactive object implements `reset_state()` method or is in `"resettable"` group and responds to a signal.  
   - When player becomes a statue:
     - Emit a signal or call a function that:
       - Resets all interactive objects to their default state.  
       - Respawns player at designated spawn point.  
       - Leaves statues and non-interactive moving elements unchanged.  

5. **Level restart**
   - On `restart_level` input:
     - Reload current scene or call a level `reset_level()` method that:
       - Resets all interactive objects.  
       - Clears statues via `StatueManager`.  
       - Resets moving platforms/enemies to initial positions.  
       - Resets player to spawn.  

***

## Phase 3 – Interactables and puzzle hooks

**Goal**: Implement the core building blocks for puzzles: buttons, switches, doors, pushable blocks, and basic moving platforms.[5][6]

### Requirements

1. **Buttons (pressure plates)**
   - `Button` scene:
     - Area/Collision: triggered when something stands on it.  
     - Detects both player and statues (and optionally pushable blocks).  
   - Behavior:
     - When pressed:
       - Emits a signal (e.g., `pressed`) with a value `true`.  
     - When released:
       - Emits `pressed` with `false`.  
   - Reset:
     - On `reset_state()`:
       - Return to default (usually unpressed).  

2. **Switches (toggle levers)**
   - `Switch` scene:
     - Interacts on `interact` action when player is within an Area2D.  
   - Behavior:
     - Toggles between ON/OFF when activated.  
     - Emits `switched(is_on: bool)`.  
   - Reset:
     - On `reset_state()`, return to default ON or OFF depending on level design.  

3. **Doors**
   - `Door` scene:
     - Listens to one or more `Button` and/or `Switch` signals.  
   - Behavior:
     - Opens or closes based on configured logic (e.g., open when button pressed, or all switches ON).  
     - Uses `CollisionShape2D` and sprite changes.  
   - Reset:
     - On `reset_state()`, return to default closed/open state.  

4. **Pushable blocks**
   - `PushableBlock` scene, similar to heavy crate:
     - Uses `CharacterBody2D` or `RigidBody2D`.  
     - Can be pushed by player or by other moving bodies.  
   - Reset:
     - On `reset_state()`, snap back to original placed position.  

5. **Moving platforms and hazards**
   - `MovingPlatform`:
     - Follows a path or ping-pong motion.  
     - **Not** reset by statue soft reset; only on full level restart.  
   - Basic hazards (e.g., spikes):
     - Kill player on contact → respawn without statues reset unless player chooses to turn into statue or restart.  

***

## Phase 4 – Level framework, HUD, and stars

**Goal**: Build a reusable level template scene that handles spawn, HUD, soft reset, stars, and exit logic.

### Requirements

1. **Level scene template**
   - Structure:
     - `LevelBase` (Node2D):
       - `TileMap` for environment.  
       - `PlayerSpawn` (Position2D/Marker2D).  
       - `Player` instance.  
       - `StatuesRoot` node.  
       - `InteractiveRoot` (children: buttons, switches, doors, blocks).  
       - `MovingRoot` (moving platforms, enemies).  
       - `ExitDoor` (level completion trigger).  
       - `HUD` (CanvasLayer).  
   - Script:
     - Holds per-level data:
       - `statue_star_thresholds = [3, 6]` (for example).  
       - `time_star_threshold = 30.0` (seconds).  
     - Tracks:
       - `statues_used` (counter).  
       - `level_timer`.  
       - `completed`.  

2. **Statue usage tracking**
   - Each time player turns into statue and successfully creates one:
     - Increment `statues_used`.  
   - HUD displays `statues_used` and thresholds.  

3. **Timer and HUD**
   - `HUD`:
     - Displays:
       - Current time in seconds (formatted).  
       - Current `statues_used`.  
       - Star indicators:
         - 3 statue-based stars.
         - 1 time-based star.  
   - HUD reacts when thresholds are met (e.g., light up stars).  

4. **Level completion and star awarding**
   - When `ExitDoor` is triggered by player:
     - Level ends, `completed = true`.  
     - Evaluate stars:
       - 1 star: completion.  
       - Additional statue stars based on thresholds.  
       - Time star if `level_timer <= time_star_threshold`.  
     - Compare to existing best record in `GameState`:
       - Store per-level star flags so once a star is earned, it remains unlocked.  
   - After completion:
     - Show a simple results screen:
       - Stars earned this run, which stars are now unlocked total.  
       - Options: `Retry`, `Next Level`, `Level Select`.  

5. **World / level select**
   - Create a simple **world map / level select** scene:
     - Shows worlds and levels as buttons.  
     - Buttons locked/unlocked based on star count.  

***

## Phase 5 – Content creation and polish

**Goal**: Build 10–15 levels grouped into a few worlds, with a clear puzzle progression using the statue mechanic.

### Requirements

1. **World themes**
   - World 1: “Overgrown Courtyard”  
     - Very simple layouts, focus on teaching:
       - Basic movement, jump, wall jump.  
       - Turning into a statue and using it as a platform.  
   - World 2: “Sunken Halls”  
     - Introduce more complex puzzles:
       - Buttons, doors, multiple statues usage.  
       - Pushing statues onto buttons to hold doors.  
   - World 3: “Sky Temple” (for later levels):
     - Verticality and moving platforms.  
     - Time-based challenges leveraging persistent moving platforms between soft resets.  

2. **Teaching progression**
   - Early levels:
     - One or two short rooms per level.  
     - One clear use of the statue (e.g., reach a higher ledge, hold down one button).  
   - Later levels:
     - Combine:
       - Height gain via statues.  
       - Weight-based puzzles (statues vs player vs blocks).  
       - Sequencing soft resets to affect interactive objects while moving platforms continue.  

3. **Softlock tolerance**
   - Ensure there are ways to softlock:
     - E.g., push a statue into a corner blocking progress.  
   - Restart instructions:
     - On-screen hint: “Press R to restart if stuck”.  

4. **Audio and ambiance**
   - Add soft, loopable background track per world.  
   - Simple jump and interaction sounds.  

5. **Polish**
   - Particle effects when turning into a statue.  
   - Short camera shake or vignette when soft resetting.  
   - Smooth transitions between levels.  

***

## Phase 6 – Optimization, menus, and final touches

**Goal**: Make the project pleasant to use and ready for a small free release.

### Requirements

1. **Main menu**
   - Options:
     - `Play`, `Level Select`, `Options`, `Quit`.  
   - Options menu:
     - Volume sliders (music, SFX).  
     - Maybe toggle for timer visibility.  

2. **Save system**
   - Persist:
     - Stars earned per level.  
     - Unlocked worlds.  
     - Options settings.  
   - Use Godot’s `ConfigFile` or JSON in user data.  

3. **Performance and best practices**
   - Ensure levels are cleanly structured with separate scenes and reused components.[1][3]
   - Avoid unnecessary physics or script work when off-screen.  

4. **Build and export**
   - Export templates for your target platforms (likely PC).  
   - Test fresh builds of the game.  

***

This specification is designed so an AI coding agent can work **incrementally**: complete Phase 0, then Phase 1, and so on, verifying at each step that the described behavior exists and passes simple tests (e.g., “player can move and wall jump; statue creation performs soft reset with correct object behavior”).

[1](https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html)
[2](https://kidscancode.org/godot_recipes/4.x/2d/platform_character/)
[3](https://docs.godotengine.org/en/4.4/tutorials/best_practices/)
[4](https://indiegameacademy.com/how-to-make-a-smooth-movement-system-for-a-2d-platformer-in-godot/)
[5](https://www.youtube.com/watch?v=Fan-rzeEYQs)
[6](https://docs.godotengine.org/en/3.5/tutorials/physics/using_kinematic_body_2d.html)
[7](https://www.reddit.com/r/godot/comments/lm3kfx/what_are_the_best_practices_for_optimising_levels/)
[8](https://www.youtube.com/watch?v=oED12Mo2018)
[9](https://forum.godotengine.org/t/godot-4-modular-2d-platformer-movement/45870)
[10](https://www.youtube.com/watch?v=pnBioV2HkS8)
[11](https://www.youtube.com/watch?v=spp6NrRKDtU)
[12](https://dev.to/christinec_dev/learn-godot-4-by-making-a-2d-platformer-part-4-level-creation-1-4obb)
[13](https://www.youtube.com/watch?v=rOA8i_clm1Y)
[14](https://www.youtube.com/watch?v=K_K45M8NxuA)
[15](https://www.reddit.com/r/godot/comments/1fzd4hm/how_to_make_a_puzzle_building_game/)
[16](https://www.youtube.com/playlist?list=PLGZeG39sIjYt_lZQijk3pFw5FyhZfzlTO)
[17](https://forum.godotengine.org/t/asking-for-advice-on-how-to-structure-3d-puzzle-project/19426)
[18](https://docs.godotengine.org/en/3.6/tutorials/physics/using_kinematic_body_2d.html)
[19](https://forum.godotengine.org/t/new-to-godot-and-want-to-know-how-to-make-a-simple-2d-puzzle-game/48187)
[20](https://www.youtube.com/watch?v=mKlKMBSM2Ss)