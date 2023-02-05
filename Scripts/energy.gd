extends CharacterBody2D

var player 
var speed = 200
var area 

func _ready():
	area = get_node("Area2D")
	player = get_parent().get_node("Player")
	area.connect("body_entered", on_body_entered)

func _physics_process(delta):
	pass  

func on_body_entered(body):
	if body.is_in_group("Player"):
		print("hello 123")
		body.add_energy()
		queue_free()
