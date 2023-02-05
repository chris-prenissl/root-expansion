extends Control

@export var button: Button
@export var button_text: String
@export var scene: PackedScene

func _ready():
	button.text = button_text
	button.button_down.connect(change_scene)

func change_scene():
	get_tree().change_scene_to_packed(scene)
