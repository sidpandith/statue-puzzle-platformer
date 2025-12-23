# Phase 1 Testing Guide

## Quick Start

**Run the game:**
1. Open Godot 4.x with the project
2. Press F5 to run
3. Click "Play Test Level" from main menu
4. Test all movement mechanics

## Movement Testing Checklist

### Basic Movement
```
[ ] Walk left with A or Left Arrow
[ ] Walk right with D or Right Arrow
[ ] Character accelerates smoothly (not instant)
[ ] Character decelerates smoothly when releasing keys
[ ] Sprite flips to face movement direction
[ ] Can change direction mid-air
```

### Jumping
```
[ ] Press Space to jump
[ ] Hold Space for maximum height
[ ] Release Space early for shorter jump
[ ] Jump height is consistent
[ ] Can't double jump (unless wall jumping)
[ ] Jump feels responsive (no delay)
```

### Coyote Time Test
```
Test procedure:
1. Walk to edge of a platform
2. Keep walking off the edge (don't jump)
3. Press Space AFTER leaving the platform

Expected: You should still jump for ~0.15 seconds after leaving the edge

[ ] Can jump shortly after leaving platform
[ ] Makes platforming more forgiving
[ ] Doesn't work if you wait too long
```

### Gravity & Physics
```
[ ] Character falls when in air
[ ] Fall speed increases over time
[ ] Fall speed caps at maximum (doesn't accelerate forever)
[ ] Lands properly on platforms
[ ] Doesn't bounce or jitter on landing
```

### Wall Sliding
```
Test procedure:
1. Jump towards one of the red walls
2. Hold movement key towards the wall
3. Observe falling behavior

Expected: Character should slide down slowly, not free-fall

[ ] Falls slower when touching wall
[ ] Can hold against wall while falling
[ ] Releases from wall when moving away
```

### Wall Jumping
```
Test procedure:
1. Jump towards a red wall
2. While touching wall in mid-air, press Space
3. Character should jump away from wall

[ ] Can wall jump from left wall
[ ] Can wall jump from right wall
[ ] Wall jump pushes character away from wall
[ ] Can chain wall jumps (wall climb)
[ ] Wall jump has good horizontal momentum
```

## Advanced Testing

### Jump Buffering
```
Test procedure:
1. Jump in the air
2. Press Space again before landing
3. Character should jump immediately upon landing

Expected: Jump input is "remembered" for 0.1 seconds

[ ] Jump buffer works
[ ] Makes jumping feel more responsive
```

### Variable Jump Height
```
Test procedure:
1. Press and hold Space - measure jump height
2. Press and quickly release Space - measure jump height

Expected: Quick tap = short jump, hold = high jump

[ ] Holding Space = maximum jump
[ ] Tapping Space = short jump
[ ] Noticeable difference in height
[ ] Feels natural and responsive
```

### Movement Tuning
```
Try adjusting these values in the Inspector:
(Select Player node → Inspector → Script Variables)

[ ] Increase speed (try 200) - faster movement
[ ] Decrease speed (try 100) - slower movement
[ ] Increase jump_velocity (try -400) - higher jumps
[ ] Decrease jump_velocity (try -200) - lower jumps
[ ] Increase gravity (try 1500) - faster falling
[ ] Decrease gravity (try 500) - floatier feel
```

## Test Scenarios

### Scenario 1: Basic Platforming
```
1. Start at spawn point
2. Walk right to Platform1
3. Jump onto Platform1
4. Jump from Platform1 to Platform2
5. Jump back down to ground

Expected: All movements feel smooth and responsive
```

### Scenario 2: Coyote Time
```
1. Walk to edge of Platform1
2. Walk off WITHOUT jumping
3. Press Space while falling
4. Should still jump if within 0.15 seconds

Expected: Forgiving platforming, can jump after leaving ledge
```

### Scenario 3: Wall Climbing
```
1. Jump towards left red wall
2. Wall jump to the right
3. Wall jump off right red wall
4. Repeat to "climb" between walls

Expected: Can climb up by alternating wall jumps
```

### Scenario 4: Variable Jump
```
1. Tap Space quickly - note jump height
2. Hold Space fully - note jump height
3. Release Space halfway through jump - note height

Expected: Three different jump heights based on input
```

## Performance Testing

```
[ ] Game runs at stable 60 FPS
[ ] No stuttering or lag
[ ] Smooth movement at all times
[ ] No visual glitches
[ ] Camera follows player smoothly
```

## Console Output Check

When running, console should show:
```
Player initialized
=== Phase 1 Test Level ===
Testing player movement and physics
Controls:
  WASD/Arrows - Move
  Space - Jump (hold for higher jump)
  Wall Jump - Jump while touching red walls
  ESC - Return to menu

Test Features:
  - Horizontal movement with acceleration
  - Gravity and max fall speed
  - Jump with coyote time (grace period after leaving ledge)
  - Variable jump height (release early for shorter jump)
  - Wall sliding and wall jump
```

When jumping, should see:
```
Jump!
```

When wall jumping, should see:
```
Wall jump!
```

## Common Issues & Solutions

### Issue: Player falls through floor
**Check:**
- Ground has StaticBody2D with CollisionPolygon2D
- Player has CollisionShape2D
- Collision layers are set correctly

### Issue: Wall jump not working
**Check:**
- Red walls have collision
- WallRayLeft and WallRayRight are enabled
- You're pressing jump while touching wall (not on ground)
- RayCast2D target_position is correct (±8 units)

### Issue: Movement feels wrong
**Solution:**
- Adjust exported variables in Inspector
- Try these values:
  - Speed: 100-200
  - Acceleration: 600-1000
  - Friction: 800-1200
  - Jump velocity: -250 to -350

### Issue: Coyote time not working
**Check:**
- coyote_time is set (default 0.15)
- Console shows no errors
- Try increasing coyote_time to 0.3 for testing

### Issue: Character jitters on ground
**Solution:**
- Make sure velocity.y is set to 0 when on floor
- Check that is_on_floor() is working correctly

## Success Criteria

Phase 1 is **COMPLETE** if:

✅ All basic movement tests pass  
✅ Jump mechanics work correctly  
✅ Coyote time is functional  
✅ Wall jump works on both walls  
✅ Variable jump height is noticeable  
✅ No errors in console  
✅ Movement feels smooth and responsive  
✅ All test scenarios can be completed  

## What's NOT Expected (Yet)

These features are intentionally missing in Phase 1:
❌ Statue creation
❌ Soft reset
❌ Interactable objects
❌ HUD/timer
❌ Multiple levels
❌ Final art/animations
❌ Sound effects

These will be added in future phases!

---

**If all tests pass, Phase 1 is complete and you're ready for Phase 2!** 🎉
