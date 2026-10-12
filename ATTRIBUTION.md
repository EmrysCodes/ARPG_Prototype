# Attribution & Licenses

This project is an original Diablo-inspired ARPG prototype. It does **not** include Blizzard / Diablo trademarks, logos, ripped game files, or exact proprietary fonts.

## Characters (current visuals)

Player, enemy, and skeleton minion visuals are **original procedural MeshInstance3D assemblies** built at runtime by `scripts/visual/model_loader.gd` (capsules / boxes / spheres with `StandardMaterial3D`). No third-party character meshes are required at runtime.

| Role | Style enum | Look |
| --- | --- | --- |
| Player | `VEILWALKER` | Hooded purple caster + staff gem |
| Enemy | `BRUTE` | Red bulky fighter + iron helm/horns |
| Minion | `SKELETON` | Bone limbs + glowing green eyes |

Capsule placeholders remain in scenes as editor fallbacks; the builder hides them when the procedural mesh is ready.

## Archived CC0 GLBs (unused at runtime)

Earlier Kenney / KayKit GLBs remain under `assets/characters/` for reference but are **not loaded**. On Xogot 4.7 they imported as white untextured blocks / T-poses (external texture URIs + required `KHR_materials_unlit`).

| Asset | Source | License |
| --- | --- | --- |
| `assets/characters/player/veilwalker.glb` (+ texture) | [Kenney Blocky Characters 2.0](https://www.kenney.nl/assets/blocky-characters) | **CC0 1.0** — `assets/characters/licenses/KENNEY_BLOCKY_CHARACTERS_LICENSE.txt` |
| `assets/characters/enemy/dungeon_brute.glb` (+ texture) | Kenney Blocky Characters 2.0 | **CC0 1.0** |
| `assets/characters/minion/skeleton_minion.glb` (+ texture) | [KayKit Skeletons](https://github.com/KayKit-Game-Assets/KayKit-Character-Pack-Skeletons-1.0) | **CC0 1.0** — `assets/characters/licenses/KAYKIT_SKELETONS_LICENSE.txt` |

## Fonts

| Asset | Use | Source | License |
| --- | --- | --- | --- |
| `assets/fonts/Cinzel-Variable.ttf` | Display / HUD titles (optional theme use) | [Cinzel](https://github.com/google/fonts/tree/main/ofl/cinzel) | **SIL OFL 1.1** — `assets/fonts/OFL-Cinzel.txt` |
| `assets/fonts/CormorantGaramond-Variable.ttf` | Body / panel text (optional) | [Cormorant Garamond](https://github.com/google/fonts/tree/main/ofl/cormorantgaramond) | **SIL OFL 1.1** — `assets/fonts/OFL-CormorantGaramond.txt` |

## Original project art

| Asset | Notes |
| --- | --- |
| `assets/ui/*.png` | Original HUD chrome (orbs, belt, skill slot, panel frame) |
| `assets/dungeon/stone_floor.png`, `stone_wall.png` | Original dungeon tiles (brightened for readability) |
| `assets/icons/items/*`, `inv.png`, `assets/level_01.png` | Pre-existing prototype art (`inv.png` no longer used as panel chrome) |

## Inspiration (no assets copied)

UI/camera language is **inspired by** classic isometric ARPGs (life/mana orbs, bottom belt, rarity color hierarchy, gothic dungeon mood). All chrome, names, and art in-repo are original or third-party **CC0 / OFL** as listed above.
