extends Node

# Hard class definitions from the Xogot design chat.
# IDs: warrior, ranger, sorcerer, cleric, veilwalker

var CLASSES = {
	"warrior": {
		"display_name": "Warrior",
		"theme": "Melee weapons, warcries, and heavy armor",
		"strength": 13,
		"dexterity": 6,
		"vitality": 10,
		"devotion": 3,
		"base_health": 145,
		"base_mana": 30,
		"starting_skills": ["cleave"]
	},
	"ranger": {
		"display_name": "Ranger",
		"theme": "Bows, traps, beasts, speed, and poison",
		"strength": 6,
		"dexterity": 13,
		"vitality": 7,
		"devotion": 4,
		"base_health": 105,
		"base_mana": 45,
		"starting_skills": ["quick_shot"]
	},
	"sorcerer": {
		"display_name": "Sorcerer",
		"theme": "Fire, frost, storm, and mana-heavy spellcasting",
		"strength": 3,
		"dexterity": 6,
		"vitality": 6,
		"devotion": 14,
		"base_health": 80,
		"base_mana": 135,
		"starting_skills": ["fire_bolt"]
	},
	"cleric": {
		"display_name": "Cleric",
		"theme": "Holy magic, healing, protection, and judgment",
		"strength": 7,
		"dexterity": 5,
		"vitality": 10,
		"devotion": 10,
		"base_health": 125,
		"base_mana": 90,
		"starting_skills": ["smite"]
	},
	"veilwalker": {
		"display_name": "Veilwalker",
		"theme": "Skeleton summons, poison, curses, and dark veil magic",
		"strength": 4,
		"dexterity": 5,
		"vitality": 8,
		"devotion": 14,
		"base_health": 95,
		"base_mana": 130,
		"starting_skills": ["raise_skeleton"]
	}
}


# Named get_class_data (not get_class) — Object.get_class() -> String is reserved.
func get_class_data(class_id: String) -> Dictionary:
	return CLASSES.get(class_id, {})


func get_display_name(class_id: String) -> String:
	return CLASSES.get(class_id, {}).get("display_name", class_id)


func get_trees_for_class(class_id: String) -> Array:
	# Tree order used by the skill UI (matches skill_database trees).
	match class_id:
		"warrior":
			return ["Arms", "Warcries", "Juggernaut"]
		"ranger":
			return ["Archery", "Traps", "Beastcraft"]
		"sorcerer":
			return ["Fire", "Frost", "Storm"]
		"cleric":
			return ["Holy Light", "Protection", "Judgment"]
		"veilwalker":
			return ["Gravecraft", "Blight", "Veil Magic"]
		_:
			return []
