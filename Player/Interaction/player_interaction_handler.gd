extends Area3D

signal OnItemPickedUp(item)

@export var items : Array[ItemData] = []

var nearby_bodies : Array[InteractableItem]

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Interact")):
		pickup_nearest_item()

func pickup_nearest_item():
	var nearest_item : InteractableItem = null
	var nearest_item_distance : float = INF
	for item in nearby_bodies:
		if (item.global_position.distance_to(global_position) < nearest_item_distance):
			nearest_item_distance = item.global_position.distance_to(global_position)
			nearest_item = item
	
	if (nearest_item != null):
		nearest_item.queue_free()
		nearby_bodies.remove_at(nearby_bodies.find(nearest_item))
		var itemPrefab = nearest_item.scene_file_path
		for item in items.size():
			if (item != 0) and (items[item].item_model_prefab != null and items[item].item_model_prefab.resource_path == itemPrefab):
				print("Item id: " + str(item) + " Item Name: " + items[item].item_name)
				OnItemPickedUp.emit(items[item],item)
				return
		
		printerr("Item not found")

func on_body_entered_area(body: Node3D):
	if (body is InteractableItem):
		body.gain_focus()
		nearby_bodies.append(body)

func on_object_exited_area(body: Node3D):
	if (body is InteractableItem and nearby_bodies.has(body)):
		body.lose_focus()
		nearby_bodies.remove_at(nearby_bodies.find(body))
