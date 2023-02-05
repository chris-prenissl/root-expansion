extends CharacterBody2D

var player 
var speed = 600
var area 

func _ready():
	area = get_node("Area2D")
	area.connect("body_entered", on_body_entered)

func _physics_process(delta):
	player = get_parent().get_node("Player")
	var dir = (player.position - position).normalized()
	velocity = dir * speed
	move_and_slide()

func on_body_entered(body):
	if body.is_in_group("Player"):
		body.add_energy()
		queue_free()
