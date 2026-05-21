extends Node

class_name PlanetsData

var planets_info: Array = [
	{
		"name": "Země",
		"color": Color.BLUE,
		"description": "Náš domovský svět",
		"base_value": 1
	},
	{
		"name": "Mars",
		"color": Color.RED,
		"description": "Rudá planeta",
		"base_value": 1.2
	},
	{
		"name": "Jupiter",
		"color": Color.ORANGE,
		"description": "Největší planeta",
		"base_value": 1.5
	},
	{
		"name": "Saturn",
		"color": Color.YELLOW,
		"description": "Planeta s prstenci",
		"base_value": 2.0
	},
	{
		"name": "Neptune",
		"color": Color.CYAN,
		"description": "Modrá ledová planeta",
		"base_value": 2.5
	},
	{
		"name": "Pluto",
		"color": Color.WHITE,
		"description": "Malá ledová tělesa",
		"base_value": 3.0
	}
]

func get_planet(index: int) -> Dictionary:
	if index >= 0 and index < planets_info.size():
		return planets_info[index]
	return {}

func get_all_planets() -> Array:
	return planets_info
