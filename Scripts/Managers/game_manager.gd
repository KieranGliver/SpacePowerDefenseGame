extends Node2D

@onready var tile_map : TileMap = $TileMap
@onready var hex_menu : PanelContainer  = $"../CanvasLayer/UI/HexMenu"
@onready var camera : Camera2D = $Camera2D
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var currency_label = $"../CanvasLayer/UI/CurrenyLabel"

const tile_map_layer = 0
const tile_map_atlas_id = 0

const HEX_ICON_PREFAB = preload("res://Scenes/UI/hex_icon.tscn")
const BUILDING_PREFAB = preload("res://Scenes/Buildings/building.tscn")
const MANUAL_PREFAB = preload("res://Scenes/Buildings/Weapons/manual_weapon.tscn")
const MINIGUN_PREFAB = preload("res://Scenes/Buildings/Weapons/minigun.tscn")

var currency : int = 0
var systems = []

var hex_icon
var placement_state: bool = false

func _ready():
	add_currency(10000)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			if placement_state:
				var global_clicked = get_local_mouse_position()
				var pos_clicked = tile_map.local_to_map(tile_map.to_local(global_clicked))
				var tile_data = tile_map.get_cell_tile_data(tile_map_layer, pos_clicked)
				if  Data.cost[hex_icon.hex_id] <= currency and tile_data:
					if tile_data.get_custom_data("Occupied") == false:
						add_currency(-Data.cost[hex_icon.hex_id])
						spawn_building(pos_clicked, hex_icon.hex_id)
			if hex_icon != null:
				hex_icon.queue_free()
			placement_state = false

func _on_hex_menu_button_pressed(button):
	hex_icon = HEX_ICON_PREFAB.instantiate()
	hex_icon.hex_id = button
	hex_icon.frame = button
	canvas_layer.add_child(hex_icon)
	placement_state = true

func spawn_building(tile_map_pos: Vector2, hex_id: int):
	
	tile_map.set_cell(tile_map_layer, tile_map_pos, tile_map_atlas_id, Vector2(hex_id, 0))
	
	var building_instant = BUILDING_PREFAB.instantiate()
	building_instant.position = tile_map.map_to_local(tile_map_pos)
	building_instant.tile_pos = tile_map_pos
	building_instant.connect("destroyed", _on_building_destroyed)
	
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
			building_instant.add_child(manual_instant)
			building_instant.tag = "manual"
		Data.hex_ids.MINIGUN:
			var minigun_instant = MINIGUN_PREFAB.instantiate()
			building_instant.add_child(minigun_instant)
			building_instant.tag = "minigun"
		Data.hex_ids.SNIPER:
			building_instant.tag = "sniper"
		Data.hex_ids.LASER:
			building_instant.tag = "laser"
	
	tile_map.add_child(building_instant)
	systems = tile_map.find_connections()

func _on_building_destroyed(tile_pos: Vector2):
	tile_map.set_cell(tile_map_layer, tile_pos, tile_map_atlas_id, Vector2(0, 0))
	systems = tile_map.find_connections()

func add_currency(value: int):
	currency += value
	currency_label.set_text(str(currency))

func consume_charge(tile_pos, c):
	var buildings = get_tree().get_nodes_in_group("building")
	var charged = []
	var charge = 0
	for s in systems:
		if s.has(tile_pos):
			for building_pos in s:
				var b = buildings.filter(func(b): return b.tile_pos == building_pos)
				if !b.is_empty():
					charged.append(b[0])
					charge += b[0].charge
	if charge < c:
		return false
	for battery in charged:
		var drain = min(c, battery.charge)
		battery.add_charge(-drain)
		c -= drain
	return c == 0

func add_charge(tile_pos, c):
	var buildings = get_tree().get_nodes_in_group("building")
	var charged = []
	for s in systems:
		if s.has(tile_pos):
			for building_pos in s:
				var b = buildings.filter(func(b): return b.tile_pos == building_pos)
				if !b.is_empty():
					charged.append(b[0])
	for battery in charged:
		var drain = minf(c, battery.max_charge - battery.charge)
		battery.add_charge(drain)
		c -= drain
	return c == 0
