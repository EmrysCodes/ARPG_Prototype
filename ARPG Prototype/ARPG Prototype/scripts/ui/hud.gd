extends CanvasLayer

@onready var inventory_button = get_node_or_null("InventoryButton")
@onready var inventory_panel = get_node_or_null("InventoryPanel")
@onready var close_button = get_node_or_null("InventoryPanel/CloseButton")

@onready var character_button = get_node_or_null("CharacterButton")
@onready var character_panel = get_node_or_null("CharacterPanel")
@onready var close_character_button = get_node_or_null("CharacterPanel/CloseCharacterButton")

@onready var skills_button = get_node_or_null("SkillsButton")
@onready var skills_panel = get_node_or_null("SkillsPanel")
@onready var close_skills_button = get_node_or_null("SkillsPanel/CloseSkillsButton")
@onready var skill_points_label = get_node_or_null("SkillsPanel/SkillPointsLabel")
@onready var class_skill_label = get_node_or_null("SkillsPanel/ClassSkillLabel")
@onready var skill_list = get_node_or_null("SkillsPanel/SkillScroll/SkillList")

@onready var character_level_label = get_node_or_null("CharacterPanel/LevelLabel")
@onready var stat_points_text = get_node_or_null("CharacterPanel/StatPointsText")
@onready var stat_points_label = get_node_or_null("CharacterPanel/StatPointsLabel")
@onready var class_label = get_node_or_null("CharacterPanel/ClassLabel")

@onready var strength_label = get_node_or_null("CharacterPanel/StrengthLabel")
@onready var dexterity_label = get_node_or_null("CharacterPanel/DexterityLabel")
@onready var vitality_label = get_node_or_null("CharacterPanel/VitalityLabel")
@onready var devotion_label = get_node_or_null("CharacterPanel/DevotionLabel")

@onready var strength_button = get_node_or_null("CharacterPanel/StrengthButton")
@onready var dexterity_button = get_node_or_null("CharacterPanel/DexterityButton")
@onready var vitality_button = get_node_or_null("CharacterPanel/VitalityButton")
@onready var devotion_button = get_node_or_null("CharacterPanel/DevotionButton")

@onready var status_panel = get_node_or_null("StatusPanel")
@onready var health_label = get_node_or_null("StatusPanel/HealthLabel")
@onready var mana_label = get_node_or_null("StatusPanel/ManaLabel")
@onready var level_label = get_node_or_null("StatusPanel/LevelLabel")
@onready var gold_label = get_node_or_null("StatusPanel/GoldLabel")
@onready var xp_bar = get_node_or_null("StatusPanel/XPBar")
@onready var xp_label = get_node_or_null("StatusPanel/XPLabel")

@onready var summon_skeleton_button = get_first_node([
	"SummonSkeletonButton",
	"StatusPanel/SummonSkeletonButton",
	"StatusBar/SummonSkeletonButton"
])

@onready var equipment_panel = get_node_or_null("InventoryPanel/EquipmentPanel")
@onready var bag_grid = get_node_or_null("InventoryPanel/BagPanel/BagGrid")

@onready var tooltip_panel = get_node_or_null("InventoryPanel/TooltipPanel")
@onready var item_name_label = get_node_or_null("InventoryPanel/TooltipPanel/TooltipContainer/ItemNameLabel")
@onready var rarity_label = get_node_or_null("InventoryPanel/TooltipPanel/TooltipContainer/RarityLabel")
@onready var type_label = get_node_or_null("InventoryPanel/TooltipPanel/TooltipContainer/TypeLabel")
@onready var stats_label = get_node_or_null("InventoryPanel/TooltipPanel/TooltipContainer/StatsLabel")
@onready var equip_button = get_node_or_null("InventoryPanel/TooltipPanel/TooltipContainer/EquipButton")

var player = null
var selected_item = null
var selected_slot_button = null
var selected_item_source: String = ""

var dragging_item = null
var dragging_from_index: int = -1
var dragging_origin_slot = null
var current_hover_slot = null


func get_first_node(paths: Array):
	for path in paths:
		var found = get_node_or_null(path)
		if found != null:
			return found

	return null


func _ready():
	if inventory_panel:
		inventory_panel.visible = false

	if character_panel:
		character_panel.visible = false

	if skills_panel:
		skills_panel.visible = false

	if tooltip_panel:
		tooltip_panel.visible = false

	if inventory_button:
		inventory_button.pressed.connect(_on_inventory_button_pressed)

	if close_button:
		close_button.pressed.connect(_on_close_button_pressed)

	if character_button:
		character_button.pressed.connect(_on_character_button_pressed)

	if close_character_button:
		close_character_button.pressed.connect(_on_close_character_button_pressed)

	if skills_button:
		skills_button.pressed.connect(_on_skills_button_pressed)

	if close_skills_button:
		close_skills_button.pressed.connect(_on_close_skills_button_pressed)

	if strength_button:
		strength_button.pressed.connect(_on_strength_pressed)

	if dexterity_button:
		dexterity_button.pressed.connect(_on_dexterity_pressed)

	if vitality_button:
		vitality_button.pressed.connect(_on_vitality_pressed)

	if devotion_button:
		devotion_button.pressed.connect(_on_devotion_pressed)

	if equip_button:
		equip_button.pressed.connect(_on_equip_pressed)

	if summon_skeleton_button:
		summon_skeleton_button.pressed.connect(_on_summon_skeleton_pressed)
		print("SummonSkeletonButton connected.")
	else:
		print("WARNING: SummonSkeletonButton not found. Name the button exactly SummonSkeletonButton.")

	setup_equipment_slot_buttons()


func set_player(new_player):
	player = new_player

	if player == null:
		player = get_tree().get_first_node_in_group("player")

	refresh_inventory()
	refresh_status()
	refresh_character_panel()
	refresh_skills_panel()


func resolve_player():
	if player != null and is_instance_valid(player):
		return player

	player = get_tree().get_first_node_in_group("player")
	return player


func _on_inventory_button_pressed():
	if inventory_panel:
		inventory_panel.visible = true

	if skills_panel:
		skills_panel.visible = false

	refresh_inventory()
	refresh_status()


func _on_close_button_pressed():
	if inventory_panel:
		inventory_panel.visible = false

	clear_selected_item()
	cancel_drag()


func _on_character_button_pressed():
	if character_panel:
		character_panel.visible = true

	if skills_panel:
		skills_panel.visible = false

	refresh_character_panel()
	refresh_status()


func _on_close_character_button_pressed():
	if character_panel:
		character_panel.visible = false


func _on_skills_button_pressed():
	if skills_panel:
		skills_panel.visible = true

	if inventory_panel:
		inventory_panel.visible = false

	if character_panel:
		character_panel.visible = false

	refresh_skills_panel()
	refresh_status()


func _on_close_skills_button_pressed():
	if skills_panel:
		skills_panel.visible = false


func _on_summon_skeleton_pressed():
	var p = resolve_player()

	if p == null:
		print("Summon failed: player is null.")
		return

	if p.has_method("cast_raise_skeleton"):
		p.cast_raise_skeleton()
	else:
		print("Summon failed: player missing cast_raise_skeleton().")


func get_inventory():
	var p = resolve_player()

	if p == null:
		return null

	return p.get_node_or_null("Inventory")


func get_stats():
	var p = resolve_player()

	if p == null:
		return null

	return p.get_node_or_null("PlayerStats")


func get_skills():
	var p = resolve_player()

	if p == null:
		return null

	return p.get_node_or_null("PlayerSkills")


func refresh_status():
	var stats = get_stats()
	var inventory = get_inventory()

	if stats:
		if health_label:
			health_label.text = "HP: " + str(stats.current_health) + "/" + str(stats.max_health)

		if mana_label:
			mana_label.text = "MP: " + str(stats.current_mana) + "/" + str(stats.max_mana)

		if level_label:
			level_label.text = "Lv. " + str(stats.level)

		if xp_bar:
			xp_bar.min_value = 0
			xp_bar.max_value = stats.experience_to_next_level
			xp_bar.value = stats.experience

		if xp_label:
			xp_label.text = "XP: " + str(stats.experience) + "/" + str(stats.experience_to_next_level)

		if summon_skeleton_button:
			var is_veilwalker = stats.player_class == "veilwalker"
			summon_skeleton_button.visible = is_veilwalker
			summon_skeleton_button.disabled = not is_veilwalker

	if inventory and gold_label:
		gold_label.text = "Gold: " + str(inventory.gold)


func refresh_character_panel():
	var stats = get_stats()

	if stats == null:
		return

	if class_label:
		class_label.text = str(stats.class_display_name)

	if character_level_label:
		character_level_label.text = str(stats.level)

	if stat_points_label:
		stat_points_label.text = str(stats.unspent_stat_points)

	var has_points = stats.unspent_stat_points > 0

	if stat_points_text:
		stat_points_text.visible = has_points

	if stat_points_label:
		stat_points_label.visible = has_points

	if strength_label:
		strength_label.text = str(stats.strength)

	if dexterity_label:
		dexterity_label.text = str(stats.dexterity)

	if vitality_label:
		vitality_label.text = str(stats.vitality)

	if devotion_label:
		devotion_label.text = str(stats.devotion)

	if strength_button:
		strength_button.disabled = not has_points
		strength_button.visible = has_points

	if dexterity_button:
		dexterity_button.disabled = not has_points
		dexterity_button.visible = has_points

	if vitality_button:
		vitality_button.disabled = not has_points
		vitality_button.visible = has_points

	if devotion_button:
		devotion_button.disabled = not has_points
		devotion_button.visible = has_points


func refresh_skills_panel():
	var stats = get_stats()
	var skills = get_skills()

	if skills == null or stats == null:
		return

	if skill_points_label:
		skill_points_label.text = str(skills.skill_points)

	if class_skill_label:
		class_skill_label.text = str(stats.class_display_name)

	if skill_list == null:
		return

	for child in skill_list.get_children():
		child.queue_free()

	var class_db = skills.class_db
	var trees = class_db.get_trees_for_class(skills.current_class_id)

	for tree_name in trees:
		var tree_header = Label.new()
		tree_header.text = tree_name
		tree_header.add_theme_font_size_override("font_size", 28)
		skill_list.add_child(tree_header)

		for skill in skills.get_skills_by_tree(tree_name):
			skill_list.add_child(make_skill_row(skill, skills, stats))


func make_skill_row(skill: Dictionary, skills, stats) -> Control:
	var skill_id = skill.get("id", "")
	var hard_level = skills.get_hard_skill_level(skill_id)
	var total_level = skills.get_total_skill_level(skill_id)
	var required_level = int(skill.get("required_level", 1))
	var can_spend = skills.can_spend_point(skill_id, stats.level)

	var row = PanelContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	row.add_child(margin)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(hbox)

	var info = VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(info)

	var title = Label.new()
	title.text = "%s  (Req Lv %d)" % [skill.get("name", skill_id), required_level]
	title.add_theme_font_size_override("font_size", 22)
	info.add_child(title)

	var meta = Label.new()
	meta.text = "%s  |  Lv %d" % [str(skill.get("skill_type", "")).capitalize(), total_level]
	if total_level != hard_level:
		meta.text += " (%d hard)" % hard_level
	meta.add_theme_font_size_override("font_size", 18)
	info.add_child(meta)

	var desc = Label.new()
	desc.text = skill.get("description", "")
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_font_size_override("font_size", 18)
	info.add_child(desc)

	var syn_text = format_synergies(skill)
	if syn_text != "":
		var syn = Label.new()
		syn.text = syn_text
		syn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		syn.add_theme_font_size_override("font_size", 16)
		syn.modulate = Color(0.75, 0.85, 1.0)
		info.add_child(syn)

	var effects = skills.get_skill_effect(skill_id)
	if not effects.is_empty():
		var effect_label = Label.new()
		effect_label.text = format_effects(effects)
		effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		effect_label.add_theme_font_size_override("font_size", 16)
		effect_label.modulate = Color(0.85, 1.0, 0.8)
		info.add_child(effect_label)

	var plus_button = Button.new()
	plus_button.text = "+"
	plus_button.custom_minimum_size = Vector2(72, 72)
	plus_button.disabled = not can_spend
	plus_button.pressed.connect(_on_skill_plus_pressed.bind(skill_id))
	hbox.add_child(plus_button)

	return row


func format_synergies(skill: Dictionary) -> String:
	var synergies = skill.get("synergies", [])
	if synergies.is_empty():
		return ""

	var parts: Array = []
	for synergy in synergies:
		var source = synergy.get("source", "")
		var target = synergy.get("target", "")
		var per_level = synergy.get("per_level", 0)
		var syn_type = synergy.get("type", "percent")
		var unit = "%" if syn_type == "percent" else ""
		parts.append("%s → %s +%s%s/lvl" % [source, target, str(per_level), unit])

	return "Synergies: " + ", ".join(parts)


func format_effects(effects: Dictionary) -> String:
	var parts: Array = []
	for key in effects.keys():
		var value = effects[key]
		if typeof(value) == TYPE_FLOAT:
			parts.append("%s: %.1f" % [key, value])
		else:
			parts.append("%s: %s" % [key, str(value)])
	return "Effects: " + ", ".join(parts)


func _on_skill_plus_pressed(skill_id: String):
	var stats = get_stats()
	var skills = get_skills()

	if stats == null or skills == null:
		return

	if skills.add_skill_level(skill_id, stats.level):
		refresh_skills_panel()
		refresh_status()
		refresh_character_panel()


func spend_stat_point(stat_name: String):
	var stats = get_stats()

	if stats == null:
		return

	stats.add_stat_point(stat_name)

	refresh_character_panel()
	refresh_status()


func _on_strength_pressed():
	spend_stat_point("strength")


func _on_dexterity_pressed():
	spend_stat_point("dexterity")


func _on_vitality_pressed():
	spend_stat_point("vitality")


func _on_devotion_pressed():
	spend_stat_point("devotion")


func clear_selected_item():
	selected_item = null
	selected_slot_button = null
	selected_item_source = ""

	if tooltip_panel:
		tooltip_panel.visible = false


func setup_equipment_slot_buttons():
	if equipment_panel == null:
		return

	for slot in equipment_panel.get_children():
		if slot is Button:
			if not slot.pressed.is_connected(_on_equipment_slot_pressed.bind(slot)):
				slot.pressed.connect(_on_equipment_slot_pressed.bind(slot))


func _input(event):
	if inventory_panel == null or not inventory_panel.visible:
		return

	if event is InputEventScreenTouch:
		if event.pressed:
			handle_touch_press(event.position)
		else:
			handle_touch_release(event.position)

	if event is InputEventScreenDrag:
		handle_touch_drag(event.position)

	if event is InputEventMouseButton:
		if event.pressed:
			handle_touch_press(event.position)
		else:
			handle_touch_release(event.position)


func handle_touch_press(screen_pos: Vector2):
	var bag_slot = get_bag_slot_at_position(screen_pos)

	if bag_slot != null and bag_slot.has_meta("item_data"):
		selected_item = bag_slot.get_meta("item_data")
		selected_slot_button = bag_slot
		selected_item_source = "bag"

		show_tooltip(selected_item, bag_slot)
		return

	var equipment_slot = get_equipment_slot_at_position(screen_pos)

	if equipment_slot != null and equipment_slot.has_meta("item_data"):
		selected_item = equipment_slot.get_meta("item_data")
		selected_slot_button = equipment_slot
		selected_item_source = "equipment"

		show_tooltip(selected_item, equipment_slot)
		return

	handle_click_away(screen_pos)


func handle_touch_drag(screen_pos: Vector2):
	if dragging_item == null and selected_slot_button != null and selected_slot_button.has_meta("item_data"):
		if is_bag_slot(selected_slot_button):
			start_drag_from_bag_slot(selected_slot_button)

	update_hover_slot(screen_pos)


func handle_touch_release(screen_pos: Vector2):
	if dragging_item == null:
		return

	var inventory = get_inventory()

	if inventory == null:
		cancel_drag()
		return

	var target_bag_slot = get_bag_slot_at_position(screen_pos)

	if target_bag_slot != null:
		var target_index = target_bag_slot.get_meta("bag_index")
		inventory.swap_items(dragging_from_index, target_index)
		finish_drag()
		return

	var target_equipment_slot = get_equipment_slot_at_position(screen_pos)

	if target_equipment_slot != null:
		var slot_name = target_equipment_slot.name
		inventory.equip_item_to_slot(dragging_item, slot_name)
		finish_drag()
		return

	cancel_drag()


func start_drag_from_bag_slot(slot_button):
	if not slot_button.has_meta("item_data"):
		return

	dragging_item = slot_button.get_meta("item_data")
	dragging_from_index = slot_button.get_meta("bag_index")
	dragging_origin_slot = slot_button

	if dragging_origin_slot:
		dragging_origin_slot.modulate = Color(1, 1, 1, 0.3)

	clear_selected_item()


func update_hover_slot(screen_pos: Vector2):
	var new_hover = get_bag_slot_at_position(screen_pos)

	if new_hover == null:
		new_hover = get_equipment_slot_at_position(screen_pos)

	if new_hover == current_hover_slot:
		return

	clear_hover_slot()

	current_hover_slot = new_hover

	if current_hover_slot:
		current_hover_slot.modulate = Color(1.2, 1.2, 1.2)


func clear_hover_slot():
	if current_hover_slot:
		current_hover_slot.modulate = Color(1, 1, 1)

	current_hover_slot = null


func finish_drag():
	cancel_drag()
	refresh_inventory()


func cancel_drag():
	if dragging_origin_slot:
		dragging_origin_slot.modulate = Color(1, 1, 1)

	clear_hover_slot()

	dragging_item = null
	dragging_from_index = -1
	dragging_origin_slot = null


func get_bag_slot_at_position(screen_pos: Vector2):
	if bag_grid == null:
		return null

	for slot in bag_grid.get_children():
		if slot is Button and slot.get_global_rect().has_point(screen_pos):
			return slot

	return null


func get_equipment_slot_at_position(screen_pos: Vector2):
	if equipment_panel == null:
		return null

	for slot in equipment_panel.get_children():
		if slot is Button and slot.get_global_rect().has_point(screen_pos):
			return slot

	return null


func is_bag_slot(slot_button):
	return bag_grid and slot_button.get_parent() == bag_grid


func handle_click_away(screen_pos: Vector2):
	if selected_item == null:
		return

	if selected_slot_button and selected_slot_button.get_global_rect().has_point(screen_pos):
		return

	if tooltip_panel and tooltip_panel.get_global_rect().has_point(screen_pos):
		return

	clear_selected_item()


func refresh_inventory():
	refresh_status()
	refresh_character_panel()

	var inventory = get_inventory()

	if inventory == null:
		return

	refresh_bag(inventory)
	refresh_equipment(inventory)


func refresh_bag(inventory):
	if bag_grid == null:
		return

	var slots = bag_grid.get_children()

	for i in range(slots.size()):
		var slot = slots[i]

		if not slot is Button:
			continue

		slot.set_meta("bag_index", i)
		slot.modulate = Color(1, 1, 1)

		if i < inventory.items.size() and inventory.items[i] != null:
			var item = inventory.items[i]
			slot.text = ""
			slot.set_meta("item_data", item)

			if item.has("icon_path"):
				var tex = load(item["icon_path"])
				slot.icon = tex if tex else null
			else:
				slot.icon = null
		else:
			slot.text = ""
			slot.icon = null

			if slot.has_meta("item_data"):
				slot.remove_meta("item_data")


func refresh_equipment(inventory):
	if equipment_panel == null:
		return

	for slot_name in inventory.equipped.keys():
		var slot_button = equipment_panel.get_node_or_null(slot_name)

		if slot_button == null:
			continue

		var equipped_item = inventory.equipped[slot_name]

		slot_button.modulate = Color(1, 1, 1)

		if equipped_item != null:
			slot_button.text = ""
			slot_button.set_meta("item_data", equipped_item)

			if equipped_item.has("icon_path"):
				var tex = load(equipped_item["icon_path"])
				slot_button.icon = tex if tex else null
			else:
				slot_button.icon = null
		else:
			slot_button.text = slot_name.capitalize()
			slot_button.icon = null

			if slot_button.has_meta("item_data"):
				slot_button.remove_meta("item_data")


func _on_equipment_slot_pressed(slot_button):
	if dragging_item != null:
		return

	if not slot_button.has_meta("item_data"):
		clear_selected_item()
		return

	selected_item = slot_button.get_meta("item_data")
	selected_slot_button = slot_button
	selected_item_source = "equipment"

	show_tooltip(selected_item, slot_button)


func show_tooltip(item_data, slot_button):
	if tooltip_panel == null:
		return

	tooltip_panel.visible = true

	if item_name_label:
		item_name_label.text = item_data["item_name"]

	if rarity_label:
		rarity_label.text = item_data["rarity"]

	if type_label:
		type_label.text = item_data["item_type"]

	if stats_label:
		var attack_text = "Attack: " + str(item_data.get("attack_bonus", 0))
		var defense_text = "Defense: " + str(item_data.get("defense_bonus", 0))

		var req_text = ""

		if item_data.has("requirements"):
			var req = item_data["requirements"]
			req_text += "\n\nRequires:"
			req_text += "\nLevel: " + str(req.get("level", 1))

			if req.get("strength", 0) > 0:
				req_text += "\nStrength: " + str(req["strength"])

			if req.get("dexterity", 0) > 0:
				req_text += "\nDexterity: " + str(req["dexterity"])

			if req.get("vitality", 0) > 0:
				req_text += "\nVitality: " + str(req["vitality"])

			if req.get("devotion", 0) > 0:
				req_text += "\nDevotion: " + str(req["devotion"])

		stats_label.text = attack_text + "\n" + defense_text + req_text

	var inventory = get_inventory()

	if equip_button and inventory:
		equip_button.text = "Unequip" if selected_item_source == "equipment" else "Equip"

	position_tooltip_bottom_right_to_slot_center(slot_button)


func position_tooltip_bottom_right_to_slot_center(slot_button):
	if tooltip_panel == null or slot_button == null:
		return

	await get_tree().process_frame

	var slot_rect = slot_button.get_global_rect()
	var tooltip_rect = tooltip_panel.get_global_rect()
	var screen_size = get_viewport().get_visible_rect().size

	var slot_center = slot_rect.position + slot_rect.size * 0.5

	var tooltip_pos = slot_center - tooltip_rect.size

	if tooltip_pos.x < 0:
		tooltip_pos.x = slot_rect.position.x + slot_rect.size.x + 10
		tooltip_pos.y = slot_center.y - tooltip_rect.size.y * 0.5

	if tooltip_pos.y < 0:
		tooltip_pos.y = 0

	if tooltip_pos.x + tooltip_rect.size.x > screen_size.x:
		tooltip_pos.x = screen_size.x - tooltip_rect.size.x

	if tooltip_pos.y + tooltip_rect.size.y > screen_size.y:
		tooltip_pos.y = screen_size.y - tooltip_rect.size.y

	tooltip_panel.global_position = tooltip_pos


func _on_equip_pressed():
	if resolve_player() == null or selected_item == null:
		return

	var inventory = get_inventory()

	if inventory == null:
		return

	if selected_item_source == "equipment":
		inventory.unequip_item(selected_item)
	else:
		inventory.equip_item(selected_item)

	clear_selected_item()
	refresh_inventory()
