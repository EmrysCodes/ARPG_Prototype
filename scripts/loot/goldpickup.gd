extends Area3D

@export var gold_amount: int = 1

@onready var mesh: MeshInstance3D = $MeshInstance3D


func _ready():
	body_entered.connect(_on_body_entered)
	_style_gold()


func _process(delta: float) -> void:
	if mesh:
		mesh.rotate_y(delta * 2.4)
		mesh.position.y = 0.15 + sin(Time.get_ticks_msec() * 0.006) * 0.06


func _style_gold() -> void:
	if mesh == null:
		return

	var mat = StandardMaterial3D.new()
	mat.albedo_color = RarityColors.GOLD
	mat.emission_enabled = true
	mat.emission = Color(0.95, 0.75, 0.2)
	mat.emission_energy_multiplier = 1.6
	mat.metallic = 0.85
	mat.roughness = 0.25
	mesh.set_surface_override_material(0, mat)


func _on_body_entered(body):
	if body.has_method("add_gold"):
		body.add_gold(gold_amount)
		queue_free()
