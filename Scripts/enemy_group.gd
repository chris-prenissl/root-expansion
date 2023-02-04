extends Node2D

var enemies
var player

var last_number_hit = -1

var defeated = false

var start_combo_timer = 1 
var combo_timer = start_combo_timer
var combo_timer_running = false

var start_respawn_timer = 5 
var respawn_timer = start_respawn_timer
var respawn_timer_running = false

@export var energy_scene_path = ""

func _ready():
	player = owner.get_node("Player")
	enemies = get_children()
	for e in enemies:
		e.number_in_group = enemies.find(e)
		e.connect("hit_by_player", on_enemy_hit)
		show_enemy_to_hit_visually()

func on_enemy_hit(number_in_group, player):		
	if number_in_group == last_number_hit + 1:
		combo_timer_running = true
		enemies[number_in_group].visible = false
		enemies[number_in_group].active = false
		last_number_hit += 1
		show_enemy_to_hit_visually()
	else:
		stop_combo(player)
		
	if number_in_group == enemies.size() - 1:
		group_defeated()

func show_enemy_to_hit_visually():
	for e in enemies:
		if e.number_in_group == last_number_hit +1:
			highlight_enemy(e)
		else:
			dehighlight_enemy(e)

func dehighlight_enemy(enemy):
	enemy.get_child(1).scale = Vector2(0.5, 0.5)

func highlight_enemy(enemy):
	enemy.get_child(1).scale = Vector2(0.7, 0.7)
		
func stop_combo(player):
	if defeated:
		return
	last_number_hit = -1
	show_enemy_to_hit_visually()
	player.GRAVITY = 3000
	for e in enemies:
		if e.active == false:
			e.respawn()

func group_defeated():
	var new_energy = load(energy_scene_path).instance()
	add_child(new_energy)
	new_energy.position = enemies[enemies.size() - 1].position
	
	defeated = true
	respawn_timer_running = true
	print("group defeated")

func _process(delta):
	if combo_timer_running:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_timer = start_combo_timer
			combo_timer_running = false
			stop_combo(player)
	
	if respawn_timer_running:
		respawn_timer -= delta
		if respawn_timer <= 0:
			respawn_timer = start_respawn_timer
			respawn_timer_running = false
			respawn()

func respawn():
	defeated = false
	last_number_hit = -1
	show_enemy_to_hit_visually()
	for e in enemies:
		if e.active == false:
			e.respawn()

