extends CharacterBody3D

@export var move_speed: float = 3.5
@export var follow_distance: float = 2.2
@export var attack_range: float = 1.4
@export var detection_radius: float = 8.0
@export var attack_cooldown: float = 1.0

var owner_player = null
var target_enemy = null

var max_health: int = 35
var current_health: int = 35
var attack_damage: int = 6

var attack_timer: float = 0.0


func setup_minion(new_owner, health_value: int, damage_value: int):
	owner_player = new_owner
	max_health = max(1, health_value)
	current_health = max_health
	attack_damage = max(1, damage_value)

	add_to_group("minion")


func _physics_process(delta):
	attack_timer -= delta

	if owner_player == null or not is_instance_valid(owner_player):
		queue_free()
		return

	find_target()

	if target_enemy != null and is_instance_valid(target_enemy):
		handle_attack_target()
	else:
		follow_owner()

	move_and_slide()


func find_target():
	if target_enemy != null and is_instance_valid(target_enemy):
		var distance = global_position.distance_to(target_enemy.global_position)

		if distance <= detection_radius:
			return

	target_enemy = null

	# Live repo uses group "enemies" (plural); accept both for safety.
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		enemies = get_tree().get_nodes_in_group("enemy")

	var closest_enemy = null
	var closest_distance = detection_radius

	for enemy in enemies:
		if enemy == null or not is_instance_valid(enemy):
			continue

		var distance = global_position.distance_to(enemy.global_position)

		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	target_enemy = closest_enemy


func follow_owner():
	var direction = owner_player.global_position - global_position
	direction.y = 0

	var distance = direction.length()

	if distance <= follow_distance:
		velocity = Vector3.ZERO
		return

	direction = direction.normalized()
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	look_at(Vector3(owner_player.global_position.x, global_position.y, owner_player.global_position.z), Vector3.UP)


func handle_attack_target():
	var direction = target_enemy.global_position - global_position
	direction.y = 0

	var distance = direction.length()

	if distance > attack_range:
		direction = direction.normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

		look_at(Vector3(target_enemy.global_position.x, global_position.y, target_enemy.global_position.z), Vector3.UP)
		return

	velocity = Vector3.ZERO

	look_at(Vector3(target_enemy.global_position.x, global_position.y, target_enemy.global_position.z), Vector3.UP)

	if attack_timer <= 0.0:
		attack_timer = attack_cooldown

		if target_enemy.has_method("take_damage"):
			# Pass self as attacker so enemy XP path stays compatible.
			target_enemy.take_damage(attack_damage, self)


func take_damage(amount: int, _attacker = null):
	current_health -= amount

	if current_health <= 0:
		queue_free()
