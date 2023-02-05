extends Control

@export var start_button: Button

func _ready():
	start_button.button_down.connect(start_game)

func start_game():
	get_tree().change_scene_to_file("res://MainScenes/MainLevel.tscn")
