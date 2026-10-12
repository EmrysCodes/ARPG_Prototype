extends Node3D

@export var camera_follow_speed: float = 8.0

const PLAYER_SCENE = preload("res://scenes/player/Player.tscn")
const ENEMY_SCENE = preload("res://scenes/enemies/Enemy.tscn")

var room_scenes = [
	preload("res://scenes/dungeon/rooms/Room_01.tscn"),
	preload("res://scenes/dungeon/rooms/Room_02.tscn"),
	preload("res://scenes/dungeon/rooms/Room_03.tscn")
]

@onready var room_holder: Node3D = $CurrentRoomHolder
@onready var camera_rig: Node3D = $CameraRig
@onready var camera: Camera3D = $CameraRig/Camera3D
@onready var hud = get_node_or_null("HUD")

var current_room: Node3D = null
var current_exit: Area3D = null
var player: CharacterBody3D = null

var floor_number: int = 1
var enemies_alive: int = 0

func _ready():
	_force_landscape()
	spawn_player()
	load_room()


func _force_landscape() -> void:
	# Xogot / iOS can ignore project.godot alone; pin landscape at runtime too.
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR_LANDSCAPE)
	var win := get_window()
	if win:
		win.content_scale_size = Vector2i(1920, 1080)
		win.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
		win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND

func spawn_player():
	player = PLAYER_SCENE.instantiate()
	add_child(player)

	if hud and hud.has_method("set_player"):
		hud.set_player(player)
		print("HUD connected to player.")
	else:
		print("ERROR: HUD not found or missing set_player().")

func load_room():
	clear_current_room()
	clear_enemies()

	var room_index = floor_number - 1

	if room_index >= room_scenes.size():
		room_index = room_scenes.size() - 1

	current_room = room_scenes[room_index].instantiate()
	room_holder.add_child(current_room)

	var spawn_points = current_room.get_node_or_null("SpawnPoints")

	if spawn_points == null:
		print("ERROR: Room is missing SpawnPoints node.")
		return

	var player_spawn = spawn_points.get_node_or_null("PlayerSpawn")

	if player_spawn == null:
		print("ERROR: Room is missing PlayerSpawn marker. Check spelling.")
		return

	player.global_position = player_spawn.global_position
	player.set_move_target(player.global_position)

	setup_exit()
	spawn_enemies(spawn_points)

	print("Loaded floor: ", floor_number)

func setup_exit():
	current_exit = current_room.get_node_or_null("Exit")

	if current_exit == null:
		print("WARNING: Room has no Exit node.")
		return

	current_exit.monitoring = false
	current_exit.visible = false

	if not current_exit.body_entered.is_connected(_on_exit_entered):
		current_exit.body_entered.connect(_on_exit_entered)

func enable_exit():
	if current_exit == null:
		return

	current_exit.monitoring = true
	current_exit.visible = true
	print("Exit enabled!")

func _on_exit_entered(body):
	if body != player:
		return

	floor_number += 1
	print("Going to floor: ", floor_number)
	load_room()

func clear_current_room():
	for child in room_holder.get_children():
		child.queue_free()

func clear_enemies():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_instance_valid(enemy):
			enemy.queue_free()

	# Leave active minions with the player; only clean leftover corpses between rooms.
	for corpse in get_tree().get_nodes_in_group("corpse"):
		if is_instance_valid(corpse):
			corpse.queue_free()

	enemies_alive = 0

func spawn_enemies(spawn_points: Node):
	enemies_alive = 0

	for point in spawn_points.get_children():
		if point.name.begins_with("EnemySpawn"):
			var enemy = ENEMY_SCENE.instantiate()
			add_child(enemy)
			enemy.global_position = point.global_position

			enemies_alive += 1
			enemy.tree_exited.connect(_on_enemy_died)

	if enemies_alive <= 0:
		enable_exit()

func _on_enemy_died():
	enemies_alive -= 1

	if enemies_alive <= 0:
		print("Room cleared!")
		enable_exit()

func _process(delta):
	if player == null:
		return

	camera_rig.global_position = camera_rig.global_position.lerp(
		player.global_position,
		camera_follow_speed * delta
	)

func _unhandled_input(event):
	if player == null:
		return

	if event is InputEventScreenTouch and event.pressed:
		handle_tap(event.position)

	if event is InputEventMouseButton and event.pressed:
		handle_tap(event.position)

func handle_tap(screen_position: Vector2):
	if camera == null:
		return

	var ray_origin = camera.project_ray_origin(screen_position)
	var ray_direction = camera.project_ray_normal(screen_position)
	var ray_end = ray_origin + ray_direction * 1000.0

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)

	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)

	if not result:
		return

	var hit_object = result.collider

	if hit_object == null:
		return

	if hit_object.is_in_group("enemies"):
		player.set_attack_target(hit_object)
		return

	if hit_object.is_in_group("loot"):
		player.set_loot_target(hit_object)
		return

	if hit_object.is_in_group("exit"):
		player.set_move_target(hit_object.global_position)
		return

	if hit_object.is_in_group("floor"):
		player.set_move_target(result.position)
		return

	if hit_object.is_in_group("walls"):
		print("Tapped wall. Ignoring movement.")
		return
