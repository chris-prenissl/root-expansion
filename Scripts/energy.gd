extends Area2D

@export var max_speed: float
@export var starting_speed: float
var current_speed: float

var player: Node2D

func _ready():
	player = get_parent().get_node("Player")
	current_speed = starting_speed
	
func _process(delta):
	move_towards_player(delta)

func move_towards_player(delta: float):
	destroy_and_add_energy_when_player_hit()
	
	var direction = position.direction_to(player.position)
	position += direction*current_speed*delta 
	
	if current_speed > max_speed:
		current_speed = max_speed
	else:
		current_speed *= 2
	
	
func destroy_and_add_energy_when_player_hit():
	if has_overlapping_bodies():
		var collisions = get_overlapping_bodies()
		for body in collisions:
			if body.is_in_group("Player"):
				body.add_energy()
				queue_free()
