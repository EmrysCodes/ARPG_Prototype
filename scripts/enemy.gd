extends CharacterBody3D

@export var monster_level: int = 1
@export var max_health: int = 3
@export var xp_reward: int = 25
@export var corpse_scene: PackedScene

var health: int
var is_dead: bool = false

@onready var mesh: MeshInstance3D = $BodyMesh
@onready var loot_dropper = $LootDropper


func _ready():
	health = max_health
	add_to_group("enemies")
	# Chat pastes also used singular "enemy"; keep both for skill/minion lookups.
	add_to_group("enemy")
	randomize()


func take_damage(amount: int, attacker = null):
	if is_dead:
		return

	health -= amount
	print("Enemy took ", amount, " damage. Health: ", health)

	flash()

	if health <= 0:
		die(attacker)


func die(attacker = null):
	if is_dead:
		return

	is_dead = true

	if attacker and attacker.has_method("gain_experience"):
		attacker.gain_experience(xp_reward)
	else:
		# Minion kills: award XP to owning player when possible.
		var player = get_tree().get_first_node_in_group("player")
		if player and player.has_method("gain_experience"):
			player.gain_experience(xp_reward)

	if should_leave_corpse():
		spawn_corpse()

	if loot_dropper and loot_dropper.has_method("drop_loot"):
		loot_dropper.drop_loot(global_position)
	else:
		print("WARNING: Enemy has no LootDropper.")

	queue_free()


func should_leave_corpse() -> bool:
	if corpse_scene == null:
		return false

	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return false

	var stats = player.get_node_or_null("PlayerStats")
	if stats == null:
		return false

	return stats.player_class == "veilwalker"


func spawn_corpse():
	if corpse_scene == null:
		print("No corpse_scene assigned on enemy.")
		return

	var corpse = corpse_scene.instantiate()
	get_tree().current_scene.add_child(corpse)

	corpse.global_position = global_position
	corpse.global_position.y += 0.05

	if corpse.has_method("setup_corpse"):
		var player = get_tree().get_first_node_in_group("player")
		var class_id = ""

		if player:
			var stats = player.get_node_or_null("PlayerStats")
			if stats:
				class_id = stats.player_class

		corpse.setup_corpse(class_id)


func flash():
	if mesh == null:
		print("ERROR: Enemy is missing BodyMesh.")
		return

	var mat = mesh.get_active_material(0)

	if mat == null:
		print("No material on enemy mesh!")
		return

	mat = mat.duplicate()
	mesh.set_surface_override_material(0, mat)

	mat.albedo_color = Color(1, 0.2, 0.2)

	await get_tree().create_timer(0.1).timeout

	if is_instance_valid(mesh):
		mat.albedo_color = Color(1, 1, 1)
