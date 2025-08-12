extends Control
class_name InventorySlot

signal OnItemDropped(from_slot_id, to_slot_id)


@export var equipped_highlight : Panel
@export var icon_slot : TextureRect
@export var count_label : Label

var inventory_slot_id : int = -1
var slot_filled : bool = false
var item_count : int = 0
var item_id : int

var slot_data : ItemData

func _process(delta: float) -> void:
	if item_count > 1:
		count_label.visible = true
	else:
		count_label.visible = false

# look into this for mouse camera/UI control
#func _gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if (event.button_index == MOUSE_BUTTON_LEFT and event.double_click):
			#OnItemEquipped.emit(inventory_slot_id)

func fill_slot(data: ItemData, id: int, equipped: bool):
	slot_data = data
	equipped_highlight.visible = equipped
	if (slot_data != null):
		slot_filled = true
		icon_slot.texture = slot_data.icon
		item_id = id
		item_count = slot_data.item_count
		refresh_label()
	else:
		slot_filled = false
		icon_slot.texture = null
		item_count = 0
		item_id = 0
		refresh_label()

func refresh_label():
	count_label.text = str(item_count)

func _get_drag_data(at_position: Vector2) -> Variant:
	if (slot_filled):
		var preview : TextureRect = TextureRect.new()
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.size = icon_slot.size
		preview.pivot_offset = icon_slot.size / 2.0
		preview.rotation = -2.0
		preview.texture = icon_slot.texture
		set_drag_preview(preview)
		
		return {"Type": "Item", "ID": inventory_slot_id}
	else:
		return false

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data["Type"] == "Item"

func _drop_data(at_position: Vector2, data: Variant) -> void:
	OnItemDropped.emit(data["ID"], inventory_slot_id)
	
