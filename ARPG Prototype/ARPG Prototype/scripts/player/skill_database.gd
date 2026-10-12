extends Node

var SKILLS = {}


func _init():
	build_skills()


func add_skill(data: Dictionary):
	SKILLS[data["id"]] = data


func make_skill(
	id: String,
	class_id: String,
	tree: String,
	name: String,
	required_level: int,
	max_level: int,
	skill_type: String,
	description: String,
	effects: Dictionary,
	synergies: Array = []
) -> Dictionary:
	return {
		"id": id,
		"class_id": class_id,
		"tree": tree,
		"name": name,
		"required_level": required_level,
		"max_level": max_level,
		"skill_type": skill_type,
		"description": description,
		"effects": effects,
		"synergies": synergies
	}


func build_skills():
	# =========================
	# WARRIOR - ARMS
	# =========================
	add_skill(make_skill("cleave", "warrior", "Arms", "Cleave", 1, 20, "active", "Wide melee swing hitting enemies in front.", {"damage": {"base": 12, "per_level": 4}, "mana_cost": {"base": 4, "per_level": 0}}, [
		{"source": "weapon_mastery", "target": "damage", "type": "percent", "per_level": 8},
		{"source": "rend", "target": "damage", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("heavy_strike", "warrior", "Arms", "Heavy Strike", 6, 20, "active", "Slow powerful hit with bonus damage.", {"damage": {"base": 24, "per_level": 7}, "mana_cost": {"base": 7, "per_level": 0}}, [
		{"source": "weapon_mastery", "target": "damage", "type": "percent", "per_level": 10},
		{"source": "executioner", "target": "damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("weapon_mastery", "warrior", "Arms", "Weapon Mastery", 12, 20, "passive", "Increases melee damage and attack rating.", {"melee_damage_percent": {"base": 3, "per_level": 2}, "attack_rating": {"base": 10, "per_level": 8}}, [
		{"source": "cleave", "target": "melee_damage_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("rend", "warrior", "Arms", "Rend", 18, 20, "active", "Causes bleeding damage over time.", {"bleed_damage": {"base": 10, "per_level": 5}, "duration": {"base": 4, "per_level": 0}}, [
		{"source": "cleave", "target": "bleed_damage", "type": "percent", "per_level": 7},
		{"source": "heavy_strike", "target": "bleed_damage", "type": "percent", "per_level": 7}
	]))

	add_skill(make_skill("executioner", "warrior", "Arms", "Executioner", 24, 20, "passive", "Bonus damage against low-health enemies.", {"execute_damage_percent": {"base": 5, "per_level": 2}}, [
		{"source": "heavy_strike", "target": "execute_damage_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("earthsplitter", "warrior", "Arms", "Earthsplitter", 30, 20, "ultimate", "Massive ground slam damaging enemies in a cone.", {"damage": {"base": 85, "per_level": 15}, "mana_cost": {"base": 25, "per_level": 1}}, [
		{"source": "cleave", "target": "damage", "type": "percent", "per_level": 6},
		{"source": "heavy_strike", "target": "damage", "type": "percent", "per_level": 6},
		{"source": "weapon_mastery", "target": "damage", "type": "percent", "per_level": 6}
	]))

	# =========================
	# WARRIOR - WARCRIES
	# =========================
	add_skill(make_skill("battle_shout", "warrior", "Warcries", "Battle Shout", 1, 20, "active", "Temporarily increases attack damage.", {"damage_bonus_percent": {"base": 5, "per_level": 2}, "duration": {"base": 8, "per_level": 1}}, [
		{"source": "warborn", "target": "damage_bonus_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("iron_will", "warrior", "Warcries", "Iron Will", 6, 20, "passive", "Reduces control effects and improves resilience.", {"control_resist": {"base": 3, "per_level": 2}}, [
		{"source": "battle_shout", "target": "control_resist", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("intimidating_roar", "warrior", "Warcries", "Intimidating Roar", 12, 20, "active", "Weakens nearby enemies.", {"enemy_damage_reduction": {"base": 8, "per_level": 2}, "duration": {"base": 5, "per_level": 0}}, [
		{"source": "iron_will", "target": "enemy_damage_reduction", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("blood_rush", "warrior", "Warcries", "Blood Rush", 18, 20, "active", "Gain movement and attack speed after killing an enemy.", {"attack_speed": {"base": 5, "per_level": 1}, "movement_speed": {"base": 5, "per_level": 1}}, [
		{"source": "battle_shout", "target": "attack_speed", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("warborn", "warrior", "Warcries", "Warborn", 24, 20, "passive", "Gain damage after taking damage.", {"retaliation_damage_percent": {"base": 5, "per_level": 2}}, [
		{"source": "intimidating_roar", "target": "retaliation_damage_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("banner_of_slaughter", "warrior", "Warcries", "Banner of Slaughter", 30, 20, "ultimate", "Area buff increasing damage and attack speed.", {"damage_bonus_percent": {"base": 15, "per_level": 3}, "attack_speed": {"base": 10, "per_level": 2}}, [
		{"source": "battle_shout", "target": "damage_bonus_percent", "type": "flat", "per_level": 1},
		{"source": "blood_rush", "target": "attack_speed", "type": "flat", "per_level": 1}
	]))

	# =========================
	# WARRIOR - JUGGERNAUT
	# =========================
	add_skill(make_skill("guarded_stance", "warrior", "Juggernaut", "Guarded Stance", 1, 20, "active", "Temporarily increases defense.", {"defense_bonus_percent": {"base": 10, "per_level": 3}}, [
		{"source": "thick_skin", "target": "defense_bonus_percent", "type": "flat", "per_level": 2}
	]))

	add_skill(make_skill("thick_skin", "warrior", "Juggernaut", "Thick Skin", 6, 20, "passive", "Increases armor and physical resistance.", {"defense_bonus_percent": {"base": 3, "per_level": 2}, "physical_resistance": {"base": 1, "per_level": 1}}, []))

	add_skill(make_skill("shield_breaker", "warrior", "Juggernaut", "Shield Breaker", 12, 20, "active", "Strike that reduces enemy defense.", {"damage": {"base": 20, "per_level": 6}, "enemy_defense_reduction": {"base": 10, "per_level": 2}}, [
		{"source": "guarded_stance", "target": "damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("unstoppable", "warrior", "Juggernaut", "Unstoppable", 18, 20, "active", "Short immunity to stun and slow.", {"duration": {"base": 2, "per_level": 0.2}}, [
		{"source": "thick_skin", "target": "duration", "type": "flat", "per_level": 0.05}
	]))

	add_skill(make_skill("last_stand", "warrior", "Juggernaut", "Last Stand", 24, 20, "passive", "Gain defense when low health.", {"low_health_defense_percent": {"base": 10, "per_level": 3}}, [
		{"source": "guarded_stance", "target": "low_health_defense_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("titan_form", "warrior", "Juggernaut", "Titan Form", 30, 20, "ultimate", "Temporary boost to health, armor, and damage.", {"health_bonus_percent": {"base": 20, "per_level": 4}, "damage_bonus_percent": {"base": 15, "per_level": 3}}, [
		{"source": "thick_skin", "target": "health_bonus_percent", "type": "flat", "per_level": 1},
		{"source": "last_stand", "target": "damage_bonus_percent", "type": "flat", "per_level": 1}
	]))

	# =========================
	# RANGER - ARCHERY
	# =========================
	add_skill(make_skill("quick_shot", "ranger", "Archery", "Quick Shot", 1, 20, "active", "Fast ranged attack.", {"damage": {"base": 10, "per_level": 3}}, [
		{"source": "eagle_eye", "target": "damage", "type": "percent", "per_level": 7}
	]))

	add_skill(make_skill("piercing_arrow", "ranger", "Archery", "Piercing Arrow", 6, 20, "active", "Arrow passes through enemies.", {"damage": {"base": 18, "per_level": 5}, "pierce_chance": {"base": 30, "per_level": 2}}, [
		{"source": "quick_shot", "target": "damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("eagle_eye", "ranger", "Archery", "Eagle Eye", 12, 20, "passive", "Increases attack rating and crit chance.", {"attack_rating": {"base": 15, "per_level": 10}, "critical_chance": {"base": 1, "per_level": 1}}, []))

	add_skill(make_skill("multi_shot", "ranger", "Archery", "Multi Shot", 18, 20, "active", "Fires several arrows in a spread.", {"damage": {"base": 12, "per_level": 4}, "arrow_count": {"base": 3, "per_level": 0.15}}, [
		{"source": "piercing_arrow", "target": "damage", "type": "percent", "per_level": 5},
		{"source": "eagle_eye", "target": "damage", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("deadeye", "ranger", "Archery", "Deadeye", 24, 20, "passive", "Increases critical damage.", {"critical_damage": {"base": 5, "per_level": 3}}, [
		{"source": "eagle_eye", "target": "critical_damage", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("rain_of_arrows", "ranger", "Archery", "Rain of Arrows", 30, 20, "ultimate", "Area barrage of arrows.", {"damage": {"base": 70, "per_level": 12}}, [
		{"source": "multi_shot", "target": "damage", "type": "percent", "per_level": 7},
		{"source": "deadeye", "target": "damage", "type": "percent", "per_level": 5}
	]))

	# =========================
	# RANGER - TRAPS
	# =========================
	add_skill(make_skill("spike_trap", "ranger", "Traps", "Spike Trap", 1, 20, "active", "Places a trap that damages enemies.", {"damage": {"base": 14, "per_level": 4}}, [
		{"source": "trap_mastery", "target": "damage", "type": "percent", "per_level": 8}
	]))

	add_skill(make_skill("smoke_trap", "ranger", "Traps", "Smoke Trap", 6, 20, "active", "Slows and blinds enemies.", {"slow_percent": {"base": 15, "per_level": 1}, "duration": {"base": 4, "per_level": 0.2}}, [
		{"source": "trap_mastery", "target": "duration", "type": "flat", "per_level": 0.1}
	]))

	add_skill(make_skill("trap_mastery", "ranger", "Traps", "Trap Mastery", 12, 20, "passive", "Increases trap damage and trigger radius.", {"trap_damage_percent": {"base": 5, "per_level": 2}, "trap_radius": {"base": 1, "per_level": 0.05}}, []))

	add_skill(make_skill("poison_trap", "ranger", "Traps", "Poison Trap", 18, 20, "active", "Leaves poison cloud.", {"poison_damage": {"base": 20, "per_level": 7}}, [
		{"source": "spike_trap", "target": "poison_damage", "type": "percent", "per_level": 5},
		{"source": "trap_mastery", "target": "poison_damage", "type": "percent", "per_level": 8}
	]))

	add_skill(make_skill("quick_setup", "ranger", "Traps", "Quick Setup", 24, 20, "passive", "Reduces trap cooldowns.", {"cooldown_reduction": {"base": 3, "per_level": 1}}, [
		{"source": "trap_mastery", "target": "cooldown_reduction", "type": "flat", "per_level": 0.5}
	]))

	add_skill(make_skill("death_field", "ranger", "Traps", "Death Field", 30, 20, "ultimate", "Places multiple traps around the player.", {"damage": {"base": 60, "per_level": 10}, "trap_count": {"base": 4, "per_level": 0.2}}, [
		{"source": "poison_trap", "target": "damage", "type": "percent", "per_level": 6},
		{"source": "quick_setup", "target": "trap_count", "type": "flat", "per_level": 0.05}
	]))

	# =========================
	# RANGER - BEASTCRAFT
	# =========================
	add_skill(make_skill("summon_wolf", "ranger", "Beastcraft", "Summon Wolf", 1, 20, "active", "Summons a wolf companion.", {"wolf_health": {"base": 45, "per_level": 12}, "wolf_damage": {"base": 8, "per_level": 3}}, [
		{"source": "pack_instinct", "target": "wolf_damage", "type": "percent", "per_level": 8}
	]))

	add_skill(make_skill("hunters_mark", "ranger", "Beastcraft", "Hunter's Mark", 6, 20, "active", "Marked enemy takes more damage.", {"damage_taken_bonus": {"base": 8, "per_level": 2}}, [
		{"source": "predators_focus", "target": "damage_taken_bonus", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("pack_instinct", "ranger", "Beastcraft", "Pack Instinct", 12, 20, "passive", "Companion and player gain attack speed.", {"attack_speed": {"base": 2, "per_level": 1}}, []))

	add_skill(make_skill("venom_fang", "ranger", "Beastcraft", "Venom Fang", 18, 20, "active", "Companion attacks poison enemies.", {"poison_damage": {"base": 12, "per_level": 5}}, [
		{"source": "summon_wolf", "target": "poison_damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("predators_focus", "ranger", "Beastcraft", "Predator's Focus", 24, 20, "passive", "Bonus damage against marked enemies.", {"marked_damage_percent": {"base": 5, "per_level": 2}}, [
		{"source": "hunters_mark", "target": "marked_damage_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("spirit_beast", "ranger", "Beastcraft", "Spirit Beast", 30, 20, "ultimate", "Empowers companion into a stronger form.", {"wolf_damage": {"base": 35, "per_level": 10}, "wolf_health": {"base": 100, "per_level": 25}}, [
		{"source": "summon_wolf", "target": "wolf_health", "type": "percent", "per_level": 8},
		{"source": "venom_fang", "target": "wolf_damage", "type": "percent", "per_level": 8}
	]))

	# =========================
	# SORCERER - FIRE
	# =========================
	add_skill(make_skill("fire_bolt", "sorcerer", "Fire", "Fire Bolt", 1, 20, "active", "Basic fire projectile.", {"fire_damage": {"base": 12, "per_level": 5}, "mana_cost": {"base": 5, "per_level": 0}}, [
		{"source": "burning_mind", "target": "fire_damage", "type": "percent", "per_level": 8},
		{"source": "ignite_mastery", "target": "fire_damage", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("flame_wave", "sorcerer", "Fire", "Flame Wave", 6, 20, "active", "Cone of fire damage.", {"fire_damage": {"base": 22, "per_level": 7}, "mana_cost": {"base": 10, "per_level": 1}}, [
		{"source": "fire_bolt", "target": "fire_damage", "type": "percent", "per_level": 6},
		{"source": "burning_mind", "target": "fire_damage", "type": "percent", "per_level": 7}
	]))

	add_skill(make_skill("burning_mind", "sorcerer", "Fire", "Burning Mind", 12, 20, "passive", "Increases fire damage.", {"fire_damage_percent": {"base": 5, "per_level": 2}}, []))

	add_skill(make_skill("meteor_shard", "sorcerer", "Fire", "Meteor Shard", 18, 20, "active", "Delayed impact fire spell.", {"fire_damage": {"base": 55, "per_level": 12}, "mana_cost": {"base": 18, "per_level": 1}}, [
		{"source": "flame_wave", "target": "fire_damage", "type": "percent", "per_level": 6},
		{"source": "ignite_mastery", "target": "fire_damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("ignite_mastery", "sorcerer", "Fire", "Ignite Mastery", 24, 20, "passive", "Fire spells can burn enemies.", {"ignite_chance": {"base": 5, "per_level": 2}, "burn_damage": {"base": 3, "per_level": 2}}, [
		{"source": "burning_mind", "target": "burn_damage", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("inferno_storm", "sorcerer", "Fire", "Inferno Storm", 30, 20, "ultimate", "Large fire storm area spell.", {"fire_damage": {"base": 90, "per_level": 18}, "mana_cost": {"base": 35, "per_level": 2}}, [
		{"source": "fire_bolt", "target": "fire_damage", "type": "percent", "per_level": 4},
		{"source": "flame_wave", "target": "fire_damage", "type": "percent", "per_level": 4},
		{"source": "meteor_shard", "target": "fire_damage", "type": "percent", "per_level": 4}
	]))

	# =========================
	# SORCERER - FROST
	# =========================
	add_skill(make_skill("frost_bolt", "sorcerer", "Frost", "Frost Bolt", 1, 20, "active", "Cold projectile that slows.", {"cold_damage": {"base": 10, "per_level": 4}, "slow_percent": {"base": 15, "per_level": 1}}, [
		{"source": "frozen_heart", "target": "cold_damage", "type": "percent", "per_level": 8}
	]))

	add_skill(make_skill("ice_armor", "sorcerer", "Frost", "Ice Armor", 6, 20, "active", "Temporary defense shield.", {"shield_amount": {"base": 25, "per_level": 8}}, [
		{"source": "frozen_heart", "target": "shield_amount", "type": "percent", "per_level": 7}
	]))

	add_skill(make_skill("frozen_heart", "sorcerer", "Frost", "Frozen Heart", 12, 20, "passive", "Increases cold damage and slow strength.", {"cold_damage_percent": {"base": 5, "per_level": 2}, "slow_bonus": {"base": 1, "per_level": 1}}, []))

	add_skill(make_skill("frost_nova", "sorcerer", "Frost", "Frost Nova", 18, 20, "active", "Expanding cold burst around player.", {"cold_damage": {"base": 35, "per_level": 9}, "slow_percent": {"base": 25, "per_level": 1}}, [
		{"source": "frost_bolt", "target": "cold_damage", "type": "percent", "per_level": 6},
		{"source": "frozen_heart", "target": "cold_damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("shatter", "sorcerer", "Frost", "Shatter", 24, 20, "passive", "Bonus damage to chilled enemies.", {"chilled_damage_bonus": {"base": 5, "per_level": 2}}, [
		{"source": "frost_nova", "target": "chilled_damage_bonus", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("glacial_prison", "sorcerer", "Frost", "Glacial Prison", 30, 20, "ultimate", "Freezes or heavily slows enemies in an area.", {"cold_damage": {"base": 70, "per_level": 15}, "freeze_chance": {"base": 20, "per_level": 1}}, [
		{"source": "frost_nova", "target": "cold_damage", "type": "percent", "per_level": 7},
		{"source": "shatter", "target": "cold_damage", "type": "percent", "per_level": 5}
	]))

	# =========================
	# SORCERER - STORM
	# =========================
	add_skill(make_skill("spark", "sorcerer", "Storm", "Spark", 1, 20, "active", "Lightning projectile.", {"lightning_damage": {"base": 6, "per_level": 5}}, [
		{"source": "static_charge", "target": "lightning_damage", "type": "percent", "per_level": 8}
	]))

	add_skill(make_skill("chain_lightning", "sorcerer", "Storm", "Chain Lightning", 6, 20, "active", "Lightning jumps between enemies.", {"lightning_damage": {"base": 18, "per_level": 7}, "chain_count": {"base": 2, "per_level": 0.15}}, [
		{"source": "spark", "target": "lightning_damage", "type": "percent", "per_level": 6},
		{"source": "static_charge", "target": "lightning_damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("static_charge", "sorcerer", "Storm", "Static Charge", 12, 20, "passive", "Lightning hits can shock enemies.", {"shock_chance": {"base": 5, "per_level": 2}}, []))

	add_skill(make_skill("storm_step", "sorcerer", "Storm", "Storm Step", 18, 20, "active", "Short teleport or dash with lightning burst.", {"lightning_damage": {"base": 25, "per_level": 8}, "range": {"base": 4, "per_level": 0.1}}, [
		{"source": "spark", "target": "lightning_damage", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("overload", "sorcerer", "Storm", "Overload", 24, 20, "passive", "Chance for lightning spells to strike twice.", {"double_cast_chance": {"base": 3, "per_level": 1}}, [
		{"source": "static_charge", "target": "double_cast_chance", "type": "flat", "per_level": 0.5}
	]))

	add_skill(make_skill("thunderfall", "sorcerer", "Storm", "Thunderfall", 30, 20, "ultimate", "Repeated lightning strikes in an area.", {"lightning_damage": {"base": 85, "per_level": 17}}, [
		{"source": "chain_lightning", "target": "lightning_damage", "type": "percent", "per_level": 6},
		{"source": "overload", "target": "lightning_damage", "type": "percent", "per_level": 6}
	]))

	# =========================
	# CLERIC - HOLY LIGHT
	# =========================
	add_skill(make_skill("smite", "cleric", "Holy Light", "Smite", 1, 20, "active", "Holy damage strike or projectile.", {"holy_damage": {"base": 12, "per_level": 4}}, [
		{"source": "blessed_power", "target": "holy_damage", "type": "percent", "per_level": 8}
	]))

	add_skill(make_skill("heal", "cleric", "Holy Light", "Heal", 6, 20, "active", "Restores health.", {"healing": {"base": 25, "per_level": 8}}, [
		{"source": "blessed_power", "target": "healing", "type": "percent", "per_level": 6},
		{"source": "divine_favor", "target": "healing", "type": "percent", "per_level": 8}
	]))

	add_skill(make_skill("blessed_power", "cleric", "Holy Light", "Blessed Power", 12, 20, "passive", "Increases holy damage and healing.", {"holy_damage_percent": {"base": 4, "per_level": 2}, "healing_percent": {"base": 4, "per_level": 2}}, []))

	add_skill(make_skill("radiant_burst", "cleric", "Holy Light", "Radiant Burst", 18, 20, "active", "Damages enemies and heals the player slightly.", {"holy_damage": {"base": 35, "per_level": 9}, "healing": {"base": 10, "per_level": 4}}, [
		{"source": "smite", "target": "holy_damage", "type": "percent", "per_level": 5},
		{"source": "heal", "target": "healing", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("divine_favor", "cleric", "Holy Light", "Divine Favor", 24, 20, "passive", "Healing effects are stronger.", {"healing_percent": {"base": 5, "per_level": 2}}, [
		{"source": "heal", "target": "healing_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("wrath_of_light", "cleric", "Holy Light", "Wrath of Light", 30, 20, "ultimate", "Large holy explosion around player.", {"holy_damage": {"base": 80, "per_level": 16}, "healing": {"base": 25, "per_level": 8}}, [
		{"source": "radiant_burst", "target": "holy_damage", "type": "percent", "per_level": 6},
		{"source": "blessed_power", "target": "holy_damage", "type": "percent", "per_level": 6}
	]))

	# =========================
	# CLERIC - PROTECTION
	# =========================
	add_skill(make_skill("barrier", "cleric", "Protection", "Barrier", 1, 20, "active", "Temporary damage shield.", {"shield_amount": {"base": 30, "per_level": 8}}, [
		{"source": "guardians_resolve", "target": "shield_amount", "type": "percent", "per_level": 7}
	]))

	add_skill(make_skill("shield_of_faith", "cleric", "Protection", "Shield of Faith", 6, 20, "active", "Increases armor and resistances.", {"defense_bonus_percent": {"base": 10, "per_level": 2}, "all_resistances": {"base": 5, "per_level": 1}}, [
		{"source": "barrier", "target": "defense_bonus_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("guardians_resolve", "cleric", "Protection", "Guardian's Resolve", 12, 20, "passive", "Increases block chance and defense.", {"block_chance": {"base": 2, "per_level": 1}, "defense_bonus_percent": {"base": 4, "per_level": 2}}, []))

	add_skill(make_skill("cleanse", "cleric", "Protection", "Cleanse", 18, 20, "active", "Removes poison and curse effects.", {"cleanse_strength": {"base": 1, "per_level": 1}}, [
		{"source": "shield_of_faith", "target": "cleanse_strength", "type": "flat", "per_level": 0.2}
	]))

	add_skill(make_skill("sacred_ground", "cleric", "Protection", "Sacred Ground", 24, 20, "active", "Creates an area that heals and protects.", {"healing": {"base": 12, "per_level": 5}, "damage_reduction": {"base": 5, "per_level": 1}}, [
		{"source": "barrier", "target": "healing", "type": "percent", "per_level": 6},
		{"source": "shield_of_faith", "target": "damage_reduction", "type": "flat", "per_level": 0.5}
	]))

	add_skill(make_skill("divine_bulwark", "cleric", "Protection", "Divine Bulwark", 30, 20, "ultimate", "Major defense boost and damage reduction.", {"damage_reduction": {"base": 20, "per_level": 2}, "duration": {"base": 5, "per_level": 0.2}}, [
		{"source": "guardians_resolve", "target": "damage_reduction", "type": "flat", "per_level": 0.5},
		{"source": "sacred_ground", "target": "duration", "type": "flat", "per_level": 0.05}
	]))

	# =========================
	# CLERIC - JUDGMENT
	# =========================
	add_skill(make_skill("judgment_strike", "cleric", "Judgment", "Judgment Strike", 1, 20, "active", "Holy weapon attack.", {"holy_damage": {"base": 14, "per_level": 5}}, [
		{"source": "zeal", "target": "holy_damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("mark_of_judgment", "cleric", "Judgment", "Mark of Judgment", 6, 20, "active", "Marked enemies take increased damage.", {"damage_taken_bonus": {"base": 8, "per_level": 2}}, [
		{"source": "condemn", "target": "damage_taken_bonus", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("zeal", "cleric", "Judgment", "Zeal", 12, 20, "passive", "Increases attack speed after using holy skills.", {"attack_speed": {"base": 3, "per_level": 1}}, []))

	add_skill(make_skill("hammer_of_faith", "cleric", "Judgment", "Hammer of Faith", 18, 20, "active", "Throws a holy hammer.", {"holy_damage": {"base": 35, "per_level": 9}}, [
		{"source": "judgment_strike", "target": "holy_damage", "type": "percent", "per_level": 6},
		{"source": "zeal", "target": "holy_damage", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("condemn", "cleric", "Judgment", "Condemn", 24, 20, "passive", "Bonus damage to marked enemies.", {"marked_damage_percent": {"base": 5, "per_level": 2}}, [
		{"source": "mark_of_judgment", "target": "marked_damage_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("final_judgment", "cleric", "Judgment", "Final Judgment", 30, 20, "ultimate", "Massive holy strike on marked enemies.", {"holy_damage": {"base": 90, "per_level": 18}}, [
		{"source": "hammer_of_faith", "target": "holy_damage", "type": "percent", "per_level": 6},
		{"source": "condemn", "target": "holy_damage", "type": "percent", "per_level": 6}
	]))

	# =========================
	# VEILWALKER - GRAVECRAFT
	# =========================
	add_skill(make_skill("raise_skeleton", "veilwalker", "Gravecraft", "Raise Skeleton", 1, 20, "active", "Summons a skeleton warrior.", {"skeleton_health": {"base": 35, "per_level": 12}, "skeleton_damage": {"base": 6, "per_level": 3}, "max_skeletons": {"base": 1, "per_level": 0.1}}, [
		{"source": "skeleton_mastery", "target": "skeleton_health", "type": "percent", "per_level": 10},
		{"source": "skeleton_mastery", "target": "skeleton_damage", "type": "percent", "per_level": 10},
		{"source": "bone_commander", "target": "max_skeletons", "type": "flat", "per_level": 0.05}
	]))

	add_skill(make_skill("skeleton_mastery", "veilwalker", "Gravecraft", "Skeleton Mastery", 6, 20, "passive", "Increases skeleton damage and health.", {"summon_health_percent": {"base": 8, "per_level": 3}, "summon_damage_percent": {"base": 8, "per_level": 3}}, [
		{"source": "raise_skeleton", "target": "summon_health_percent", "type": "flat", "per_level": 1},
		{"source": "raise_archer", "target": "summon_damage_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("raise_archer", "veilwalker", "Gravecraft", "Raise Archer", 12, 20, "active", "Summons a skeleton archer.", {"archer_health": {"base": 25, "per_level": 9}, "archer_damage": {"base": 9, "per_level": 4}}, [
		{"source": "skeleton_mastery", "target": "archer_health", "type": "percent", "per_level": 8},
		{"source": "skeleton_mastery", "target": "archer_damage", "type": "percent", "per_level": 8}
	]))

	add_skill(make_skill("bone_commander", "veilwalker", "Gravecraft", "Bone Commander", 18, 20, "passive", "Increases max skeleton count and summon damage.", {"max_skeletons_bonus": {"base": 1, "per_level": 0.1}, "summon_damage_percent": {"base": 5, "per_level": 2}}, [
		{"source": "raise_skeleton", "target": "summon_damage_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("grave_pact", "veilwalker", "Gravecraft", "Grave Pact", 24, 20, "active", "Sacrifice a minion to restore health or mana.", {"healing": {"base": 30, "per_level": 10}, "mana_restore": {"base": 15, "per_level": 5}}, [
		{"source": "skeleton_mastery", "target": "healing", "type": "percent", "per_level": 5},
		{"source": "bone_commander", "target": "mana_restore", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("army_of_the_dead", "veilwalker", "Gravecraft", "Army of the Dead", 30, 20, "ultimate", "Temporarily summons several skeletons.", {"summon_count": {"base": 4, "per_level": 0.25}, "summon_duration": {"base": 12, "per_level": 0.5}}, [
		{"source": "raise_skeleton", "target": "summon_count", "type": "flat", "per_level": 0.05},
		{"source": "bone_commander", "target": "summon_duration", "type": "flat", "per_level": 0.1}
	]))

	# =========================
	# VEILWALKER - BLIGHT
	# =========================
	add_skill(make_skill("poison_bolt", "veilwalker", "Blight", "Poison Bolt", 1, 20, "active", "Projectile that poisons enemies.", {"poison_damage": {"base": 10, "per_level": 5}, "duration": {"base": 4, "per_level": 0.1}}, [
		{"source": "venom_mastery", "target": "poison_damage", "type": "percent", "per_level": 10},
		{"source": "toxic_cloud", "target": "poison_damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("toxic_cloud", "veilwalker", "Blight", "Toxic Cloud", 6, 20, "active", "Poison area on the ground.", {"poison_damage": {"base": 18, "per_level": 7}, "duration": {"base": 5, "per_level": 0.15}}, [
		{"source": "poison_bolt", "target": "poison_damage", "type": "percent", "per_level": 6},
		{"source": "venom_mastery", "target": "duration", "type": "flat", "per_level": 0.1}
	]))

	add_skill(make_skill("venom_mastery", "veilwalker", "Blight", "Venom Mastery", 12, 20, "passive", "Increases poison damage and duration.", {"poison_damage_percent": {"base": 6, "per_level": 3}, "poison_duration_bonus": {"base": 3, "per_level": 1}}, []))

	add_skill(make_skill("plague_touch", "veilwalker", "Blight", "Plague Touch", 18, 20, "active", "Close-range poison burst.", {"poison_damage": {"base": 35, "per_level": 10}}, [
		{"source": "poison_bolt", "target": "poison_damage", "type": "percent", "per_level": 5},
		{"source": "toxic_cloud", "target": "poison_damage", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("withering_venom", "veilwalker", "Blight", "Withering Venom", 24, 20, "passive", "Poisoned enemies deal reduced damage.", {"enemy_damage_reduction": {"base": 5, "per_level": 2}}, [
		{"source": "venom_mastery", "target": "enemy_damage_reduction", "type": "flat", "per_level": 0.5}
	]))

	add_skill(make_skill("plague_nova", "veilwalker", "Blight", "Plague Nova", 30, 20, "ultimate", "Large poison explosion around player.", {"poison_damage": {"base": 80, "per_level": 18}}, [
		{"source": "poison_bolt", "target": "poison_damage", "type": "percent", "per_level": 5},
		{"source": "toxic_cloud", "target": "poison_damage", "type": "percent", "per_level": 5},
		{"source": "plague_touch", "target": "poison_damage", "type": "percent", "per_level": 5}
	]))

	# =========================
	# VEILWALKER - VEIL MAGIC
	# =========================
	add_skill(make_skill("veil_bolt", "veilwalker", "Veil Magic", "Veil Bolt", 1, 20, "active", "Dark magic projectile.", {"shadow_damage": {"base": 12, "per_level": 5}}, [
		{"source": "soul_harvest", "target": "shadow_damage", "type": "percent", "per_level": 8},
		{"source": "dark_pact", "target": "shadow_damage", "type": "percent", "per_level": 6}
	]))

	add_skill(make_skill("bone_armor", "veilwalker", "Veil Magic", "Bone Armor", 6, 20, "active", "Absorbs damage.", {"shield_amount": {"base": 30, "per_level": 9}}, [
		{"source": "soul_harvest", "target": "shield_amount", "type": "percent", "per_level": 5}
	]))

	add_skill(make_skill("soul_harvest", "veilwalker", "Veil Magic", "Soul Harvest", 12, 20, "passive", "Enemies restore mana when killed.", {"mana_on_kill": {"base": 2, "per_level": 1}}, [
		{"source": "veil_bolt", "target": "mana_on_kill", "type": "flat", "per_level": 0.2}
	]))

	add_skill(make_skill("curse_of_frailty", "veilwalker", "Veil Magic", "Curse of Frailty", 18, 20, "active", "Weakens enemy damage and defense.", {"enemy_damage_reduction": {"base": 8, "per_level": 2}, "enemy_defense_reduction": {"base": 8, "per_level": 2}}, [
		{"source": "veil_bolt", "target": "enemy_defense_reduction", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("dark_pact", "veilwalker", "Veil Magic", "Dark Pact", 24, 20, "passive", "Spending mana increases dark damage briefly.", {"shadow_damage_percent": {"base": 5, "per_level": 2}}, [
		{"source": "soul_harvest", "target": "shadow_damage_percent", "type": "flat", "per_level": 1}
	]))

	add_skill(make_skill("corpse_burst", "veilwalker", "Veil Magic", "Corpse Burst", 30, 20, "ultimate", "Explodes defeated enemies for area damage.", {"shadow_damage": {"base": 90, "per_level": 18}}, [
		{"source": "veil_bolt", "target": "shadow_damage", "type": "percent", "per_level": 6},
		{"source": "curse_of_frailty", "target": "shadow_damage", "type": "percent", "per_level": 6}
	]))
