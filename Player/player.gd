extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var sensitivity : float = 0.5
@export var min_spring_length: float = 2.0
@export var max_spring_length: float = 10.0

@export var interact_area : Area3D
@export var inventory : Control

@onready var pivot = $CamOrigin
@onready var spring_arm = $CamOrigin/SpringArm3D


var cam_lock : bool = false
var cam_ignore : bool = false

func _ready() -> void:
	inventory.connect("ItemPickedUp",_on_item_picked_up)

func _on_item_picked_up():
	cam_ignore = true

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#if Input.is_action_pressed("mb2"):
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#rotate_y(deg_to_rad(-event.relative.x * sensitivity))
			#pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
			#pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		#if Input.is_action_pressed("mb1"):
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#rotate_y(deg_to_rad(-event.relative.x * sensitivity))
			#pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
			#pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and !cam_ignore:
		if Input.is_action_pressed("mb2"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			rotate_y(deg_to_rad(-event.relative.x * sensitivity))
			pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		if Input.is_action_pressed("mb1"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			rotate_y(deg_to_rad(-event.relative.x * sensitivity))
			pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	
	if event.is_action_pressed("wheel_up"):
		spring_arm.spring_length = clamp(spring_arm.spring_length - 1.0, min_spring_length, max_spring_length)
	if event.is_action_pressed("wheel_down"):
		spring_arm.spring_length = clamp(spring_arm.spring_length + 1.0, min_spring_length, max_spring_length)

func _physics_process(delta: float) -> void:
	
	# Bind cursor to camera
	if Input.is_action_just_released("mb1") or Input.is_action_just_released("mb2"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
