extends Area2D 

signal hit_by_player

var sprite : AnimatedSprite2D

var active = true

var number_in_group





enum STATE{
	vulnerable,
	aggressive
}

var current_state = STATE.aggressive

@export var pattern = [STATE.vulnerable, STATE.aggressive]
@export var pattern_timers = [1.0, 5.0]

var current_timer
var current_state_index

func _ready():
	sprite = $Sprite2D
	sprite.play()
	current_state_index = 0
	current_timer = pattern_timers[current_state_index]
	current_state = pattern[current_state_index]
	connect("body_entered", on_body_entered)
	connect("body_exited", on_body_exited)
	
func _process(delta):
	current_timer -= delta
	if current_timer <= 0:
		current_state_index += 1
		if current_state_index >= pattern.size():
			current_state_index = 0
		change_state_visually()
		current_timer = pattern_timers[current_state_index]
		current_state = pattern[current_state_index]

func change_state_visually():
	if current_state == STATE.vulnerable:
		sprite.animation = "aggressive"
	elif current_state == STATE.aggressive:
		sprite.animation = "vulnerable"
	sprite.play()

func on_body_entered(body):
	if !active:
		return
	if body.is_in_group("Player"):
		if current_state == STATE.vulnerable:
			body.GRAVITY = 3000
			body.refill_dashes()
			hit_by_player.emit(number_in_group, body)
		elif current_state == STATE.aggressive:
			body.take_damage()

func on_body_exited(body):
	if body.is_in_group("Player"):
		pass


func respawn():
	print("hi")
	get_child(3).current_animation = "Respawn2"
	get_child(3).play()
	active = true
	visible = true
	
