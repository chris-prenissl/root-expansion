extends CharacterBody2D

var GRAVITY = 4000

var start_health = 1 
var current_health = start_health

var floor_detector

var max_dash_distance = 45
var min_click_distance_from_player = 100
var last_click_mouse_position
var last_global_click_mouse_position

var dir
var start_acceleration = 300
var acceleration = start_acceleration
var acc_exponential = 200

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

func on_floor_detector_exited(body):
	if body.is_in_group("Floor"):
		grounded = false

func refill_dashes():
	if amount_of_dashes < start_amount_of_dashes:
		amount_of_dashes = start_amount_of_dashes

func start_dashing():
	last_click_mouse_position = get_local_mouse_position()
	last_global_click_mouse_position = get_global_mouse_position()
	if!(position.distance_to(last_global_click_mouse_position) > min_click_distance_from_player):
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
	if(travelled_distance >= max_dash_distance):
		stop_dashing()

func stop_dashing():
	if grounded:
		refill_dashes()
	decelerating = true
	dashing = false
	
	GRAVITY = 3000
	velocity = Vector2.ZERO

func take_damage():
	current_health -= 1 
	if current_health <= 0:
		game_over()

func game_over():
	print("game over!")
	
func add_energy():
	amount_of_energy += 1
