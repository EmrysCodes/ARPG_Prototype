extends Node3D
## Builds reliable low-poly fantasy character meshes from primitives.
## Avoids Kenney/KayKit GLBs that fail on Xogot 4.7 (external textures + KHR_materials_unlit).

enum Style { VEILWALKER, BRUTE, SKELETON }

@export var style: Style = Style.VEILWALKER
@export var model_scale: Vector3 = Vector3.ONE
@export var model_offset: Vector3 = Vector3.ZERO
@export var model_yaw_degrees: float = 0.0
@export var hide_placeholder_named: String = "BodyMesh"

var _root: Node3D = null
var _flash_mesh: MeshInstance3D = null


func _ready() -> void:
	call_deferred("_build")


func _build() -> void:
	_root = Node3D.new()
	_root.name = "BuiltModel"
	_root.scale = model_scale
	_root.position = model_offset
	_root.rotation_degrees.y = model_yaw_degrees
	add_child(_root)

	match style:
		Style.VEILWALKER:
			_build_veilwalker(_root)
		Style.BRUTE:
			_build_brute(_root)
		Style.SKELETON:
			_build_skeleton(_root)

	var placeholder = get_parent().get_node_or_null(hide_placeholder_named)
	if placeholder:
		placeholder.visible = false


func get_flash_mesh() -> MeshInstance3D:
	if _flash_mesh:
		return _flash_mesh
	return get_parent().get_node_or_null(hide_placeholder_named) as MeshInstance3D


func _mat(color: Color, roughness: float = 0.85, emission: Color = Color(0, 0, 0, 1), emission_energy: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.metallic = 0.0
	if emission_energy > 0.0:
		m.emission_enabled = true
		m.emission = emission
		m.emission_energy_multiplier = emission_energy
	return m


func _part(parent: Node3D, mesh: Mesh, pos: Vector3, mat: Material, part_name: String = "Part") -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = part_name
	mi.mesh = mesh
	mi.position = pos
	mi.material_override = mat
	parent.add_child(mi)
	return mi


func _box(size: Vector3) -> BoxMesh:
	var m := BoxMesh.new()
	m.size = size
	return m


func _capsule(radius: float, height: float) -> CapsuleMesh:
	var m := CapsuleMesh.new()
	m.radius = radius
	m.height = height
	return m


func _sphere(radius: float) -> SphereMesh:
	var m := SphereMesh.new()
	m.radius = radius
	m.height = radius * 2.0
	return m


func _cylinder(radius: float, height: float) -> CylinderMesh:
	var m := CylinderMesh.new()
	m.top_radius = radius
	m.bottom_radius = radius
	m.height = height
	return m


func _build_veilwalker(root: Node3D) -> void:
	# Dark hooded caster — readable purple/indigo silhouette from isometric distance.
	var robe := _mat(Color(0.22, 0.16, 0.32), 0.9)
	var trim := _mat(Color(0.55, 0.42, 0.18), 0.55, Color(0.7, 0.45, 0.15), 0.35)
	var hood := _mat(Color(0.12, 0.09, 0.16), 0.95)
	var skin := _mat(Color(0.72, 0.62, 0.55), 0.7)
	var staff := _mat(Color(0.35, 0.25, 0.15), 0.8)
	var gem := _mat(Color(0.35, 0.75, 0.95), 0.35, Color(0.2, 0.7, 1.0), 1.6)

	_flash_mesh = _part(root, _capsule(0.28, 0.95), Vector3(0, 0.85, 0), robe, "Torso")
	_part(root, _box(Vector3(0.78, 0.55, 0.55)), Vector3(0, 1.15, 0), robe, "Shoulders")
	_part(root, _box(Vector3(0.72, 0.7, 0.45)), Vector3(0, 0.45, 0.02), robe, "Skirt")
	_part(root, _sphere(0.22), Vector3(0, 1.55, 0.02), skin, "Head")
	_part(root, _box(Vector3(0.5, 0.28, 0.48)), Vector3(0, 1.68, -0.02), hood, "Hood")
	_part(root, _box(Vector3(0.42, 0.18, 0.2)), Vector3(0, 1.48, 0.18), hood, "Cowl")
	_part(root, _capsule(0.08, 0.55), Vector3(-0.38, 0.95, 0.05), robe, "ArmL")
	_part(root, _capsule(0.08, 0.55), Vector3(0.38, 0.95, 0.05), robe, "ArmR")
	_part(root, _capsule(0.09, 0.55), Vector3(-0.14, 0.28, 0), robe, "LegL")
	_part(root, _capsule(0.09, 0.55), Vector3(0.14, 0.28, 0), robe, "LegR")
	_part(root, _box(Vector3(0.5, 0.08, 0.5)), Vector3(0, 1.05, 0.02), trim, "Belt")
	var staff_mesh := _cylinder(0.035, 1.55)
	var staff_mi := _part(root, staff_mesh, Vector3(0.42, 0.9, -0.05), staff, "Staff")
	staff_mi.rotation_degrees.z = 8.0
	_part(root, _sphere(0.08), Vector3(0.48, 1.72, -0.05), gem, "StaffGem")


func _build_brute(root: Node3D) -> void:
	# Bulky red dungeon fighter — distinct from player at a glance.
	var flesh := _mat(Color(0.55, 0.22, 0.16), 0.88)
	var armor := _mat(Color(0.28, 0.22, 0.18), 0.7)
	var iron := _mat(Color(0.45, 0.42, 0.4), 0.45, Color(0.5, 0.5, 0.55), 0.15)
	var belt := _mat(Color(0.35, 0.2, 0.1), 0.8)

	_flash_mesh = _part(root, _capsule(0.36, 1.05), Vector3(0, 0.9, 0), flesh, "Torso")
	_part(root, _box(Vector3(0.95, 0.45, 0.55)), Vector3(0, 1.25, 0), armor, "Pauldrons")
	_part(root, _sphere(0.26), Vector3(0, 1.62, 0.02), flesh, "Head")
	_part(root, _box(Vector3(0.42, 0.18, 0.4)), Vector3(0, 1.78, 0), iron, "Helm")
	_part(root, _box(Vector3(0.08, 0.22, 0.08)), Vector3(-0.12, 1.92, 0), iron, "HornL")
	_part(root, _box(Vector3(0.08, 0.22, 0.08)), Vector3(0.12, 1.92, 0), iron, "HornR")
	_part(root, _capsule(0.12, 0.6), Vector3(-0.48, 1.0, 0.05), flesh, "ArmL")
	_part(root, _capsule(0.12, 0.6), Vector3(0.48, 1.0, 0.05), flesh, "ArmR")
	_part(root, _capsule(0.12, 0.6), Vector3(-0.16, 0.3, 0), flesh, "LegL")
	_part(root, _capsule(0.12, 0.6), Vector3(0.16, 0.3, 0), flesh, "LegR")
	_part(root, _box(Vector3(0.7, 0.12, 0.5)), Vector3(0, 0.7, 0.02), belt, "Belt")
	_part(root, _box(Vector3(0.18, 0.55, 0.08)), Vector3(0.55, 0.95, 0.1), iron, "Axe")


func _build_skeleton(root: Node3D) -> void:
	# Bone minion — thin white/cream joints, readable skull.
	var bone := _mat(Color(0.86, 0.8, 0.68), 0.75)
	var dark := _mat(Color(0.35, 0.3, 0.25), 0.9)
	var eye := _mat(Color(0.2, 0.85, 0.45), 0.4, Color(0.15, 0.9, 0.4), 1.4)

	_flash_mesh = _part(root, _box(Vector3(0.42, 0.55, 0.28)), Vector3(0, 1.05, 0), bone, "Ribs")
	_part(root, _box(Vector3(0.18, 0.35, 0.16)), Vector3(0, 0.7, 0), bone, "Spine")
	_part(root, _sphere(0.2), Vector3(0, 1.5, 0.02), bone, "Skull")
	_part(root, _box(Vector3(0.28, 0.1, 0.22)), Vector3(0, 1.38, 0.08), dark, "Jaw")
	_part(root, _sphere(0.04), Vector3(-0.07, 1.54, 0.16), eye, "EyeL")
	_part(root, _sphere(0.04), Vector3(0.07, 1.54, 0.16), eye, "EyeR")
	_part(root, _capsule(0.055, 0.5), Vector3(-0.32, 1.05, 0), bone, "ArmL")
	_part(root, _capsule(0.055, 0.5), Vector3(0.32, 1.05, 0), bone, "ArmR")
	_part(root, _capsule(0.06, 0.55), Vector3(-0.12, 0.3, 0), bone, "LegL")
	_part(root, _capsule(0.06, 0.55), Vector3(0.12, 0.3, 0), bone, "LegR")
	_part(root, _box(Vector3(0.5, 0.08, 0.22)), Vector3(0, 1.25, 0), bone, "Clavicle")
