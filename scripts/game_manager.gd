extends Node

class_name GameManager

# Resources
var resources: int = 0
var prestige_points: int = 0

# Upgrades
var double_click_level: int = 0
var auto_clicker_level: int = 0
var planet_power_level: int = 0

# Achievements
var achievements: Dictionary = {
	"first_click": false,
	"100_resources": false,
	"all_upgrades": false,
	"prestige": false
}

# Upgrade costs
var upgrade_costs: Dictionary = {
	"double_click": 10,
	"auto_clicker": 50,
	"planet_power": 100
}

# Auto-clicker
var auto_clicker_active: bool = false
var auto_clicker_timer: float = 0.0

func _ready():
	load_game()
	if auto_clicker_level > 0:
		auto_clicker_active = true

func _process(delta):
	if auto_clicker_active and auto_clicker_level > 0:
		auto_clicker_timer += delta
		var interval = 2.0 / auto_clicker_level  # Čím vyšší level, tím rychlejší
		if auto_clicker_timer >= interval:
			add_resources(1 + int(planet_power_level * 0.5))
			auto_clicker_timer = 0.0

func click_planet():
	var click_value = 1 + (double_click_level * 0.5) + (planet_power_level * 0.2)
	add_resources(int(click_value))
	check_achievement("first_click")

func add_resources(amount: int):
	resources += amount
	check_achievement("100_resources")
	save_game()

func buy_upgrade(upgrade_name: String) -> bool:
	if upgrade_name not in upgrade_costs:
		return false
	
	var cost = upgrade_costs[upgrade_name]
	if resources < cost:
		return false
	
	resources -= cost
	
	match upgrade_name:
		"double_click":
			double_click_level += 1
		"auto_clicker":
			auto_clicker_level += 1
			auto_clicker_active = true
		"planet_power":
			planet_power_level += 1
	
	check_achievement("all_upgrades")
	save_game()
	return true

func prestige():
	if resources >= 100:
		prestige_points += int(sqrt(resources) / 10)
		resources = 0
		double_click_level = 0
		auto_clicker_level = 0
		planet_power_level = 0
		check_achievement("prestige")
		save_game()
		return true
	return false

func check_achievement(achievement_name: String):
	if achievement_name in achievements and not achievements[achievement_name]:
		match achievement_name:
			"first_click":
				if resources >= 1:
					achievements["first_click"] = true
			"100_resources":
				if resources >= 100:
					achievements["100_resources"] = true
			"all_upgrades":
				if double_click_level > 0 and auto_clicker_level > 0 and planet_power_level > 0:
					achievements["all_upgrades"] = true
			"prestige":
				achievements["prestige"] = true
		save_game()

func save_game():
	var save_data = {
		"resources": resources,
		"prestige_points": prestige_points,
		"double_click_level": double_click_level,
		"auto_clicker_level": auto_clicker_level,
		"planet_power_level": planet_power_level,
		"achievements": achievements
	}
	
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_var(save_data)

func load_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	if file and file.get_length() > 0:
		var save_data = file.get_var()
		resources = save_data.get("resources", 0)
		prestige_points = save_data.get("prestige_points", 0)
		double_click_level = save_data.get("double_click_level", 0)
		auto_clicker_level = save_data.get("auto_clicker_level", 0)
		planet_power_level = save_data.get("planet_power_level", 0)
		achievements = save_data.get("achievements", {})
