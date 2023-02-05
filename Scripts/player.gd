extends CharacterBody2D

@export var sprite: AnimatedSprite2D

var GRAVITY = 2000

var floor_detector
var last_checkpoint = Vector2.ZERO
var start_pos

var max_dash_distance = 45
var min_click_distance_from_player = 100
var max_click_distance_from_player = 500
var last_click_mouse_position
var last_global_click_mouse_position

var dir
var start_acceleration = 500
var acceleration = start_acceleration
var acc_exponential = 5

var start_deceleration = 500
var deceleration = start_deceleration
var dec_exponential = 5

var speed = 0
var max_speed = 3000

var decelerating = false

var last_position

var grounded = false

var amount_of_energy = 0


var start_amount_of_dashes = 1
var amount_of_dashes = start_amount_of_dashes

var travelled_distance = 0
var dashing = false

func _ready():
	start_pos = position
	floor_detector = $FloorDetector
	floor_detector.connect("body_entered", on_floor_detector_entered)
	floor_detector.connect("body_exited", on_floor_detector_exited)

func _unhandled_input(event):
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
			print(body.get_child(0).position)
			last_checkpoint = body.get_child(0).global_position
func on_floor_detector_exited(body):
	if body.is_in_group("Floor"):
		grounded = false

func refill_dashes():
	if amount_of_dashes < start_amount_of_dashes:
		amount_of_dashes = start_amount_of_dashes

func start_dashing():
	last_click_mouse_position = get_local_mouse_position()
	last_global_click_mouse_position = get_global_mouse_position()
	
	var view_dir = position.direction_to(last_global_click_mouse_position)
	animate_sprite(view_dir.x > 0, view_dir.y < 0, true, false, false)
	
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
	respawn()

func respawn():
	if last_checkpoint != Vector2.ZERO:
		global_position = last_checkpoint
	else:
		position = start_pos
	
func add_energy():
	amount_of_energy += 1
	print(amount_of_energy)

func animate_sprite(facing_right: bool, moving_up: bool, dashing: bool, idle: bool, falling: bool):
	sprite.flip_h = facing_right
	
	if dashing:
		const animation = "dash_"
		if moving_up:
			sprite.animation = animation + "up"
		elif falling:
			sprite.animation = animation + "down"
		else:
			sprite.animation = animation + "horizontal"
	elif idle:
		sprite.animation = "idle"
	elif falling:
		sprite.animation = "falling"
	else:
		sprite.animation = "landing"
	
	sprite.play()
