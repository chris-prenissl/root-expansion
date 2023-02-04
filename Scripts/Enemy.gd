extends Area2D 

signal hit_by_player

var sprite

var active = false

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

var state_sprites = [preload("res://Art/icon.svg"), preload("res://Art/PrototypeArt/128square.png")]


func _ready():
	sprite = $Sprite2D
	current_state_index = 0
	current_timer = pattern_timers[current_state_index]
	current_state = pattern[current_state_index]
	connect("body_entered", on_body_entered)

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
	sprite.texture = state_sprites[current_state_index]

func on_body_entered(body):
	if !active:
		return
	if body.is_in_group("Player"):
		body.GRAVITY = 3000
		body.refill_dashes()
		hit_by_player.emit(number_in_group, body)
