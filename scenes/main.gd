extends Control

var game_manager: GameManager
var planets_data: PlanetsData
var planet_buttons: Array = []
var current_planet_index: int = 0

func _ready():
	game_manager = GameManager.new()
	add_child(game_manager)
	planets_data = PlanetsData.new()
	add_child(planets_data)
	
	setup_ui()
	update_display()

func setup_ui():
	# Title
	var title = Label.new()
	title.text = "D3ST: Stellar Industries"
	title.add_theme_font_size_override("font_size", 40)
	title.position = Vector2(400, 20)
	add_child(title)
	
	# Resources display
	var resource_label = Label.new()
	resource_label.name = "resource_label"
	resource_label.text = "Zdroje: 0"
	resource_label.add_theme_font_size_override("font_size", 24)
	resource_label.position = Vector2(50, 80)
	add_child(resource_label)
	
	# Prestige display
	var prestige_label = Label.new()
	prestige_label.name = "prestige_label"
	prestige_label.text = "Prestiž: 0"
	prestige_label.add_theme_font_size_override("font_size", 24)
	prestige_label.position = Vector2(550, 80)
	add_child(prestige_label)
	
	# Planet display
	var planet_display = Label.new()
	planet_display.name = "planet_display"
	planet_display.text = "Planeta: Země"
	planet_display.add_theme_font_size_override("font_size", 20)
	planet_display.position = Vector2(50, 130)
	add_child(planet_display)
	
	# Klikací tlačítko
	var click_button = Button.new()
	click_button.name = "click_button"
	click_button.text = "●"
	click_button.custom_minimum_size = Vector2(200, 200)
	click_button.add_theme_font_size_override("font_size", 100)
	click_button.position = Vector2(350, 200)
	click_button.pressed.connect(_on_click_button_pressed)
	add_child(click_button)
	
	# Upgrade buttons
	var upgrade_y = 450
	var upgrades = [
		{"name": "Dvojitý klik", "key": "double_click", "x": 50},
		{"name": "Auto-klik", "key": "auto_clicker", "x": 350},
		{"name": "Síla planety", "key": "planet_power", "x": 650}
	]
	
	for upgrade in upgrades:
		var button = Button.new()
		button.name = upgrade["key"] + "_btn"
		button.text = upgrade["name"] + "\n(10)"
		button.custom_minimum_size = Vector2(250, 80)
		button.position = Vector2(upgrade["x"], upgrade_y)
		button.pressed.connect(_on_upgrade_pressed.bindv([upgrade["key"]]))
		add_child(button)
		planet_buttons.append(button)
	
	# Prestige button
	var prestige_button = Button.new()
	prestige_button.name = "prestige_btn"
	prestige_button.text = "PRESTIŽ (reset)"
	prestige_button.custom_minimum_size = Vector2(250, 60)
	prestige_button.position = Vector2(350, 560)
	prestige_button.pressed.connect(_on_prestige_pressed)
	add_child(prestige_button)
	
	# Achievements
	var achievement_label = Label.new()
	achievement_label.name = "achievement_label"
	achievement_label.text = "Achievements: 0/4"
	achievement_label.add_theme_font_size_override("font_size", 16)
	achievement_label.position = Vector2(50, 650)
	add_child(achievement_label)

func update_display():
	var resource_label = get_node_or_null("resource_label")
	if resource_label:
		resource_label.text = "Zdroje: " + str(game_manager.resources)
	
	var prestige_label = get_node_or_null("prestige_label")
	if prestige_label:
		prestige_label.text = "Prestiž: " + str(game_manager.prestige_points)
	
	var planet_display = get_node_or_null("planet_display")
	if planet_display:
		var planet = planets_data.get_planet(current_planet_index)
		planet_display.text = "Planeta: " + planet["name"]
	
	var achievement_count = 0
	for achieved in game_manager.achievements.values():
		if achieved:
			achievement_count += 1
	var achievement_label = get_node_or_null("achievement_label")
	if achievement_label:
		achievement_label.text = "Achievements: " + str(achievement_count) + "/4"
	
	# Update upgrade buttons
	var double_btn = get_node_or_null("double_click_btn")
	if double_btn:
		double_btn.text = "Dvojitý klik Lv." + str(game_manager.double_click_level) + "\n(Cena: 10)"
	
	var auto_btn = get_node_or_null("auto_clicker_btn")
	if auto_btn:
		auto_btn.text = "Auto-klik Lv." + str(game_manager.auto_clicker_level) + "\n(Cena: 50)"
	
	var power_btn = get_node_or_null("planet_power_btn")
	if power_btn:
		power_btn.text = "Síla planety Lv." + str(game_manager.planet_power_level) + "\n(Cena: 100)"

func _on_click_button_pressed():
	game_manager.click_planet()
	current_planet_index = (current_planet_index + 1) % planets_data.get_all_planets().size()
	update_display()

func _on_upgrade_pressed(upgrade_key: String):
	if game_manager.buy_upgrade(upgrade_key):
		update_display()

func _on_prestige_pressed():
	if game_manager.prestige():
		update_display()

func _process(_delta):
	update_display()
