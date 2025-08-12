extends Node3D

signal OnItemPickedUp(item)

const DUNGEON_ONE_SCENE : PackedScene = preload("res://Scenes/dungeon_one.tscn")
const DUNGEON_TWO_SCENE : PackedScene = preload("res://Scenes/dungeon_two.tscn")
const DUNGEON_THREE_SCENE : PackedScene = preload("res://Scenes/dungeon_three.tscn")

@export var player : CharacterBody3D


@onready var dungeon_array : Array = [DUNGEON_ONE_SCENE,DUNGEON_TWO_SCENE,DUNGEON_THREE_SCENE]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PosTrack.going_back:
		player.global_position = PosTrack.return_array[PosTrack.portal_index]
		player.global_rotation_degrees = Vector3(0,180,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portal_1_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		PosTrack.portal_index = 0
		PosTrack.going_back = true
		get_tree().change_scene_to_packed(dungeon_array[PosTrack.portal_index])

func _on_portal_2_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		PosTrack.portal_index = 1
		PosTrack.home_pos = body.global_position
		PosTrack.going_back = true
		get_tree().change_scene_to_packed(dungeon_array[PosTrack.portal_index])


func _on_portal_3_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		PosTrack.portal_index = 2
		PosTrack.home_pos = body.global_position
		PosTrack.going_back = true
		get_tree().change_scene_to_packed(dungeon_array[PosTrack.portal_index])
