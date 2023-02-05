extends Node2D

var enemies : Array[Node]
var player

var last_number_hit = -1

var defeated = false


var dropped_loot = false

var start_combo_timer = 2
var combo_timer = start_combo_timer
var combo_timer_running = false

var start_respawn_timer = 5 
var respawn_timer = start_respawn_timer
var respawn_timer_running = false

var line2d 

@export var energy_scene_path = ""

func _ready():
	line2d = get_node("Line2D")
	player = owner.get_node("Player")
	enemies = get_node("Enemies").get_children()
	for e in enemies:
		e.number_in_group = enemies.find(e)
		e.connect("hit_by_player", on_enemy_hit)
		show_enemy_to_hit_visually()
	generate_line2D()

func on_enemy_hit(number_in_group, player):		
	if number_in_group == last_number_hit + 1:
		player.GRAVITY = 2000
		player.refill_dashes()
		combo_timer = start_combo_timer
		combo_timer_running = true
		enemies[number_in_group].visible = false
		enemies[number_in_group].active = false
		last_number_hit += 1
		if last_number_hit < line2d.get_point_count():
			line2d.remove_point(last_number_hit)
		if number_in_group == enemies.size() - 1:
			group_defeated()
		show_enemy_to_hit_visually()
	else:
		stop_combo(player)
		
	

func show_enemy_to_hit_visually():
	for e in enemies:
		if e.number_in_group == last_number_hit +1:
			highlight_enemy(e)
		else:
			dehighlight_enemy(e)

func dehighlight_enemy(enemy):
	enemy.get_child(1).scale = Vector2(0.5, 0.5)
	enemy.get_child(0).scale = Vector2(0.5, 0.5)
	enemy.get_child(2).energy = 0
	
func highlight_enemy(enemy):
	enemy.get_child(1).scale = Vector2(1, 1)
	enemy.get_child(0).scale = Vector2(1, 1)
	enemy.get_child(2).energy = 0.5
func stop_combo(player):
	if defeated:
		return
	generate_line2D()
	last_number_hit = -1
	show_enemy_to_hit_visually()
	player.GRAVITY = 3000
	for e in enemies:
		if e.active == false:
			e.respawn()

func group_defeated():
	if dropped_loot == false:
		dropped_loot = true
		var new_energy = load(energy_scene_path).instantiate()
		new_energy.set_player(player)
		owner.call_deferred("add_child", new_energy)
		new_energy.position = enemies[enemies.size() - 1].global_position
	for e in enemies:
		e.get_child(3).current_animation = "Respawn"
		e.get_child(3).play()
		e.visible = true
		
	defeated = true
	respawn_timer_running = true
	

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
	generate_line2D()
	defeated = false
	last_number_hit = -1
	show_enemy_to_hit_visually()
	for e in enemies:
		if e.active == false:
			e.respawn()

func generate_line2D():
	line2d.clear_points()
	for e in enemies:
		line2d.add_point(e.position)
