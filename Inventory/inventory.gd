extends Node2D

const ITEM_SLOT = preload("res://Scenes/Inventory/item_slot.tscn")

var row_size : int = 4
var col_size : int = 9
var item_grid : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(row_size):
		item_grid.append([])
		
		for y in range(col_size):
			item_grid[x].append([])
	
			var instance = ITEM_SLOT.instantiate()
			instance.global_position = Vector2(x*50,y*50)
			instance.slot_num = Vector2i(x,y)
			self.add_child(instance)
			item_grid[x][y] = instance


func prep_item(item_id: String):
	var item : Dictionary = {}
	
	item["id"] = item_id
	item["name"] = MasterItemList[item_id][0]
	item["type"] = MasterItemList[item_id][1]
	item["icon_path"] = MasterItemList[item_id][2]
	item["stack_amount"] = MasterItemList[item_id][3]
