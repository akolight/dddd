extends Resource
class_name Item

@export var item_id : int
@export var item_name : String
@export_enum("Vendor","Material","Consumable","Equipment") var type : String
@export var icon_path : String
@export var stack_amount : int
