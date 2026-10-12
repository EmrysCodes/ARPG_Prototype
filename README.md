# ARPG Prototype

Mobile Diablo-inspired 3D ARPG for **Xogot 4.7** (Godot 4.7) / Godot 4.7.

## Open in Xogot 4.7

1. Clone or pull this repo (`main`).
2. In Xogot, open **`project.godot` at the repository root** (not a nested folder).
3. Run `scenes/Main.tscn` — project forces **landscape** (**1920×1080**, `sensor_landscape` + runtime pin).
4. Hold iPhone in **landscape** when testing on device.

## What’s included

- Tap-to-move dungeon rooms, inventory, loot, character stats
- Landscape HUD with life/mana orbs, skill bar, XP belt (D2-inspired, original art)
- Five classes with full skill trees (default **Veilwalker**)
- Raise Skeleton: kill enemies → corpses → **Raise** button / **R** → skeleton minions
- Procedural fantasy character meshes (hooded Veilwalker / red brute / bone skeleton) — reliable on Xogot without GLB import

## Camera (Diablo overview)

Camera sits at local offset **(0, 46, 38)**, pitch **≈ −55°**, **FOV 36**. Player should appear small with walls and enemies in view.

## Repo layout

```
project.godot          ← open this
ATTRIBUTION.md
scenes/
scripts/
assets/
themes/
```
