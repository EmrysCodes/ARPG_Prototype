extends Node3D

var gold: int = 0
var items: Array = []

var equipped = {
	"helmet": null,
	"amulet": null,
	"weapon": null,
	"chest": null,
	"offhand": null,
	"gloves": null,
	"ring1": null,
	"belt": null,
	"ring2": null,
	"boots": null
}


func ensure_item_id(item_data):
	if item_data == null:
		return

	if not item_data.has("id"):
		item_data["id"] = str(Time.get_ticks_usec()) + "_" + str(randi())


func refresh_player_stats():
	var stats = get_parent().get_node_or_null("PlayerStats")

	if stats:
		stats.recalculate_stats()

	var hud = get_tree().current_scene.get_node_or_null("HUD")

	if hud:
		if hud.has_method("refresh_status"):
			hud.refresh_status()

		if hud.has_method("refresh_inventory"):
			hud.refresh_inventory()


func add_gold(amount: int):
	gold += amount
	print("Gold: ", gold)
	refresh_player_stats()


func add_item(item_data):
	ensure_item_id(item_data)

	if can_auto_equip(item_data):
		equip_item_to_open_slot(item_data)
		print("Auto equipped: ", item_data["item_name"])
	else:
		items.append(item_data)
		print("Picked up item: ", item_data["item_name"])
		print("Inventory now has: ", items.size(), " items")

	refresh_player_stats()


func can_auto_equip(item_data):
	if item_data == null:
		return false

	var item_type = item_data["item_type"].to_lower()

	if item_type == "ring":
		return equipped["ring1"] == null or equipped["ring2"] == null

	if equipped.has(item_type):
		return equipped[item_type] == null

	return false


func equip_item_to_open_slot(item_data):
	ensure_item_id(item_data)

	var item_type = item_data["item_type"].to_lower()

	if item_type == "ring":
		if equipped["ring1"] == null:
			equipped["ring1"] = item_data
		elif equipped["ring2"] == null:
			equipped["ring2"] = item_data
		return

	if equipped.has(item_type) and equipped[item_type] == null:
		equipped[item_type] = item_data


func swap_items(index_a: int, index_b: int):
	if index_a < 0 or index_a >= items.size():
		return

	if index_b < 0:
		return

	while index_b >= items.size():
		items.append(null)

	var temp = items[index_a]
	items[index_a] = items[index_b]
	items[index_b] = temp

	cleanup_empty_trailing_slots()
	refresh_player_stats()


func move_item_to_index(from_index: int, to_index: int):
	if from_index < 0 or from_index >= items.size():
		return

	if to_index < 0:
		return

	while to_index >= items.size():
		items.append(null)

	var item = items[from_index]
	items[from_index] = null
	items[to_index] = item

	cleanup_empty_trailing_slots()
	refresh_player_stats()


func cleanup_empty_trailing_slots():
	while items.size() > 0 and items[items.size() - 1] == null:
		items.pop_back()


func equip_item(item_data):
	if item_data == null:
		return

	ensure_item_id(item_data)

	var slot = item_data["item_type"].to_lower()

	if slot == "ring":
		equip_ring(item_data)
		return

	if equipped.has(slot):
		var previous_item = equipped[slot]

		if previous_item != null:
			ensure_item_id(previous_item)
			items.append(previous_item)

		equipped[slot] = item_data
		items.erase(item_data)
		cleanup_empty_trailing_slots()

		print("Equipped: ", item_data["item_name"])
		refresh_player_stats()
	else:
		print("No equipment slot for: ", slot)


func equip_item_to_slot(item_data, slot_name: String):
	if item_data == null:
		return

	ensure_item_id(item_data)

	var item_type = item_data["item_type"].to_lower()

	if slot_name == "ring1" or slot_name == "ring2":
		if item_type != "ring":
			print("Cannot equip ", item_type, " to ", slot_name)
			return

		var previous_item = equipped[slot_name]

		if previous_item != null:
			ensure_item_id(previous_item)
			items.append(previous_item)

		equipped[slot_name] = item_data
		items.erase(item_data)
		cleanup_empty_trailing_slots()

		print("Equipped ring to ", slot_name, ": ", item_data["item_name"])
		refresh_player_stats()
		return

	if item_type != slot_name:
		print("Cannot equip ", item_type, " to ", slot_name)
		return

	var previous_item = equipped[slot_name]

	if previous_item != null:
		ensure_item_id(previous_item)
		items.append(previous_item)

	equipped[slot_name] = item_data
	items.erase(item_data)
	cleanup_empty_trailing_slots()

	print("Equipped: ", item_data["item_name"])
	refresh_player_stats()


func equip_ring(item_data):
	if item_data == null:
		return

	ensure_item_id(item_data)

	var target_slot = ""

	if equipped["ring1"] == null:
		target_slot = "ring1"
	elif equipped["ring2"] == null:
		target_slot = "ring2"
	else:
		target_slot = "ring1"

	var previous_item = equipped[target_slot]

	if previous_item != null:
		ensure_item_id(previous_item)
		items.append(previous_item)

	equipped[target_slot] = item_data
	items.erase(item_data)
	cleanup_empty_trailing_slots()

	print("Equipped ring: ", item_data["item_name"])
	refresh_player_stats()


func unequip_item(item_data):
	if item_data == null:
		return

	ensure_item_id(item_data)

	for slot_name in equipped.keys():
		var equipped_item = equipped[slot_name]

		if equipped_item == null:
			continue

		ensure_item_id(equipped_item)

		if equipped_item["id"] == item_data["id"]:
			equipped[slot_name] = null
			items.append(equipped_item)
			print("Unequipped: ", equipped_item["item_name"])
			refresh_player_stats()
			return

	print("Item was not equipped: ", item_data["item_name"])


func is_equipped(item_data):
	if item_data == null:
		return false

	ensure_item_id(item_data)

	for slot_name in equipped.keys():
		var equipped_item = equipped[slot_name]

		if equipped_item == null:
			continue

		ensure_item_id(equipped_item)

		if equipped_item["id"] == item_data["id"]:
			return true

	return false


func remove_item(item_data):
	if item_data == null:
		return

	ensure_item_id(item_data)

	for i in range(items.size()):
		var item = items[i]

		if item == null:
			continue

		ensure_item_id(item)

		if item["id"] == item_data["id"]:
			items.remove_at(i)
			cleanup_empty_trailing_slots()
			refresh_player_stats()
			return


func print_inventory():
	print("Gold: ", gold)

	print("Items:")
	for item in items:
		if item != null:
			print("- ", item["item_name"], " | ", item["rarity"], " ", item["item_type"])
		else:
			print("- Empty")

	print("Equipped:")
	for slot in equipped.keys():
		if equipped[slot] != null:
			print(slot, ": ", equipped[slot]["item_name"])
		else:
			print(slot, ": Empty")
