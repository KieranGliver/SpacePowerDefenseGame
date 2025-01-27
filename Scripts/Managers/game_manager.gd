extends Node2D

@onready var tile_map : TileMap = $TileMap # The tilemap used to manage the game grid
@onready var hex_menu : PanelContainer  = $"../CanvasLayer/UI/HexMenu" # The UI menu for selecting hexes
@onready var camera : Camera2D = $Camera2D # The game's main camera
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer" # Layer for UI and overlays
@onready var currency_label = $"../CanvasLayer/UI/CurrenyLabel" # UI label displaying current currency

# Preloaded prefabs for various objects
const HEX_ICON_PREFAB = preload("res://Scenes/UI/hex_icon.tscn")
const BUILDING_PREFAB = preload("res://Scenes/Buildings/building.tscn")
const MANUAL_PREFAB = preload("res://Scenes/Buildings/Weapons/manual_weapon.tscn")
const AUTO_HITSCAN_PREFAB = preload("res://Scenes/Buildings/Weapons/hit_scan_auto_weapon.tscn")
const AUTO_CONTINOUS_PREFAB = preload("res://Scenes/Buildings/Weapons/continous_auto_weapon.tscn")

# Variables for game state
var currency : int = 0 # Player's available currency
var power_systems = [] # Tracks connected power systems
var hex_icon : Node # Temporary icon for hex placement
var placement_state : bool = false # Whether a hex is being placed

func _ready():
	add_currency(10000)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			handle_mouse_release()

# Triggered when a building is destroyed, updates the grid and power systems
func _on_building_destroyed(tile_pos: Vector2):
	tile_map.set_cell(Data.TILE_MAP_LAYER, tile_pos, Data.TILE_MAP_ATLAS_ID, Vector2(0, 0))
	power_systems = tile_map.find_connections()

# Handles pressing a button in the hex menu
func _on_hex_menu_button_pressed(button_id: int):
	start_placement(button_id)

func handle_mouse_release():
	if placement_state:
		place_hex()
	clean_up_placement_state()

# Places a hex on the grid if the mouse position is valid
func place_hex():
	var global_clicked = get_local_mouse_position()
	var pos_clicked = tile_map.local_to_map(tile_map.to_local(global_clicked))
	var tile_data = tile_map.get_cell_tile_data(Data.TILE_MAP_LAYER, pos_clicked)
	
	if can_place_hex(tile_data):
		add_currency(-Data.cost[hex_icon.hex_id])
		spawn_building(pos_clicked, hex_icon.hex_id)

# Checks if a hex can be placed on the given tile and currency is available
func can_place_hex(tile_data: TileData):
	return tile_data and not tile_data.get_custom_data("Occupied") and Data.cost[hex_icon.hex_id] <= currency

# Initializes placement state and creates a temporary hex icon
func start_placement(hex_id: int):
	hex_icon = HEX_ICON_PREFAB.instantiate()
	hex_icon.hex_id = hex_id
	hex_icon.frame = hex_id
	canvas_layer.add_child(hex_icon)
	placement_state = true

# Cleans up placement state after a placement attempt
func clean_up_placement_state():
	if hex_icon != null:
		hex_icon.queue_free()
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
	
	setup_building(hex_id, building_instant)
	
	# Add the building to the tilemap and update power systems
	tile_map.add_child(building_instant)
	power_systems = tile_map.find_connections()

# Configures a building's properties based on its hex ID
func setup_building(hex_id: int, building_instant: Building):
	match hex_id:
		Data.hex_ids.BLANK:
			building_instant.tag = "blank"
		Data.hex_ids.WIRE:
			building_instant.tag = "wire"
		Data.hex_ids.BATTERY:
			building_instant.max_charge = 50.0
			building_instant.tag = "battery"
		Data.hex_ids.GENERATOR:
			building_instant.charge_rate = 10.0
			building_instant.tag = "generator"
		Data.hex_ids.MANUAL:
			var manual_instant = MANUAL_PREFAB.instantiate()
			manual_instant.building_owner = building_instant
			manual_instant.damage_val = Data.weapon_stats["manual"]["damage"]
			manual_instant.charge_cost = Data.weapon_stats["manual"]["charge"]
			building_instant.add_child(manual_instant)
			building_instant.tag = "manual"
		Data.hex_ids.MINIGUN:
			var minigun_instant = AUTO_HITSCAN_PREFAB.instantiate()
			minigun_instant.get_child(0).building_owner = building_instant
			minigun_instant.get_child(0).damage_val = Data.weapon_stats["minigun"]["damage"]
			minigun_instant.get_child(0).charge_cost = Data.weapon_stats["minigun"]["charge"]
			minigun_instant.get_child(0).cooldown = Data.weapon_stats["minigun"]["cooldown"]
			minigun_instant.get_child(0).attack_speed = Data.weapon_stats["minigun"]["attack_speed"]
			minigun_instant.get_child(0).ammo_amount = Data.weapon_stats["minigun"]["ammo"]
			building_instant.add_child(minigun_instant)
			building_instant.tag = "minigun"
		Data.hex_ids.SNIPER:
			var sniper_instant = AUTO_HITSCAN_PREFAB.instantiate()
			sniper_instant.get_child(0).building_owner = building_instant
			sniper_instant.get_child(0).damage_val = Data.weapon_stats["sniper"]["damage"]
			sniper_instant.get_child(0).charge_cost = Data.weapon_stats["sniper"]["charge"]
			sniper_instant.get_child(0).cooldown = Data.weapon_stats["sniper"]["cooldown"]
			sniper_instant.get_child(0).attack_speed = Data.weapon_stats["sniper"]["attack_speed"]
			sniper_instant.get_child(0).ammo_amount = Data.weapon_stats["sniper"]["ammo"]
			building_instant.add_child(sniper_instant)
			building_instant.tag = "sniper"
		Data.hex_ids.LASER:
			var laser_instant = AUTO_CONTINOUS_PREFAB.instantiate()
			laser_instant.get_child(0).building_owner = building_instant
			laser_instant.get_child(0).damage_val = Data.weapon_stats["laser"]["damage"]
			laser_instant.get_child(0).charge_cost = Data.weapon_stats["laser"]["charge"]
			laser_instant.get_child(0).cooldown = Data.weapon_stats["laser"]["cooldown"]
			laser_instant.get_child(0).attack_duration = Data.weapon_stats["laser"]["attack_duration"]
			building_instant.add_child(laser_instant)
			building_instant.tag = "laser"

# Adds currency to the player and updates the UI
func add_currency(value: int):
	currency += value
	currency_label.set_text(str(currency))

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
	
	return remaining_amount == 0.0

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
	return remaining_amount == 0.0

# Finds the power system associated with a given building
func find_building_system(building:Building):
	for system in power_systems:
		if system.has(building):
			return system
	return []
