extends Node

@export var going_back : bool = false
@export var home_pos : Vector3
@export var portal_index : int # tracks which of the portals the player entered
@export var return_array : Array = [Vector3(-1.6,1,-10),Vector3(3.6,1,-10),Vector3(8.6,1,-10)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
