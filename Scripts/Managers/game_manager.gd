extends Node2D

class_name GameManager

@onready var tile_map : TileMap = $TileMap # The tilemap used to manage the game grid
@onready var camera : Camera2D = $Camera2D # The game's main camera
@onready var wave_spawner = $WaveSpawner
@onready var um: UiManager = $"../CanvasLayer/UI"

# Preloaded prefabs for various objects
const BUILDING_PREFAB = preload("res://Scenes/Buildings/building.tscn")
const MANUAL_PREFAB = preload("res://Scenes/Buildings/Weapons/manual_weapon.tscn")
const AUTO_HITSCAN_PREFAB = preload("res://Scenes/Buildings/Weapons/hit_scan_auto_weapon.tscn")
const AUTO_CONTINOUS_PREFAB = preload("res://Scenes/Buildings/Weapons/continous_auto_weapon.tscn")


# Variables for game state
var power_systems = [] # Tracks connected power systems
var placement_state : bool = false # Whether a hex is being placed

signal currency_changed()
signal ore_changed()
signal wave_changed()

func _ready():
	setup()

func setup():
	spawn_building(Vector2.ZERO, Data.hex_ids.HEART)
	Data.currency = 10000
	emit_signal("currency_changed")
	Data.ore = 100
	emit_signal("ore_changed")
	Data.wave_number = 0
	emit_signal("wave_changed")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			handle_mouse_left_release()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			handle_mouse_right_click()

# Triggered when a building is destroyed, updates the grid and power systems
func _on_building_destroyed(tile_pos: Vector2):
	tile_map.set_cell(Data.TILE_MAP_LAYER, tile_pos, Data.TILE_MAP_ATLAS_ID, Vector2(0, 0))
	if tile_pos == Vector2.ZERO:
		defeat()
	power_systems = tile_map.find_connections()

func defeat():
	um.update_visiblity(true, um.ui_atlas[um.ui_id.LOSE])
	get_tree().paused = true

func handle_mouse_left_release():
	if placement_state:
		place_hex()
	stop_placement()

func handle_mouse_right_click():
	um.cleanup_popup()
	
	var global_clicked = get_local_mouse_position()
	var pos_clicked = tile_map.local_to_map(tile_map.to_local(global_clicked))
	var tile_data = tile_map.get_cell_tile_data(Data.TILE_MAP_LAYER, pos_clicked)
	
	if tile_data and tile_data.get_custom_data("Occupied"):
		um.create_popup(pos_clicked)

# Places a hex on the grid if the mouse position is valid
func place_hex():
	var global_clicked = get_local_mouse_position()
	var pos_clicked = tile_map.local_to_map(tile_map.to_local(global_clicked))
	var tile_data = tile_map.get_cell_tile_data(Data.TILE_MAP_LAYER, pos_clicked)
	var hex_id = um.hex_icon.hex_id
	if can_place_hex(tile_data):
		add_currency(-Data.cost[Data.hex_name[hex_id]][0])
		spawn_building(pos_clicked, hex_id)

# Checks if a hex can be placed on the given tile and currency is available
func can_place_hex(tile_data: TileData):
	return tile_data and not tile_data.get_custom_data("Occupied") and Data.cost[Data.hex_name[um.hex_icon.hex_id]][0] <= Data.currency

# Initializes placement state and creates a temporary hex icon
func start_placement(hex_id: int):
	um.create_hex_icon(hex_id)
	placement_state = true

# Cleans up placement state after a placement attempt
func stop_placement():
	um.cleanup_hex_icon()
	placement_state = false

# Spawns a building at the specified position and updates power systems
func spawn_building(tile_map_pos: Vector2, hex_id: int):
	
	# Set the tile in the tilemap
	tile_map.set_cell(Data.TILE_MAP_LAYER, tile_map_pos, Data.TILE_MAP_ATLAS_ID, Vector2(hex_id, 0))
	
	# Instantiate and configure the building
	var building_instant = BUILDING_PREFAB.instantiate()
	building_instant.position = tile_map.map_to_local(tile_map_pos)
	building_instant.tile_pos = tile_map_pos
	building_instant.connect("destroyed", _on_building_destroyed)
	
	building_instant.tag = Data.hex_name[hex_id]
	match hex_id:
		Data.hex_ids.MANUAL, Data.hex_ids.MINIGUN, Data.hex_ids.SNIPER, Data.hex_ids.LASER:
			add_weapon(hex_id, building_instant)
	building_instant.setup()
	
	# Add the building to the tilemap and update power systems
	tile_map.add_child(building_instant)
	power_systems = tile_map.find_connections()
	

func add_weapon(hex_id: int, building_instant: Building):
	var weapon_instant : Weapon
	
	match hex_id:
		Data.hex_ids.MANUAL:
			weapon_instant = MANUAL_PREFAB.instantiate()
		Data.hex_ids.MINIGUN, Data.hex_ids.SNIPER:
			weapon_instant = AUTO_HITSCAN_PREFAB.instantiate()
		Data.hex_ids.LASER:
			weapon_instant = AUTO_CONTINOUS_PREFAB.instantiate()
	
	if weapon_instant:
		weapon_instant.building_owner = building_instant
		building_instant.add_child(weapon_instant)
		building_instant.is_weapon = true
		building_instant.weapon = weapon_instant

# Adds currency to the player and updates the UI
func add_currency(value: int):
	Data.currency += value
	emit_signal("currency_changed")

func add_resource(value: float):
	Data.ore += value
	emit_signal("ore_changed")

# Adds charge to a power system connected to the given building
func add_system_charge(building: Building, amount: float):
	
	var system = find_building_system(building)
	if system.is_empty():
		return false
	
	var total_system_capacity = 0
	
	for battery in system:
		total_system_capacity += battery.max_charge - battery.charge
	
	if total_system_capacity <= 0:
		return false
	
	var remaining_amount = amount
	for battery in system:
		if remaining_amount <= 0:
			break
		var battery_capacity = battery.max_charge - battery.charge
		var battery_share = (battery_capacity / total_system_capacity) * amount
		var transfer = minf(battery_share, battery.max_charge - battery.charge)
		battery.add_charge(transfer)
		remaining_amount -= transfer
	
	return true

# Consumes charge from a power system connected to the given building
func consume_system_charge(building: Building, amount: float):
	var system = find_building_system(building)
	if system.is_empty():
		return false 
	
	var total_system_charge = 0
	
	
	for battery in system:
		total_system_charge += battery.charge
	
	
	if amount > total_system_charge:
		return false
	
	var remaining_amount = amount
	for battery in system:
		if remaining_amount <= 0:
			break
		# Calculate battery's share based on percentage of total system charge
		var battery_share = (battery.charge / total_system_charge) * amount
		var transfer = minf(battery_share, battery.charge)
		
		battery.add_charge(-transfer)
		remaining_amount -= transfer
	return true

# Finds the power system associated with a given building
func find_building_system(building:Building):
	for system in power_systems:
		if system.has(building):
			return system
	return []

func _on_start_button_pressed():
	um.update_visiblity(false, um.ui_atlas[um.ui_id.START])
	wave_spawner.start_wave(Data.wave_number)

func _on_wave_spawner_wave_done():
	increment_wave()

func increment_wave():
	Data.wave_number += 1
	emit_signal("wave_changed")
	if Data.wave_number > Data.wave_data.size():
		um.update_visiblity(true, um.ui_atlas[um.ui_id.WIN])
	else:
		um.update_visiblity(true, um.ui_atlas[um.ui_id.START])

func consume_resource(building: Building, amount: float):
	var tile_pos = building.tile_pos
	var tile_data = tile_map.get_cell_tile_data(Data.TILE_MAP_LAYER, tile_pos)
	if tile_data:
		var resource_amount = tile_data.get_custom_data("Ore")
		if resource_amount > 0:
			tile_data.set_custom_data("Ore", maxf(resource_amount - amount, 0))
			return true
	return false
