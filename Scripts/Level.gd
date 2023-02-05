extends Node2D

var current_energy = 0
var total_energy = 0
var level = 0 

var level_energy_requirements = {1: 1, 2: 3, 3: 5, 4: 7, 5: 10}
var next_level_energy_requirement
var next_level_energy_requirement_index = 0

func _ready():
	pass
	#next_level_energy_requirement = level_energy_requirements[next_level_energy_requirement_index]

func add_energy():
	current_energy += 1
	if current_energy >= next_level_energy_requirement:
		level_up()
		if next_level_energy_requirement - current_energy > 0:
			current_energy = next_level_energy_requirement - current_energy
		else:
			current_energy = 0

func level_up():
	total_energy += current_energy
	level += 1
	
	
