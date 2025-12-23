# Phase 2 Testing Guide 🧪

## Quick Start
1. Run the project (F5).
2. Click "Play Test Level".
3. Controls: `WASD` to move, `W/Space` to jump, `C` to create statue, `R` to reset.

## Test Checklist

### 1. Statue Creation
```
[ ] Stand on the ground.
[ ] Press 'C'.
[ ] EXPECTED:
    - Player disappears and instantly reappears at the spawn point (240, 200).
    - A gray statue appears exactly where the player was standing.
```

### 2. Statue Physics
```
[ ] Create a statue in mid-air (jump and press C).
[ ] EXPECTED:
    - Statue falls to the ground.
    - Statue falls faster than player (heavy gravity).
    - Player respawns on ground.
```

### 3. Pushing Statues
```
[ ] Stand next to a statue.
[ ] Walk into it.
[ ] EXPECTED:
    - Statue slides horizontally.
    - Statue stops sliding when you stop pushing (friction).
```

### 4. Statue Limit (15)
```
[ ] Create 15 statues around the level.
[ ] Create the 16th statue.
[ ] EXPECTED:
    - The VERY FIRST statue you created disappears.
    - Total count remains at 15.
```

### 5. Level Reset
```
[ ] Create several statues.
[ ] Press 'R'.
[ ] EXPECTED:
    - Player resets to spawn.
    - ALL statues disappear.
```

## Troubleshooting
- **Player doesn't respawn?** Check console for specific error. Ensure `SpawnPoint` is set in TestLevel.
- **Statue doesn't push?** Ensure Player `push_force` is high enough (default 100) and Statue `push_friction` isn't too high.
- **Statues don't disappear on 'R'?** Ensure `StatueManager` is linked in `TestLevel` script.

## Success Criteria
Phase 2 is complete when you can reliably create platforms using statues, climb them, and manage the limit without crashes.
