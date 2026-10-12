extends Area3D

@export var item_name: String = "Rusty Sword"
@export var item_type: String = "Weapon"
@export var rarity: String = "Common"

@export var attack_bonus: int = 1
@export var defense_bonus: int = 0
@export var icon_path: String = "res://assets/icons/items/rusty_sword.png"

@export var required_level: int = 1
@export var required_strength: int = 0
@export var required_dexterity: int = 0
@export var required_vitality: int = 0
@export var required_devotion: int = 0

var item_data: Dictionary = {}

func _ready():
	build_item_data()
	add_to_group("loot")
	set_color_by_rarity()

func build_item_data():
	item_data = {
		"id": str(Time.get_ticks_usec()) + "_" + str(randi()),

		"item_name": item_name,
		"item_type": item_type,
		"rarity": rarity,

		"attack_bonus": attack_bonus,
		"defense_bonus": defense_bonus,
		"icon_path": icon_path,

		"requirements": {
			"level": required_level,
			"strength": required_strength,
			"dexterity": required_dexterity,
			"vitality": required_vitality,
			"devotion": required_devotion
		}
	}

func setup_item(
	new_name: String,
	new_type: String,
	new_rarity: String,
	new_attack: int,
	new_defense: int,
	new_icon_path: String,
	new_required_level: int = 1,
	new_required_strength: int = 0,
	new_required_dexterity: int = 0,
	new_required_vitality: int = 0,
	new_required_devotion: int = 0
):
	item_name = new_name
	item_type = new_type
	rarity = new_rarity
	attack_bonus = new_attack
	defense_bonus = new_defense
	icon_path = new_icon_path

	required_level = new_required_level
	required_strength = new_required_strength
	required_dexterity = new_required_dexterity
	required_vitality = new_required_vitality
	required_devotion = new_required_devotion

	build_item_data()
	set_color_by_rarity()

func pickup(body):
	if body.has_method("add_item"):
		body.add_item(item_data)
		queue_free()

func set_color_by_rarity():
	var mesh = $MeshInstance3D
	var mat = StandardMaterial3D.new()

	match rarity:
		"Common":
			mat.albedo_color = Color(1, 1, 1)
		"Rare":
			mat.albedo_color = Color(0.2, 0.4, 1)
		"Epic":
			mat.albedo_color = Color(0.6, 0.2, 1)
		"Legendary":
			mat.albedo_color = Color(1, 0.5, 0)
		_:
			mat.albedo_color = Color(1, 1, 1)

	mesh.set_surface_override_material(0, mat)