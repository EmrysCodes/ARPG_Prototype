extends Node

const MAX_LEVEL: int = 99
const STAT_POINTS_PER_LEVEL: int = 5

const PLAYER_CLASSES_SCRIPT = preload("res://scripts/player/player_classes.gd")

@export var default_class_id: String = "veilwalker"

var class_db = PLAYER_CLASSES_SCRIPT.new()

var player_class: String = ""
var class_display_name: String = ""

var level: int = 1
var experience: int = 0
var experience_to_next_level: int = 100

var base_strength: int = 5
var base_dexterity: int = 5
var base_vitality: int = 5
var base_devotion: int = 5

var allocated_strength: int = 0
var allocated_dexterity: int = 0
var allocated_vitality: int = 0
var allocated_devotion: int = 0

var strength: int = 5
var dexterity: int = 5
var vitality: int = 5
var devotion: int = 5

var unspent_stat_points: int = 0

var base_health: int = 100
var base_mana: int = 50

var max_health: int = 100
var current_health: int = 100
var max_mana: int = 50
var current_mana: int = 50

var attack_damage_min: int = 1
var attack_damage_max: int = 3
# Compatibility alias for older HUD / player call sites.
var attack_damage: int = 1

var attack_rating: int = 0
var attack_speed: int = 0
var defense: int = 0
var block_chance: int = 0
var block_rate: int = 0

var critical_chance: float = 0.0
var critical_damage: float = 1.5
var dodge_chance: float = 0.0
var open_wounds: int = 0
var crushing_blow: int = 0
var deadly_strike: int = 0

var fire_resistance: int = 0
var cold_resistance: int = 0
var lightning_resistance: int = 0
var poison_resistance: int = 0
var shadow_resistance: int = 0
var physical_resistance: int = 0

var magic_find: int = 0
var gold_find: int = 0
var experience_bonus: int = 0

var movement_speed: int = 0
var run_walk_speed: int = 0
var cast_speed: int = 0
var hit_recovery: int = 0
var faster_hit_recovery: int = 0

var life_steal: int = 0
var mana_steal: int = 0
var life_regeneration: int = 0
var mana_regeneration: int = 0

var fire_damage: int = 0
var cold_damage: int = 0
var lightning_damage: int = 0
var poison_damage: int = 0
var shadow_damage: int = 0
var magic_damage: int = 0

var enhanced_damage: int = 0
var enhanced_defense: int = 0

var all_skills_bonus: int = 0
var class_skill_bonuses: Dictionary = {}
var tree_skill_bonuses: Dictionary = {}
var specific_skill_bonuses: Dictionary = {}


func _ready():
	if player_class == "":
		set_class(default_class_id)
	else:
		recalculate_stats(true)


func set_class(class_id: String):
	if not class_db.CLASSES.has(class_id):
		print("Invalid class: ", class_id)
		return

	var data = class_db.CLASSES[class_id]

	player_class = class_id
	class_display_name = data.get("display_name", class_id)

	base_strength = data.get("strength", 5)
	base_dexterity = data.get("dexterity", 5)
	base_vitality = data.get("vitality", 5)
	base_devotion = data.get("devotion", 5)

	base_health = data.get("base_health", 100)
	base_mana = data.get("base_mana", 50)

	allocated_strength = 0
	allocated_dexterity = 0
	allocated_vitality = 0
	allocated_devotion = 0

	recalculate_stats(true)

	var skills = get_parent().get_node_or_null("PlayerSkills")

	if skills:
		skills.set_class(class_id)

	print("Class set to: ", class_display_name)


func add_stat_point(stat_name: String):
	if unspent_stat_points <= 0:
		print("No stat points available.")
		return

	match stat_name.to_lower():
		"strength":
			allocated_strength += 1
		"dexterity":
			allocated_dexterity += 1
		"vitality":
			allocated_vitality += 1
		"devotion":
			allocated_devotion += 1
		_:
			print("Invalid stat: ", stat_name)
			return

	unspent_stat_points -= 1
	recalculate_stats(false)


func add_experience(amount: int):
	if level >= MAX_LEVEL:
		return

	var final_amount = amount + int(amount * experience_bonus / 100.0)
	experience += final_amount

	while experience >= experience_to_next_level and level < MAX_LEVEL:
		experience -= experience_to_next_level
		level_up()


func level_up():
	level += 1
	unspent_stat_points += STAT_POINTS_PER_LEVEL
	experience_to_next_level = int(experience_to_next_level * 1.25)

	var skills = get_parent().get_node_or_null("PlayerSkills")

	if skills:
		skills.gain_skill_points(1)

	recalculate_stats(true)

	print("Level up! Level: ", level)
	print("Unspent stat points: ", unspent_stat_points)


func recalculate_stats(full_heal: bool = false):
	var old_max_health = max_health
	var old_max_mana = max_mana

	reset_derived_stats()

	strength = base_strength + allocated_strength
	dexterity = base_dexterity + allocated_dexterity
	vitality = base_vitality + allocated_vitality
	devotion = base_devotion + allocated_devotion

	var bonus_attack := 0
	var bonus_defense := 0
	var bonus_health := 0
	var bonus_mana := 0

	var inventory = get_parent().get_node_or_null("Inventory")

	if inventory:
		for slot_name in inventory.equipped.keys():
			var item = inventory.equipped[slot_name]

			if item == null:
				continue

			strength += item.get("strength_bonus", 0)
			dexterity += item.get("dexterity_bonus", 0)
			vitality += item.get("vitality_bonus", 0)
			devotion += item.get("devotion_bonus", 0)

			bonus_attack += item.get("attack_bonus", 0)
			bonus_defense += item.get("defense_bonus", 0)
			bonus_health += item.get("health_bonus", 0)
			bonus_mana += item.get("mana_bonus", 0)

			fire_resistance += item.get("fire_resistance", 0)
			cold_resistance += item.get("cold_resistance", 0)
			lightning_resistance += item.get("lightning_resistance", 0)
			poison_resistance += item.get("poison_resistance", 0)
			shadow_resistance += item.get("shadow_resistance", 0)

			if item.has("modifiers"):
				for modifier in item["modifiers"]:
					apply_modifier(modifier)

	max_health = base_health + vitality * 5 + bonus_health + get_stat_modifier_total("max_health")
	max_mana = base_mana + devotion * 5 + bonus_mana + get_stat_modifier_total("max_mana")

	# Keep existing feel: strength feeds attack; dexterity feeds defense/AR.
	attack_damage_min = 2 + strength + bonus_attack
	attack_damage_max = attack_damage_min + 2
	attack_damage = attack_damage_min

	defense += int(dexterity / 2.0) + bonus_defense
	attack_rating += dexterity * 4

	dodge_chance = min(dexterity * 0.1, 25.0)
	critical_chance = min(dexterity * 0.08, 30.0)

	if full_heal:
		current_health = max_health
		current_mana = max_mana
	else:
		if old_max_health > 0:
			current_health = mini(max_health, current_health + (max_health - old_max_health))
		if old_max_mana > 0:
			current_mana = mini(max_mana, current_mana + (max_mana - old_max_mana))

	current_health = clamp(current_health, 0, max_health)
	current_mana = clamp(current_mana, 0, max_mana)


func reset_derived_stats():
	attack_damage_min = 1
	attack_damage_max = 3
	attack_damage = 1
	attack_rating = 0
	attack_speed = 0
	defense = 0
	block_chance = 0
	block_rate = 0

	critical_chance = 0.0
	critical_damage = 1.5
	dodge_chance = 0.0
	open_wounds = 0
	crushing_blow = 0
	deadly_strike = 0

	fire_resistance = 0
	cold_resistance = 0
	lightning_resistance = 0
	poison_resistance = 0
	shadow_resistance = 0
	physical_resistance = 0

	magic_find = 0
	gold_find = 0
	experience_bonus = 0

	movement_speed = 0
	run_walk_speed = 0
	cast_speed = 0
	hit_recovery = 0
	faster_hit_recovery = 0

	life_steal = 0
	mana_steal = 0
	life_regeneration = 0
	mana_regeneration = 0

	fire_damage = 0
	cold_damage = 0
	lightning_damage = 0
	poison_damage = 0
	shadow_damage = 0
	magic_damage = 0

	enhanced_damage = 0
	enhanced_defense = 0

	all_skills_bonus = 0
	class_skill_bonuses.clear()
	tree_skill_bonuses.clear()
	specific_skill_bonuses.clear()


func apply_modifier(modifier: Dictionary):
	var stat = modifier.get("stat_modified", modifier.get("stat", ""))
	var value = int(modifier.get("value", 0))

	match stat:
		"strength":
			strength += value
		"dexterity":
			dexterity += value
		"vitality":
			vitality += value
		"devotion":
			devotion += value
		"attack_rating":
			attack_rating += value
		"attack_speed":
			attack_speed += value
		"critical_chance":
			critical_chance += value
		"critical_damage":
			critical_damage += value
		"open_wounds":
			open_wounds += value
		"crushing_blow":
			crushing_blow += value
		"deadly_strike":
			deadly_strike += value
		"fire_resistance":
			fire_resistance += value
		"cold_resistance":
			cold_resistance += value
		"lightning_resistance":
			lightning_resistance += value
		"poison_resistance":
			poison_resistance += value
		"shadow_resistance":
			shadow_resistance += value
		"physical_resistance":
			physical_resistance += value
		"all_resistances":
			fire_resistance += value
			cold_resistance += value
			lightning_resistance += value
			poison_resistance += value
			shadow_resistance += value
		"magic_find":
			magic_find += value
		"gold_find":
			gold_find += value
		"experience_bonus":
			experience_bonus += value
		"movement_speed":
			movement_speed += value
		"run_walk_speed":
			run_walk_speed += value
		"cast_speed":
			cast_speed += value
		"hit_recovery":
			hit_recovery += value
		"faster_hit_recovery":
			faster_hit_recovery += value
		"life_steal":
			life_steal += value
		"mana_steal":
			mana_steal += value
		"life_regeneration":
			life_regeneration += value
		"mana_regeneration":
			mana_regeneration += value
		"fire_damage":
			fire_damage += value
		"cold_damage":
			cold_damage += value
		"lightning_damage":
			lightning_damage += value
		"poison_damage":
			poison_damage += value
		"shadow_damage":
			shadow_damage += value
		"magic_damage":
			magic_damage += value
		"enhanced_damage":
			enhanced_damage += value
		"enhanced_defense":
			enhanced_defense += value
		"all_skills":
			all_skills_bonus += value


func get_stat_modifier_total(stat_name: String) -> int:
	var inventory = get_parent().get_node_or_null("Inventory")
	var total = 0

	if inventory == null:
		return total

	for slot_name in inventory.equipped.keys():
		var item = inventory.equipped[slot_name]

		if item == null:
			continue

		for modifier in item.get("modifiers", []):
			var stat = modifier.get("stat_modified", modifier.get("stat", ""))

			if stat == stat_name:
				total += int(modifier.get("value", 0))

	return total


func get_class_skill_bonus(class_id: String) -> int:
	return int(class_skill_bonuses.get(class_id, 0))


func get_tree_skill_bonus(tree_name: String) -> int:
	return int(tree_skill_bonuses.get(tree_name, 0))


func get_specific_skill_bonus(skill_id: String) -> int:
	return int(specific_skill_bonuses.get(skill_id, 0))


func can_equip_item(item_data: Dictionary) -> bool:
	if not item_data.has("requirements"):
		return true

	var req = item_data["requirements"]

	if req.has("level") and level < req["level"]:
		return false
	if req.has("strength") and strength < req["strength"]:
		return false
	if req.has("dexterity") and dexterity < req["dexterity"]:
		return false
	if req.has("vitality") and vitality < req["vitality"]:
		return false
	if req.has("devotion") and devotion < req["devotion"]:
		return false

	return true


func print_stats():
	print("Class: ", class_display_name)
	print("Level: ", level)
	print("XP: ", experience, "/", experience_to_next_level)
	print("Stat Points: ", unspent_stat_points)
	print("STR: ", strength)
	print("DEX: ", dexterity)
	print("VIT: ", vitality)
	print("DEV: ", devotion)
	print("Health: ", current_health, "/", max_health)
	print("Mana: ", current_mana, "/", max_mana)
	print("Attack Damage: ", attack_damage_min, "-", attack_damage_max)
	print("Defense: ", defense)
