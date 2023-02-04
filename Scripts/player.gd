extends CharacterBody2D

var GRAVITY = 3000

var floor_detector

var max_dash_distance = 200
var min_click_distance_from_player = 100
var last_click_mouse_position
var last_global_click_mouse_position

var dir
var acceleration = 30
var acc_exponential = 5

var deceleration = 30
var dec_exponential = 5

var speed = 0
var max_speed = 3000

var decelerating = false


var start_amount_of_dashes = 1
var amount_of_dashes = start_amount_of_dashes

var travelled_distance = 0
var dashing = false

func _ready():
	floor_detector = $FloorDetector
	floor_detector.connect("body_entered", on_floor_detector_entered)

func _unhandled_input(event):
	if Input.is_action_just_pressed("dash"):
		if amount_of_dashes <= 0:
			return
		amount_of_dashes -= 1
		last_click_mouse_position = get_local_mouse_position()
		last_global_click_mouse_position = get_global_mouse_position()
		if!(position.distance_to(last_global_click_mouse_position) > min_click_distance_from_player):
			return
		travelled_distance = 0
		dashing = true
		GRAVITY = 0
		speed = 0
		var mouse_direction = last_click_mouse_position.normalized()
		dir = mouse_direction
		velocity = Vector2(speed * mouse_direction.x, speed * mouse_direction.y)

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	var last_position = position
	move_and_slide()
	for body in floor_detector.get_overlapping_bodies():
			if body.is_in_group("Floor"):
				refill_dashes()
	if decelerating:
		speed -= deceleration
		deceleration += dec_exponential
		velocity = Vector2(speed * dir.x, speed * dir.y)
		if speed <= 0:
			velocity = Vector2.ZERO
			speed = 0
			decelerating = false
		return
	
	
	if !dashing:
		return
	
	
	
		
		
	
	speed += acceleration
	acceleration += acc_exponential
	if speed >= max_speed:
		speed = max_speed
	velocity = Vector2(speed * dir.x, speed * dir.y)
		
	travelled_distance += (last_position.distance_to(position))
	if(travelled_distance >= max_dash_distance):
		decelerating = true
		dashing = false
		GRAVITY = 3000
		velocity = Vector2.ZERO
		for body in floor_detector.get_overlapping_bodies():
			if body.is_in_group("Floor"):
				refill_dashes()

func on_floor_detector_entered(body):
	if body.is_in_group("Floor"):
		refill_dashes()

func refill_dashes():
	if amount_of_dashes < start_amount_of_dashes:
		amount_of_dashes = start_amount_of_dashes
