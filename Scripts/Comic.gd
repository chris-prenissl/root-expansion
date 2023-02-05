extends Control

@export var screen1: Image
@export var screen2: Image
@export var screen3: Image
@export var screen4: Image
@export var texture: TextureRect
@export var skip_time: float

var time: float


func _process(delta):
	if skip_time <= 0:
		texture.texture = Texture2D(screen1)
		time = skip_time
		

