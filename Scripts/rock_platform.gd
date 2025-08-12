extends StaticBody3D

@export var light : OmniLight3D
@export var glowing : bool = false
@export_color_no_alpha var light_color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if glowing:
		light.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
