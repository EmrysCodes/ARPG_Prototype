extends Node

const GOLD_SCENE = preload("res://scenes/loot/GoldPickup.tscn")
const ITEM_SCENE = preload("res://scenes/loot/ItemPickup.tscn")

@export var gold_drop_chance: int = 80
@export var item_drop_chance: int = 25
@export var rare_bonus: int = 0

func drop_loot(drop_position: Vector3):
	var enemy = get_parent()
	var monster_level = 1

	if enemy and "monster_level" in enemy:
		monster_level = enemy.monster_level

	var loot_table = get_loot_table(monster_level)

	roll_gold(drop_position, monster_level)
	roll_item(drop_position, monster_level, loot_table)

func get_loot_table(monster_level: int) -> Array:
	if monster_level <= 5:
		return get_early_dungeon_table()

	if monster_level <= 15:
		return get_mid_dungeon_table()

	return get_late_dungeon_table()

func roll_gold(drop_position: Vector3, monster_level: int):
	var roll = randi_range(1, 100)

	if roll > gold_drop_chance:
		return

	var gold = GOLD_SCENE.instantiate()
	get_tree().current_scene.add_child(gold)

	gold.gold_amount = randi_range(1, 5) + monster_level
	gold.global_position = drop_position + Vector3(0, 0.5, 0)

func roll_item(drop_position: Vector3, monster_level: int, loot_table: Array):
	var roll = randi_range(1, 100)

	if roll > item_drop_chance:
		return

	if loot_table.is_empty():
		return

	var item = ITEM_SCENE.instantiate()
	var chosen = loot_table[randi_range(0, loot_table.size() - 1)]
	var rarity = roll_rarity(monster_level)

	var attack = randi_range(chosen.get("attack_min", 0), chosen.get("attack_max", 0))
	var defense = randi_range(chosen.get("defense_min", 0), chosen.get("defense_max", 0))

	match rarity:
		"Rare":
			attack += randi_range(1, 3)
			defense += randi_range(1, 3)
		"Epic":
			attack += randi_range(3, 6)
			defense += randi_range(3, 6)
		"Legendary":
			attack += randi_range(6, 10)
			defense += randi_range(6, 10)

	var required_level = max(1, monster_level)
	var required_strength = 0
	var required_dexterity = 0
	var required_vitality = 0
	var required_devotion = 0

	match chosen["type"]:
		"Weapon":
			required_strength = monster_level * 2
		"Offhand":
			required_strength = monster_level
		"Helmet", "Chest", "Gloves", "Boots", "Belt":
			required_strength = monster_level
		"Ring", "Amulet":
			required_devotion = monster_level

	item.setup_item(
		chosen["name"],
		chosen["type"],
		rarity,
		attack,
		defense,
		chosen["icon"],
		required_level,
		required_strength,
		required_dexterity,
		required_vitality,
		required_devotion
	)

	get_tree().current_scene.add_child(item)
	item.global_position = drop_position + Vector3(0.4, 0.5, 0)

	print("Item dropped: ", rarity, " ", chosen["name"])

func roll_rarity(monster_level: int) -> String:
	var roll = randi_range(1, 100) + rare_bonus

	if monster_level >= 10:
		roll += 5

	if monster_level >= 20:
		roll += 10

	if roll <= 60:
		return "Common"
	elif roll <= 90:
		return "Rare"
	elif roll <= 98:
		return "Epic"
	else:
		return "Legendary"

func get_early_dungeon_table() -> Array:
	return [
		{"name": "Rusty Sword", "type": "Weapon", "icon": "res://assets/icons/items/rusty_sword.png", "attack_min": 1, "attack_max": 3, "defense_min": 0, "defense_max": 0},
		{"name": "Wooden Shield", "type": "Offhand", "icon": "res://assets/icons/items/wooden_shield.png", "attack_min": 0, "attack_max": 0, "defense_min": 2, "defense_max": 5},
		{"name": "Leather Cap", "type": "Helmet", "icon": "res://assets/icons/items/leather_cap.png", "attack_min": 0, "attack_max": 0, "defense_min": 1, "defense_max": 3},
		{"name": "Leather Armor", "type": "Chest", "icon": "res://assets/icons/items/leather_armor.png", "attack_min": 0, "attack_max": 0, "defense_min": 3, "defense_max": 7},
		{"name": "Leather Gloves", "type": "Gloves", "icon": "res://assets/icons/items/leather_gloves.png", "attack_min": 0, "attack_max": 2, "defense_min": 1, "defense_max": 3},
		{"name": "Worn Boots", "type": "Boots", "icon": "res://assets/icons/items/leather_boots.png", "attack_min": 0, "attack_max": 0, "defense_min": 1, "defense_max": 3},
		{"name": "Cloth Belt", "type": "Belt", "icon": "res://assets/icons/items/cloth_belt.png", "attack_min": 0, "attack_max": 0, "defense_min": 1, "defense_max": 2},
		{"name": "Copper Ring", "type": "Ring", "icon": "res://assets/icons/items/copper_ring.png", "attack_min": 1, "attack_max": 2, "defense_min": 0, "defense_max": 0},
		{"name": "Bone Amulet", "type": "Amulet", "icon": "res://assets/icons/items/bone_amulet.png", "attack_min": 1, "attack_max": 3, "defense_min": 0, "defense_max": 2}
	]

func get_mid_dungeon_table() -> Array:
	var table = get_early_dungeon_table()

	table.append_array([
		{"name": "Iron Sword", "type": "Weapon", "icon": "res://assets/icons/items/iron_sword.png", "attack_min": 4, "attack_max": 8, "defense_min": 0, "defense_max": 0},
		{"name": "Iron Helm", "type": "Helmet", "icon": "res://assets/icons/items/iron_helm.png", "attack_min": 0, "attack_max": 0, "defense_min": 4, "defense_max": 8},
		{"name": "Chainmail", "type": "Chest", "icon": "res://assets/icons/items/chainmail.png", "attack_min": 0, "attack_max": 0, "defense_min": 8, "defense_max": 14}
	])

	return table

func get_late_dungeon_table() -> Array:
	var table = get_mid_dungeon_table()

	table.append_array([
		{"name": "Knight Blade", "type": "Weapon", "icon": "res://assets/icons/items/knight_blade.png", "attack_min": 9, "attack_max": 16, "defense_min": 0, "defense_max": 0},
		{"name": "Plate Armor", "type": "Chest", "icon": "res://assets/icons/items/plate_armor.png", "attack_min": 0, "attack_max": 0, "defense_min": 15, "defense_max": 25}
	])

	return table
