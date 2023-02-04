extends Camera2D

@onready var target = owner.get_node("Player")
var lerpspeed = 0.05

func _process(delta):
	position = lerp(position, target.position, lerpspeed)
