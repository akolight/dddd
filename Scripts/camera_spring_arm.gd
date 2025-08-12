extends Node3D

@export_category("Mouse")
@export var mouse_sensitivity: float = 0.005
@export_category("Camera")
@export_group("Camera Rotate")
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle: float = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_vertical_angle: float = PI/4
@export_group("Camera Zoom")
@export var min_spring_length: float = 2.0
@export var max_spring_length: float = 10.0

@onready var spring_arm := $SpringArm3D


#func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
#region Rotate Camera
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * mouse_sensitivity
		# clamp the rotation
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		rotation.x -= event.relative.y * mouse_sensitivity
		# clamp the rotation
		rotation.x = clamp(rotation.x, min_vertical_angle, max_vertical_angle)
#endregion
		
#region Zoom Camera
# needs a cap
	if event.is_action_pressed("wheel_up"):
		spring_arm.spring_length = clamp(spring_arm.spring_length - 1.0, min_spring_length, max_spring_length)
	if event.is_action_pressed("wheel_down"):
		spring_arm.spring_length = clamp(spring_arm.spring_length + 1.0, min_spring_length, max_spring_length)
#endregion
		
#region Toggle Mouse/Camera
	if Input.is_action_pressed("toggle_mouse_capture"):
		print("tab")
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#endregion
