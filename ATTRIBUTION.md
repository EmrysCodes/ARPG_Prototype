# Attribution & Licenses

This project is an original Diablo-inspired ARPG prototype. It does **not** include Blizzard / Diablo trademarks, logos, ripped game files, or exact proprietary fonts.

## Characters

| Asset | Use | Source | License |
| --- | --- | --- | --- |
| `assets/characters/player/veilwalker.glb` (+ texture) | Player visual (Veilwalker) | [Kenney Blocky Characters 2.0](https://www.kenney.nl/assets/blocky-characters) (`character-m`) | **CC0 1.0** — see `assets/characters/licenses/KENNEY_BLOCKY_CHARACTERS_LICENSE.txt` |
| `assets/characters/enemy/dungeon_brute.glb` (+ texture) | Enemy visual | Kenney Blocky Characters 2.0 (`character-r`) | **CC0 1.0** |
| `assets/characters/minion/skeleton_minion.glb` (+ texture) | Raise Skeleton minion | [KayKit Character Pack — Skeletons](https://github.com/KayKit-Game-Assets/KayKit-Character-Pack-Skeletons-1.0) (`Skeleton_Minion`) by Kay Lousberg | **CC0 1.0** — see `assets/characters/licenses/KAYKIT_SKELETONS_LICENSE.txt` |

Capsule placeholders remain in scenes as fallbacks if a GLB fails to import; `scripts/visual/model_loader.gd` hides them when the GLB loads.

**Animation follow-up:** Kenney/KayKit packs include animations. This pass wires static meshes (idle pose from GLB). Hooking AnimationPlayer walk/attack clips is deferred.

## Fonts

| Asset | Use | Source | License |
| --- | --- | --- | --- |
| `assets/fonts/Cinzel-Variable.ttf` | Display / HUD titles (optional theme use) | [Cinzel](https://github.com/google/fonts/tree/main/ofl/cinzel) | **SIL OFL 1.1** — `assets/fonts/OFL-Cinzel.txt` |
| `assets/fonts/CormorantGaramond-Variable.ttf` | Body / panel text (optional) | [Cormorant Garamond](https://github.com/google/fonts/tree/main/ofl/cormorantgaramond) | **SIL OFL 1.1** — `assets/fonts/OFL-CormorantGaramond.txt` |

## Original project art

| Asset | Notes |
| --- | --- |
| `assets/ui/*.png` | Original HUD chrome (orbs, belt, skill slot, icons) generated for this pass |
| `assets/dungeon/stone_floor.png`, `stone_wall.png` | Original dungeon tiles generated for this pass |
| `assets/icons/items/*`, `inv.png`, `assets/level_01.png` | Pre-existing prototype art |

## Inspiration (no assets copied)

UI/camera language is **inspired by** classic isometric ARPGs (life/mana orbs, bottom belt, rarity color hierarchy, gothic dungeon mood). All chrome, names, and art in-repo are original or third-party **CC0 / OFL** as listed above.
