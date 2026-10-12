extends Area3D

@export var corpse_lifetime: float = 30.0

var corpse_owner_class: String = ""
var used: bool = false


func _ready():
	add_to_group("corpse")
	input_ray_pickable = false

	if corpse_lifetime > 0:
		await get_tree().create_timer(corpse_lifetime).timeout

		if is_instance_valid(self) and not used:
			queue_free()


func setup_corpse(owner_class: String):
	corpse_owner_class = owner_class


func consume():
	if used:
		return

	used = true
	queue_free()
