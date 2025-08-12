extends Control
class_name InventoryHandler

signal ItemPickedUp

@export var player_body : CharacterBody3D
@export_flags_3d_physics var collision_mask : int

@export var item_slots_count : int = 20

@export var inventory_grid : GridContainer
@export var inventory_slot_prefab : PackedScene = preload("res://Inventory/inventory_slot.tscn")

var inventory_slots : Array[InventorySlot] = []

var equipped_slot : int = -1

func _ready() -> void:
	mouse_filter = 2 # set mouse filter to ignore
	
	for item_slot in item_slots_count:
		var slot = inventory_slot_prefab.instantiate() as InventorySlot
		inventory_grid.add_child(slot)
		slot.inventory_slot_id = item_slot
		slot.OnItemDropped.connect(item_dropped_on_slot.bind())
		inventory_slots.append(slot)

func pickup_item(item: ItemData,id: int):
	# cycles through all inventory slots to find an empty one, or one that matches the item id
	var found_slot : bool = false
	for slot in inventory_slots:
		print("ID: ", id)
		if (slot.slot_filled) and (slot.item_id == id):
			slot.item_count += item.item_count
			slot.count_label.text = str(slot.item_count)
			found_slot = true
			break
		
		elif (!slot.slot_filled):
			slot.fill_slot(item,id, false)
			slot.item_id = id
			slot.item_count = item.item_count
			ItemPickedUp.emit()
			found_slot = true
			break
		
	if (!found_slot):
		var new_item = item.item_model_prefab.instantiate() as Node3D
		
		player_body.get_parent().add_child(new_item)
		new_item.global_position = player_body.global_position + player_body.global_transform.basis.x * 2

func item_dropped_on_slot(from_slot_id : int, to_slot_id : int):
	if (equipped_slot != -1):
		if (equipped_slot == from_slot_id):
			equipped_slot = to_slot_id
		elif (equipped_slot == to_slot_id):
			equipped_slot = from_slot_id
	
	var to_slot_item = inventory_slots[to_slot_id].slot_data
	var from_slot_item = inventory_slots[from_slot_id].slot_data
	var to_slot_count = inventory_slots[to_slot_id].item_count
	var from_slot_count = inventory_slots[from_slot_id].item_count
	var to_item_id = inventory_slots[to_slot_id].item_id
	var from_item_id = inventory_slots[from_slot_id].item_id
	
	inventory_slots[to_slot_id].fill_slot(from_slot_item,from_item_id, equipped_slot == to_slot_id)
	inventory_slots[from_slot_id].fill_slot(to_slot_item,to_item_id, equipped_slot == from_slot_id)
	
	inventory_slots[to_slot_id].item_count = from_slot_count
	inventory_slots[from_slot_id].item_count = to_slot_count
	
	inventory_slots[to_slot_id].refresh_label()
	inventory_slots[from_slot_id].refresh_label()

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data["Type"] == "Item"

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if (equipped_slot == data["ID"]):
		equipped_slot = -1
		
	var new_item = inventory_slots[data["ID"]].slot_data.item_model_prefab.instantiate() as Node3D
	inventory_slots[data["ID"]].fill_slot(null,0, false)

func get_world_mouse_position() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var cam = get_viewport().get_camera_3d()
	var ray_start = cam.project_ray_origin(mouse_pos)
	var ray_end = ray_start + cam.project_ray_normal(mouse_pos) * cam.global_position.distance_to(player_body.global_position) * 2
	var world3d : World3D = player_body.get_world_3d()
	var space_state = world3d.direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(ray_start,ray_end,collision_mask)
	
	var results = space_state.intersect_ray(query)
	if results:
		return results["position"] as Vector3 + Vector3(0.0,0.5,0.0)
	else:
		return ray_start.lerp(ray_end, 0.5) + Vector3(0.0,0.5,0.0)
