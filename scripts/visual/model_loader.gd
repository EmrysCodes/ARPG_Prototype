extends Node3D
## Loads a GLB visual under a CharacterBody3D and hides the placeholder BodyMesh.

@export_file("*.glb") var model_path: String = ""
@export var model_scale: Vector3 = Vector3.ONE
@export var model_offset: Vector3 = Vector3.ZERO
@export var model_yaw_degrees: float = 0.0
@export var hide_placeholder_named: String = "BodyMesh"

var _instance: Node3D = null


func _ready() -> void:
	call_deferred("_load_model")


func _load_model() -> void:
	if model_path == "":
		return

	var packed = load(model_path)
	if packed == null:
		push_warning("ModelLoader: failed to load %s" % model_path)
		return

	if packed is PackedScene:
		_instance = packed.instantiate()
	elif packed is Node3D:
		_instance = packed.duplicate()
	else:
		push_warning("ModelLoader: unexpected resource type for %s" % model_path)
		return

	_instance.name = "LoadedModel"
	_instance.scale = model_scale
	_instance.position = model_offset
	_instance.rotation_degrees.y = model_yaw_degrees
	add_child(_instance)

	var placeholder = get_parent().get_node_or_null(hide_placeholder_named)
	if placeholder:
		placeholder.visible = false


func get_flash_mesh() -> MeshInstance3D:
	if _instance == null:
		return get_parent().get_node_or_null(hide_placeholder_named) as MeshInstance3D

	var meshes = _instance.find_children("*", "MeshInstance3D", true, false)
	if meshes.size() > 0:
		return meshes[0] as MeshInstance3D

	return get_parent().get_node_or_null(hide_placeholder_named) as MeshInstance3D
