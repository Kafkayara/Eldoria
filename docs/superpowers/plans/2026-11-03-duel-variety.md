# Eldoria Duel Variety Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans. Implement and verify tasks in order.

**Goal:** Ship the approved nine-card expansion with all cards immediately available.
**Architecture:** Extend the current Dictionary catalog and signal-based duel rules. Keep pending target choices in duel state so UI, AI, and Undo use the same rules. Reuse the existing builder and save format.
**Tech Stack:** Godot 4.7 / GDScript.
**Spec:** ../specs/2026-11-03-duel-variety-design.md, approved by user.

## Global Constraints

34 unique cards; decks remain 20 cards, at most 3 copies, at least 8 monsters. Preserve deck-out, existing saves, story progress, and Undo. No new dependencies or unrelated refactor.

## Review Focus

Target replacement must not redirect effects; pending choices must block other actions; temporary modifiers must expire exactly; recovery must reset stats; old custom decks must remain valid.

## Task 1: Rules and catalog

Files: scripts/catalog.gd, scripts/duel.gd, tests/test_expansion.gd.
Interfaces: choice_options(side), choose_target(side,index), pending_choice; play/respond accept optional Grave target while existing callers remain valid.
- [x] Write and run failing catalog/effect tests.
- [x] Implement all nine effects, target selection, temporary expiry, snapshots, and validation.
- [x] Run expansion and existing duel/strategy/Undo tests.

## Task 2: AI and presets

Files: scripts/ai.gd, scripts/catalog.gd, tests/bench_expansion.gd.
- [x] Test AI can finish duels with every new preset and pending choice.
- [x] Add legal effect choices and public-information scoring; update all presets.
- [x] Compare seeded matchups, check no loops, and tune if necessary.

## Task 3: UI and story

Files: main.gd, scripts/duel_hints.gd, scripts/story_data.gd, tests/test_expansion_ui.gd.
- [x] Test immediate collection access, custom-deck selection, and pending-target input blocking.
- [x] Restore existing builder; add target chooser and readable effect state; add two contextual Nyx comments tracked by Undo.
- [x] Verify old saves and story navigation, including no-trigger chapter completion.

## Task 4: Art and release verification

Files: assets/art, scripts/card_art.gd, presentation mappings and tests, README.md.
- [x] Generate nine unique illustrations, connect art/effects, and inspect rendered UI.
- [x] Run relevant regression suites plus seeded three-deck simulation.
- [x] Fresh review, fix important findings, verify again, then copy changed files back to the authorized project with a backup and change-conflict check.

## Execution notes

Execute inline under the user's existing approval. No extra approval gate for this implementation plan. Work in an isolated filesystem copy because the source directory is outside writable roots. Preserve source changes by comparing hashes before copying. No commits or publishing requested.
