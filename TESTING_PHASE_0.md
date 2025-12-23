# Phase 0 Testing Guide

## Quick Start

**Open the project in Godot:**
1. Launch Godot 4.x
2. Import → Navigate to `~/src/godot/statue-game/src/`
3. Select `project.godot` → Import & Edit
4. Press F5 to run

## What to Test

### 1. Main Menu (Startup)
**Expected behavior:**
- Window opens at 1440x810 pixels
- Main menu displays with:
  - Title: "STATUE GAME"
  - Subtitle: "Phase 0 - Project Setup"
  - "Play Test Level" button
  - "Quit" button
  - Debug label: "Phase 0 Complete"

**Console output should show:**
```
GameState initialized
SceneLoader initialized
Main Menu loaded
GameState total stars: 0
```

### 2. Scene Transition
**Test:** Click "Play Test Level" button

**Expected behavior:**
- Screen fades to black (0.3 seconds)
- Test level loads
- Screen fades in from black
- Smooth transition, no jarring cuts

### 3. Test Level Display
**Expected visual elements:**
- Light blue background
- Green ground platform at bottom
- Two brown platforms at different heights
- UI text showing:
  - "PHASE 0 TEST LEVEL"
  - "Project Setup Complete!"
  - "Press ESC to return to menu"
  - Input test instructions

**Console output should show:**
```
Test Level loaded
Testing autoloads...
  - GameState: <Node#...>
  - SceneLoader: <Node#...>
  - Total stars: 0
```

### 4. Input Testing
**Test each input and verify console output:**

| Input | Keys | Expected Console Output |
|-------|------|------------------------|
| Move Left | A or ← | "Move Left pressed" |
| Move Right | D or → | "Move Right pressed" |
| Move Up | W or ↑ | "Move Up pressed" |
| Move Down | S or ↓ | "Move Down pressed" |
| Jump | Space | "Jump pressed" |
| Interact | Space or Z | "Interact pressed" |
| Statue | C or X | "Statue pressed" |
| Restart | R | "Restart Level pressed" |

**Note:** Space triggers both "Jump pressed" AND "Interact pressed" - this is correct!

### 5. Return to Menu
**Test:** Press ESC in test level

**Expected behavior:**
- Screen fades to black
- Main menu loads
- Screen fades in
- Console shows: "Returning to main menu..."

### 6. Quit Function
**Test:** Click "Quit" button on main menu

**Expected behavior:**
- Game closes immediately
- Console shows: "Quitting game..."

## Verification Checklist

Copy this checklist and mark items as you test:

```
PHASE 0 VERIFICATION
====================

Project Configuration:
[ ] Game launches without errors
[ ] Window size is 1440x810
[ ] Graphics look crisp (not blurry)
[ ] No missing resource errors

Autoloads:
[ ] GameState initializes (check console)
[ ] SceneLoader initializes (check console)
[ ] No autoload errors in console

Input Mappings (all 8 actions):
[ ] Move Left (A, Left Arrow)
[ ] Move Right (D, Right Arrow)
[ ] Move Up (W, Up Arrow)
[ ] Move Down (S, Down Arrow)
[ ] Jump (Space)
[ ] Interact (Space, Z)
[ ] Statue (C, X)
[ ] Restart (R)

Scene System:
[ ] Main menu loads on startup
[ ] "Play Test Level" loads test level
[ ] Fade transitions work smoothly
[ ] ESC returns to main menu
[ ] "Quit" button closes game

Project Structure:
[ ] All folders exist (scenes, scripts, art, audio)
[ ] Scripts organized in /scripts/
[ ] Scenes organized in /scenes/
[ ] Autoloads in /scripts/autoloads/

Overall:
[ ] No errors in console
[ ] No warnings (or only expected ones)
[ ] All features work as described
```

## Common Issues & Solutions

### Issue: "Cannot open project.godot"
**Solution:** Make sure you're importing from the `/src/` folder, not the parent directory.

### Issue: Input not registering
**Solution:** 
1. Check that you're in the test level (not main menu)
2. Make sure Godot window has focus
3. Check Output console for errors

### Issue: Blurry graphics
**Solution:** 
1. Go to Project → Project Settings → Rendering
2. Verify "Textures → Canvas Textures → Default Texture Filter" is set to "Nearest"

### Issue: Autoload errors
**Solution:**
1. Project → Project Settings → Autoload
2. Verify both autoloads are present and enabled:
   - GameState: `res://scripts/autoloads/game_state.gd`
   - SceneLoader: `res://scripts/autoloads/scene_loader.gd`

### Issue: Scene transition doesn't fade
**Solution:** This is normal - fade overlay is created but may not be visible on first load. Try transitioning between scenes multiple times.

## Success Criteria

Phase 0 is **COMPLETE** if:
✅ All items in verification checklist pass
✅ No errors in Godot console
✅ All 8 input actions work correctly
✅ Scene transitions work smoothly
✅ Autoloads initialize properly

## What's NOT Expected (Yet)

These features are intentionally missing in Phase 0:
❌ Player character movement
❌ Physics/gravity
❌ Statue creation
❌ Puzzle elements
❌ Art assets
❌ Sound effects
❌ Actual game levels

These will be added in future phases!

---

**If all tests pass, Phase 0 is complete and you're ready for Phase 1!** 🎉
