extends Node2D

var current_energy = 0
var total_energy = 0
var level = 0 

var level_energy_requirements = {1: 1, 2: 3, 3: 5, 4: 7, 5: 10}
var next_level_energy_requirement
var next_level_energy_requirement_index = 0

var looted_enemy_groups = []

func _ready():
	next_level_energy_requirement = level_energy_requirements[1]

func add_energy():
	if current_energy >= next_level_energy_requirement:
		level_up()
		if next_level_energy_requirement - current_energy > 0:
			current_energy = next_level_energy_requirement - current_energy
		else:
			current_energy = 0

func level_up():
	total_energy += current_energy
	level += 1

func make_group_lootable_again():
	looted_enemy_groups[0].dropped_loot = false
	looted_enemy_groups.remove_at(0)	
	
