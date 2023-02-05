extends Area2D

func _ready():
	connect("body_entered", on_body_entered)

func on_body_entered(body):
	if body.is_in_group("Player"):
		body.game_over()
