extends CharacterBody3D

@export var move_speed: float = 4.0
@export var stop_distance: float = 0.15
@export var attack_range: float = 1.5
@export var attack_damage: int = 1
@export var attack_cooldown: float = 0.8

@export var skeleton_minion_scene: PackedScene
@export var corpse_search_radius: float = 6.0
@export var raise_skeleton_mana_cost: int = 8

@onready var inventory = $Inventory
@onready var stats = $PlayerStats
@onready var skills = get_node_or_null("PlayerSkills")

var target_position: Vector3
var has_target: bool = false

var attack_target: Node3D = null
var loot_target: Node3D = null
var attack_timer: float = 0.0

var summoned_skeletons: Array = []


func _ready():
	add_to_group("player")
	target_position = global_position

	# Ensure class + starting skills are applied even if node ready-order races.
	if stats and skills and skills.current_class_id == "":
		stats.set_class(stats.default_class_id)

	if stats:
		stats.print_stats()


func _unhandled_input(event):
	if event.is_action_pressed("cast_raise_skeleton"):
		cast_raise_skeleton()


func set_move_target(new_target: Vector3):
	attack_target = null
	loot_target = null
	target_position = new_target
	has_target = true


func set_attack_target(new_target: Node3D):
	attack_target = new_target
	loot_target = null
	has_target = false


func set_loot_target(new_target: Node3D):
	attack_target = null
	loot_target = new_target
	has_target = false


func add_gold(amount: int):
	if inventory:
		inventory.add_gold(amount)
		refresh_hud()
	else:
		print("ERROR: Player is missing Inventory node.")


func add_item(item_data):
	if inventory:
		inventory.add_item(item_data)
		refresh_hud()
	else:
		print("ERROR: Player is missing Inventory node.")


func gain_experience(amount: int):
	if stats:
		stats.add_experience(amount)
		print("Gained XP: ", amount)
		refresh_hud()
	else:
		print("ERROR: Player is missing PlayerStats node.")


func refresh_hud():
	var hud = get_tree().current_scene.get_node_or_null("HUD")

	if hud:
		if hud.has_method("refresh_inventory"):
			hud.refresh_inventory()

		if hud.has_method("refresh_status"):
			hud.refresh_status()

		if hud.has_method("refresh_character_panel"):
			hud.refresh_character_panel()

		if hud.has_method("refresh_skills_panel"):
			hud.refresh_skills_panel()


func get_attack_damage():
	if stats:
		var min_damage = int(stats.attack_damage_min)
		var max_damage = int(stats.attack_damage_max)

		if max_damage < min_damage:
			max_damage = min_damage

		return randi_range(min_damage, max_damage)

	return attack_damage


func _physics_process(delta):
	attack_timer -= delta

	if attack_target != null and is_instance_valid(attack_target):
		handle_attack_target()
	elif loot_target != null and is_instance_valid(loot_target):
		handle_loot_target()
	else:
		attack_target = null
		loot_target = null
		handle_movement()

	move_and_slide()


func handle_movement():
	if not has_target:
		velocity = Vector3.ZERO
		return

	var direction := target_position - global_position
	direction.y = 0

	if direction.length() <= stop_distance:
		has_target = false
		velocity = Vector3.ZERO
	else:
		direction = direction.normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

		look_at(Vector3(target_position.x, global_position.y, target_position.z), Vector3.UP)


func handle_attack_target():
	var direction := attack_target.global_position - global_position
	direction.y = 0

	var distance := direction.length()

	if distance > attack_range:
		direction = direction.normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

		look_at(Vector3(attack_target.global_position.x, global_position.y, attack_target.global_position.z), Vector3.UP)
	else:
		velocity = Vector3.ZERO

		look_at(Vector3(attack_target.global_position.x, global_position.y, attack_target.global_position.z), Vector3.UP)

		if attack_timer <= 0.0:
			attack_timer = attack_cooldown

			if attack_target.has_method("take_damage"):
				attack_target.take_damage(get_attack_damage(), self)


func handle_loot_target():
	if loot_target == null or not is_instance_valid(loot_target):
		loot_target = null
		velocity = Vector3.ZERO
		return

	var direction := loot_target.global_position - global_position
	direction.y = 0

	if direction.length() > 0.3:
		direction = direction.normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

		look_at(Vector3(loot_target.global_position.x, global_position.y, loot_target.global_position.z), Vector3.UP)
	else:
		velocity = Vector3.ZERO

		if loot_target.has_method("pickup"):
			loot_target.pickup(self)

		loot_target = null


func cast_raise_skeleton():
	if stats == null:
		print("Raise Skeleton failed: no PlayerStats.")
		return

	if stats.player_class != "veilwalker":
		print("Only Veilwalker can use Raise Skeleton.")
		return

	if skeleton_minion_scene == null:
		print("No skeleton_minion_scene assigned on Player.")
		return

	if skills == null:
		print("No PlayerSkills node found.")
		return

	var skill_effect = skills.get_skill_effect("raise_skeleton")

	if skill_effect.is_empty():
		print("Raise Skeleton is not learned.")
		return

	cleanup_skeleton_list()

	var max_skeletons = max(1, int(floor(skill_effect.get("max_skeletons", 1))))

	if summoned_skeletons.size() >= max_skeletons:
		print("Maximum skeletons reached: ", max_skeletons)
		return

	var corpse = find_nearest_corpse()

	if corpse == null:
		print("No corpse nearby.")
		return

	if not spend_mana(raise_skeleton_mana_cost):
		print("Not enough mana.")
		return

	# Synergies (e.g. Skeleton Mastery → skeleton_health/damage %) are already applied in get_skill_effect.
	var skeleton_health = int(skill_effect.get("skeleton_health", 35))
	var skeleton_damage = int(skill_effect.get("skeleton_damage", 6))

	var spawn_position = corpse.global_position
	spawn_position.y += 0.05

	if corpse.has_method("consume"):
		corpse.consume()
	else:
		corpse.queue_free()

	var skeleton = skeleton_minion_scene.instantiate()
	get_tree().current_scene.add_child(skeleton)

	skeleton.global_position = spawn_position + Vector3(randf_range(-0.5, 0.5), 0, randf_range(-0.5, 0.5))

	if skeleton.has_method("setup_minion"):
		skeleton.setup_minion(self, skeleton_health, skeleton_damage)

	summoned_skeletons.append(skeleton)

	print("Raised Skeleton. HP: ", skeleton_health, " Damage: ", skeleton_damage, " Count: ", summoned_skeletons.size(), "/", max_skeletons)

	refresh_hud()


func find_nearest_corpse():
	var corpses = get_tree().get_nodes_in_group("corpse")
	var closest_corpse = null
	var closest_distance = corpse_search_radius

	for corpse in corpses:
		if corpse == null or not is_instance_valid(corpse):
			continue

		if "used" in corpse and corpse.used:
			continue

		var distance = global_position.distance_to(corpse.global_position)

		if distance < closest_distance:
			closest_distance = distance
			closest_corpse = corpse

	return closest_corpse


func cleanup_skeleton_list():
	for i in range(summoned_skeletons.size() - 1, -1, -1):
		var skeleton = summoned_skeletons[i]

		if skeleton == null or not is_instance_valid(skeleton):
			summoned_skeletons.remove_at(i)


func spend_mana(amount: int) -> bool:
	if stats == null:
		return false

	if stats.current_mana < amount:
		return false

	stats.current_mana -= amount
	refresh_hud()
	return true


func take_damage(amount: int, _attacker = null):
	if stats == null:
		return

	stats.current_health -= amount
	stats.current_health = clamp(stats.current_health, 0, stats.max_health)

	print("Player took ", amount, " damage. Health: ", stats.current_health, "/", stats.max_health)

	refresh_hud()
