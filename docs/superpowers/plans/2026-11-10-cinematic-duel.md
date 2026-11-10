# Eldoria 2.5D implementation plan

Goal: selective cinematic 2.5D presentation using existing original art, Godot 4.7 Compatibility, and no new dependencies.
Spec: ../../animation-research-2026-11-10.md; user selected 2.5D and explicitly requested immediate implementation.

## Constraints and decisions
- Preserve local uncommitted hand-selection/description-scroll changes; edit the provided project in place so F5 uses the result. Do not stage or commit those changes.
- Keep rules, saved decks, story, audio tempo and reduced-motion behavior intact.
- Use a perspective shader on the illustration only; procedural atmospheric foreground/background layers provide depth without replacing the original characters or pretending they are rigged 3D models.
- Capture animation speed at creation, matching existing VFX events. New actions use the new selected speed.
- Reuse session cancellation and visual cleanup for Undo/restart; no new global time scale.

## Tasks
- [x] Test first: ace remains visible for the new 1.9-second choreography, expires and releases input, does not repeat, resets safely, respects reduced motion and 2x; test impact feedback/finisher and cleanup.
- [x] Replace scripts/ace_cutin.gd with large illustration perspective stage, distinct fire/eclipse/root choreography and readable stationary title; add scripts/shaders/card_depth.gdshader.
- [x] Improve main.gd summon/attack/target/trap motion and impact-timed audio; enrich scripts/effects.gd impact with power-scaled rings, streaks and localized light; add short outcome flourish.
- [x] Verify new tests, existing presentation/VFX/Undo/trap/comfort/input tests, then all test_*.gd scripts. Render and inspect three aces and combat using native Godot captures.
- [x] Independent review of final changes; resolve material findings; document exact checks and limitations.

## Review focus
- Undo during cinematic/impact must stop old callbacks and restore source visibility.
- Reduced motion during a cinematic must remove it and restore input.
- Shield/negate must not trigger false destruction or false lethal presentation.
- Both sides and all three aces must retain correct owner, stats and artwork.
- UI remains legible at 1280x720; effects do not show through modal panels.

## Execution record
- Baseline runtime recovered using explicit writable --log-file; test_duel: 13228 checks, zero failures, 100 complete duels.
- Red-green: initial cinematic test failed four intended expectations (three new reveal durations and missing finisher); final extended test passes 20 checks, including shield/DEF and delayed nonlethal combat.
- Independent reviewer found shader alpha bypass; fixed with vertex modulation passed through a varying. Also corrected summon tween sequencing. All three aces and finisher rendered and inspected using native OpenGL Compatibility on AMD Radeon, with no shader errors.
- Removed visible scrim strip seams and confined finisher waves to the arena. Reference screenshot: ../../media/cinematic-ember.png.
- Initial shared-profile tests inherited preferences. Separate APPDATA directories under the sandbox-provided TEMP then caused save/reload failures. Explicit isolated directories under C:/Users/Kafka/AppData/Local/Temp restore successful save/reload tests without changing persistence code.
- Final full run: all 29 test scripts exited 0, no errors or warnings. Includes cinematic 20, presentation 22, VFX 378 / 34 profiles, Undo UI 15, comfort 25, and trap 37 checks. Logs: C:/Users/Kafka/AppData/Local/Temp/eldoria-check-ff369cf8. Native render also exited 0. git diff --check passed.
