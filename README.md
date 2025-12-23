# Statue Puzzle Platformer

A cozy, thinky 2D puzzle platformer built with Godot 4 where you can turn into statues to solve puzzles.

## Game Concept

Turn into a statue at any time to:
- Create platforms to reach new heights
- Weigh down pressure plates
- Solve clever puzzles using statue placement

When you turn into a statue, you respawn at the level start while your statue remains. Use up to 15 statues per level to complete increasingly complex puzzles!

## Current Status

**Phase 2: Statue Creation and Management** ✅ COMPLETE

The core puzzle mechanic is implemented:
- Turn into a statue (C/X) to create platforms
- Statue persistence and management (max 15)
- Soft reset mechanics (respawn player, keep statues)
- Statue physics (heavy gravity, pushable)

See [README_PHASE_2.md](src/README_PHASE_2.md) for detailed Phase 2 information.

## Development Phases

- [x] **Phase 0** - Project Setup
- [x] **Phase 1** - Core Character Controller
- [x] **Phase 2** - Statue Creation and Management
- [ ] **Phase 3** - Interactables and Puzzle Hooks
- [ ] **Phase 4** - Level Framework, HUD, and Stars
- [ ] **Phase 5** - Content Creation and Polish
- [ ] **Phase 6** - Optimization, Menus, and Final Touches

## How to Run

1. Install [Godot 4.x](https://godotengine.org/download)
2. Open Godot and click **Import**
3. Navigate to `src/` folder and select `project.godot`
4. Click **Import & Edit**
5. Press **F5** to run

## Project Structure

```
statue-game/
├── design/              # Game design documents
│   └── specifications.md
├── src/                 # Godot project root
│   ├── scenes/         # Game scenes
│   ├── scripts/        # GDScript files
│   ├── art/            # Sprites and tilesets
│   └── audio/          # Sound effects and music
├── logs/               # Development logs
└── TESTING_PHASE_0.md  # Testing guide
```

## Controls

- **Movement**: WASD or Arrow Keys
- **Jump**: W or Up Arrow
- **Interact**: Space or Z
- **Turn to Statue**: C or X
- **Restart Level**: R

## License

This project is being developed as a learning exercise. License TBD.

## Credits

Developed by a high school student learning Godot game development.

---

**Current Version**: Phase 0 - Project Setup Complete
