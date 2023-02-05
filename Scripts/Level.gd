extends Node2D

var current_energy = 0
var total_energy = 0
var level = 0 

var player
var camera

var tree_level_label
var tree_view = false

var level_energy_requirements = {1: 1, 2: 3, 3: 5, 4: 7, 5: 10}
var next_level_energy_requirement
var next_level_energy_requirement_index = 0

var looted_enemy_groups = []

func _ready():
	tree_level_label = $CanvasLayer/UI/Treelevel
	tree_level_label.visible = false
	camera = get_node("Camera2D")
	player = get_node("Player")
	player.connect("landed_on_tree_platform", on_land_on_tree)
	next_level_energy_requirement = level_energy_requirements[1]

func add_energy():
	if player.amount_of_energy >= next_level_energy_requirement:
		level_up()
		if next_level_energy_requirement - player.amount_of_energy > 0:
			player.amount_of_energy = next_level_energy_requirement - player.amount_of_energy
		else:
			player.amount_of_energy = 0

func level_up():
	total_energy += current_energy
	level += 1

func make_group_lootable_again():
	looted_enemy_groups[0].dropped_loot = false
	looted_enemy_groups.remove_at(0)	

func _unhandled_input(event):
	if Input.is_action_just_pressed("dash") and tree_view:
		tree_view = false
		camera.zoom = Vector2(1, 1)
		player.dashing_active = true

func on_land_on_tree():
	tree_view = true
	player.dashing_active = false
	camera.zoom = Vector2(0.05, 0.05)
	add_energy()
	tree_level_label.text = "tree level: " + str(level)
	tree_level_label.visible = true
	
	
