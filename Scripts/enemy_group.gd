extends Node2D

var enemies

var last_number_hit = -1

func _ready():
	enemies = get_children()
	for e in enemies:
		e.number_in_group = enemies.find(e)
		e.connect("hit_by_player", on_enemy_hit)
		show_enemy_to_hit_visually()

func on_enemy_hit(number_in_group, player):
	if number_in_group == last_number_hit + 1:
		enemies[number_in_group].visible = false
		enemies[number_in_group].active = false
		last_number_hit += 1
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

func highlight_enemy(enemy):
	enemy.get_child(1).scale = Vector2(0.7, 0.7)
		
func stop_combo(player):
	last_number_hit = -1
	show_enemy_to_hit_visually()
	player.amount_of_dashes = 0
	player.GRAVITY = 3000
	for e in enemies:
		if e.active == false:
			e.respawn()
