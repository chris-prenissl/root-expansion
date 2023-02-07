extends CharacterBody2D

@export var sprite: AnimatedSprite2D
#@export var animation_diagonally_up_threshhold = 

var GRAVITY = 2000

var floor_detector
var last_checkpoint = Vector2.ZERO
var start_pos

var max_dash_distance = 42
var min_click_distance_from_player = 100
var max_click_distance_from_player = 500
@onready var last_click_mouse_position = Vector2.ZERO
@onready var last_global_click_mouse_position = Vector2.ZERO

var dir
var start_acceleration = 500
var acceleration = start_acceleration
var acc_exponential = 5

var start_deceleration = 300
var deceleration = start_deceleration
var dec_exponential = 1

var speed = 0
var max_speed = 3000

var decelerating = false

var last_position: Vector2

var grounded = false

var amount_of_energy = 0
var energy_text


var start_amount_of_dashes = 2
var amount_of_dashes = start_amount_of_dashes

var travelled_distance = 0
var dashing = false

var level

var dashing_active = true

signal landed_on_tree_platform

func _ready():
	level = owner
	level.next_level_energy_requirement = level.level_energy_requirements[1]
	energy_text = level.get_node("CanvasLayer/UI/Label")
	show_energy_text()
	start_pos = position
	floor_detector = $FloorDetector
	floor_detector.connect("body_entered", on_floor_detector_entered)
	floor_detector.connect("body_exited", on_floor_detector_exited)

func _unhandled_input(event):
	if !dashing_active:
		return
	if Input.is_action_just_pressed("dash"):
		if amount_of_dashes <= 0:
			return
		if dashing:
			return
		if decelerating:
			return
		start_dashing()

func _physics_process(delta):
	apply_gravity(delta)
	if decelerating:
		decelerate()
	if dashing:
		dash()
	move_and_slide()
	if dashing:
		add_to_travelled_distance()
		pass

func on_floor_detector_entered(body):
	if body.is_in_group("Floor"):
		
		refill_dashes()
		grounded = true
		if body.is_in_group("Checkpoint"):
			last_checkpoint = body.get_child(0).global_position
			
		if body.is_in_group("Treeplatform"):
			emit_signal("landed_on_tree_platform")
func on_floor_detector_exited(body):
	if body.is_in_group("Floor"):
		grounded = false

func refill_dashes():
	if amount_of_dashes < start_amount_of_dashes:
		amount_of_dashes = start_amount_of_dashes

func start_dashing():
	last_click_mouse_position = get_local_mouse_position()
	last_global_click_mouse_position = get_global_mouse_position()
	
	if!(last_click_mouse_position.distance_to(Vector2.ZERO) > min_click_distance_from_player):
		return
	
	if last_click_mouse_position.y > 30:
		if is_on_floor():
			return
		
	amount_of_dashes -= 1
	travelled_distance = 0
	acceleration = start_acceleration
	deceleration = start_deceleration
	dashing = true
	GRAVITY = 0
	speed = 0
	var mouse_direction = last_click_mouse_position.normalized()
	dir = mouse_direction
	velocity = Vector2(speed * mouse_direction.x, speed * mouse_direction.y)
	animate_sprite()
	
func apply_gravity(delta):
	velocity.y += delta * GRAVITY

func decelerate():
	speed -= deceleration
	deceleration += dec_exponential
	velocity = Vector2(speed * dir.x, speed * dir.y)
	if speed <= 0:
		velocity = Vector2.ZERO
		speed = 0
		decelerating = false

func dash():
	speed += acceleration
	acceleration += acc_exponential
	if speed >= max_speed:
		speed = max_speed
	velocity = Vector2(speed * dir.x, speed * dir.y)
	last_position = position

func add_to_travelled_distance():
	travelled_distance = (last_position.distance_to(position))
	if(travelled_distance >= max_dash_distance || is_on_wall()):
		stop_dashing()

func stop_dashing():
	if grounded:
		refill_dashes()
	decelerating = true
	dashing = false
	
	GRAVITY = 2000
	velocity = Vector2.ZERO


func game_over():
	velocity = Vector2.ZERO
	amount_of_energy -= 1
	if amount_of_energy < 0:
		amount_of_energy = 0 
	
	else:
		owner.make_group_lootable_again()
	show_energy_text()
	respawn()

func respawn():
	if last_checkpoint != Vector2.ZERO:
		global_position = last_checkpoint
	else:
		position = start_pos
	
func add_energy():
	amount_of_energy += 1
	show_energy_text()

func animate_sprite():
	if sprite.is_playing():
		return
		
	var angle_to_mouse = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))
	print(angle_to_mouse)
	if angle_to_mouse <= 10 and angle_to_mouse > -46:
		print("right")
	elif angle_to_mouse <= -46 and angle_to_mouse > -20:
		print("up right")
	elif angle_to_mouse <= -20 and angle_to_mouse > -111:
		print("up")
	elif angle_to_mouse <= -111 and angle_to_mouse > -160:
		print("up left")
	elif angle_to_mouse <= -160 and angle_to_mouse > -180:
		print("left")
		
	elif angle_to_mouse <= 180 and angle_to_mouse > 111:
		print("down left")
	elif angle_to_mouse <= 110 and angle_to_mouse > 70:
		print("down")
	elif angle_to_mouse <= 69 and angle_to_mouse >= 9:
		print("down right")

	sprite.play()

func show_energy_text():
	energy_text.text = str(amount_of_energy) + "/" + str(level.next_level_energy_requirement)
