extends RefCounted
class_name RarityColors
## Diablo-inspired rarity palette (original colors; not Blizzard assets).

const COMMON := Color(0.86, 0.86, 0.86)
const MAGIC := Color(0.45, 0.55, 1.0) ## blue — used for "Rare" in current dropper (magic-tier)
const RARE := Color(1.0, 0.92, 0.35) ## yellow
const EPIC := Color(0.72, 0.35, 0.95) ## purple
const LEGENDARY := Color(0.95, 0.55, 0.12) ## gold/orange
const SET := Color(0.25, 0.85, 0.35) ## green (reserved)
const GOLD := Color(0.95, 0.82, 0.28)
const UI_GOLD := Color(0.82, 0.68, 0.35)
const UI_TEXT := Color(0.88, 0.82, 0.72)
const UI_DIM := Color(0.55, 0.5, 0.42)
const LIFE := Color(0.75, 0.12, 0.1)
const MANA := Color(0.2, 0.35, 0.85)


static func for_rarity(rarity: String) -> Color:
	match rarity:
		"Common", "Normal":
			return COMMON
		"Magic":
			return MAGIC
		"Rare":
			# Current loot table uses Rare as the mid tier (blue in old UI).
			# Prefer classic rare yellow for stronger D2 read.
			return RARE
		"Epic":
			return EPIC
		"Legendary", "Unique":
			return LEGENDARY
		"Set":
			return SET
		_:
			return COMMON
