extends Control

@export var time_speed = 0.03
@export var foreground: TextureRect

@onready var bar_length = foreground.size.x 
@export var time_is_running = true

var day_value: float

func _ready():
	day_value = 1
	
func _process(delta):
	if !time_is_running:
		return
	day_value -= time_speed*delta
	
	if day_value <= 0:
		day_value = 0
	
	set_value()

func set_value():
	foreground.size = Vector2(day_value*bar_length, foreground.size.y)
	
func reset_day_value():
	day_value = 1.0
	
func get_day_time_value() -> float:
	return day_value
