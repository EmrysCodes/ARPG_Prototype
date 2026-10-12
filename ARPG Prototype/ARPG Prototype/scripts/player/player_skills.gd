extends Node

const SKILL_DATABASE_SCRIPT = preload("res://scripts/player/skill_database.gd")
const PLAYER_CLASSES_SCRIPT = preload("res://scripts/player/player_classes.gd")

var skill_db = SKILL_DATABASE_SCRIPT.new()
var class_db = PLAYER_CLASSES_SCRIPT.new()

var current_class_id: String = ""
var skill_points: int = 0
var skill_levels: Dictionary = {}


func set_class(class_id: String):
	if not class_db.CLASSES.has(class_id):
		print("Invalid skill class: ", class_id)
		return

	current_class_id = class_id
	skill_levels.clear()
	skill_points = 0

	for skill_id in skill_db.SKILLS.keys():
		var skill = skill_db.SKILLS[skill_id]

		if skill.get("class_id", "") == current_class_id:
			skill_levels[skill_id] = 0

	var starting_skills = class_db.CLASSES[class_id].get("starting_skills", [])

	for skill_id in starting_skills:
		if skill_levels.has(skill_id):
			skill_levels[skill_id] = 1

	print("PlayerSkills class set to: ", class_db.CLASSES[class_id]["display_name"])


func gain_skill_points(amount: int):
	skill_points += amount
	print("Skill points: ", skill_points)


func can_spend_point(skill_id: String, player_level: int) -> bool:
	if skill_points <= 0:
		return false

	if not skill_db.SKILLS.has(skill_id):
		return false

	var skill = skill_db.SKILLS[skill_id]

	if skill.get("class_id", "") != current_class_id:
		return false

	if player_level < skill.get("required_level", 1):
		return false

	var current_level = get_hard_skill_level(skill_id)

	if current_level >= skill.get("max_level", 20):
		return false

	return true


func add_skill_level(skill_id: String, player_level: int) -> bool:
	if not can_spend_point(skill_id, player_level):
		print("Cannot add skill point to: ", skill_id)
		return false

	skill_levels[skill_id] = get_hard_skill_level(skill_id) + 1
	skill_points -= 1

	print("Added point to ", skill_id, ". New level: ", skill_levels[skill_id])
	return true


func get_hard_skill_level(skill_id: String) -> int:
	return int(skill_levels.get(skill_id, 0))


func get_total_skill_level(skill_id: String) -> int:
	var hard_level = get_hard_skill_level(skill_id)
	var bonus_level = get_bonus_skill_levels(skill_id)

	return hard_level + bonus_level


func get_bonus_skill_levels(skill_id: String) -> int:
	var stats = get_parent().get_node_or_null("PlayerStats")

	if stats == null:
		return 0

	var skill = skill_db.SKILLS.get(skill_id, {})

	var bonus = 0
	bonus += stats.all_skills_bonus

	if skill.has("class_id"):
		bonus += stats.get_class_skill_bonus(skill["class_id"])

	if skill.has("tree"):
		bonus += stats.get_tree_skill_bonus(skill["tree"])

	bonus += stats.get_specific_skill_bonus(skill_id)

	return bonus


func get_skill_data(skill_id: String) -> Dictionary:
	return skill_db.SKILLS.get(skill_id, {})


func get_skills_for_current_class() -> Array:
	var result: Array = []

	for skill_id in skill_db.SKILLS.keys():
		var skill = skill_db.SKILLS[skill_id]

		if skill.get("class_id", "") == current_class_id:
			result.append(skill)

	return result


func get_skills_by_tree(tree_name: String) -> Array:
	var result: Array = []

	for skill_id in skill_db.SKILLS.keys():
		var skill = skill_db.SKILLS[skill_id]

		if skill.get("class_id", "") == current_class_id and skill.get("tree", "") == tree_name:
			result.append(skill)

	# Stable tier order by required_level then name.
	result.sort_custom(func(a, b):
		if a.get("required_level", 1) == b.get("required_level", 1):
			return str(a.get("name", "")) < str(b.get("name", ""))
		return a.get("required_level", 1) < b.get("required_level", 1)
	)

	return result


func get_active_skills() -> Array:
	var result: Array = []

	for skill in get_skills_for_current_class():
		var skill_type = skill.get("skill_type", "")
		if skill_type != "active" and skill_type != "ultimate":
			continue
		if get_hard_skill_level(skill["id"]) <= 0:
			continue
		result.append(skill)

	return result


func get_skill_effect(skill_id: String) -> Dictionary:
	if not skill_db.SKILLS.has(skill_id):
		return {}

	var skill = skill_db.SKILLS[skill_id]
	var total_level = get_total_skill_level(skill_id)

	if total_level <= 0:
		return {}

	var effect_result: Dictionary = {}

	for effect_name in skill.get("effects", {}).keys():
		var effect_data = skill["effects"][effect_name]
		var base_value = effect_data.get("base", 0)
		var per_level = effect_data.get("per_level", 0)

		effect_result[effect_name] = base_value + per_level * (total_level - 1)

	apply_synergies(skill, effect_result)

	return effect_result


func apply_synergies(skill: Dictionary, effect_result: Dictionary):
	for synergy in skill.get("synergies", []):
		var source_skill_id = synergy.get("source", "")
		var target = synergy.get("target", "")
		var synergy_type = synergy.get("type", "percent")
		var per_level = synergy.get("per_level", 0)

		if source_skill_id == "" or target == "":
			continue

		if not effect_result.has(target):
			continue

		var source_hard_level = get_hard_skill_level(source_skill_id)

		if source_hard_level <= 0:
			continue

		if synergy_type == "percent":
			var bonus_percent = source_hard_level * per_level
			effect_result[target] = effect_result[target] * (1.0 + bonus_percent / 100.0)

		elif synergy_type == "flat":
			effect_result[target] += source_hard_level * per_level


func print_skill_tree():
	print("Class: ", current_class_id)
	print("Skill Points: ", skill_points)

	for skill_id in skill_levels.keys():
		print(skill_id, ": ", skill_levels[skill_id])
