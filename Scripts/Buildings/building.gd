extends Node2D

class_name Building



@export var tag : String = "Invalid"
@export var level: int = 0
@export var hp : int = 10
@export var max_charge : float = 0
@export var charge_rate : float = 0
@export var mine_rate: float = 0
@export var tile_pos : Vector2 = Vector2.ZERO

@onready var gm = get_tree().get_first_node_in_group("game_manager")
var charge : float = 0

var weapon: Node = null
var is_weapon: bool = false
var enhancer_count : int = 0
var is_enhanced : bool = false

signal destroyed(tile_pos: Vector2)

@onready var enery_bar = $EnergyBar

func _ready():
	add_charge(0)
	
	if tag == Data.hex_name[Data.hex_ids.ENHANCER]:
		apply_enhancement()

func _process(delta):
	var paid = false
	if (charge_rate > 0):
		gm.add_system_charge(self, charge_rate*delta)
	elif (charge_rate < 0):
		paid = gm.consume_system_charge(self, -charge_rate*delta)
	if (mine_rate > 0 and paid):
		if gm.consume_resource(self, mine_rate*delta):
			gm.add_resource(mine_rate*delta)

func _on_hurt_box_hurt(damage, _direction, _knockback):
	damage(damage)

func damage(damage):
	hp -= damage
	if hp <= 0:
		destroy_building()

func destroy_building():
	queue_free()

func _exit_tree():
	emit_signal("destroyed", tile_pos)
	if tag == Data.hex_name[Data.hex_ids.ENHANCER]:
		remove_enhancement()
	for e in get_tree().get_nodes_in_group("enemy"):
		e.call_deferred("find_target")

func add_charge(c: float):
	charge += c
	enery_bar.max_value = max_charge
	enery_bar.value = charge
	if max_charge == 0:
		enery_bar.visible = false

func setup(level: int = 0):
	enhancer_count = 0
	is_enhanced = false
	
	var building_name = tag
	self.level = level
	if weapon != null:
		is_weapon = true
	var building_stats = Data.building_stats[building_name][level]
	
	if building_stats:
		hp = building_stats["health"]
		max_charge = building_stats["max_charge"]
		charge_rate = building_stats["charge_rate"]
		mine_rate = building_stats["mine_rate"]
	
	match building_name:
		Data.hex_name[Data.hex_ids.MANUAL], Data.hex_name[Data.hex_ids.MINIGUN], Data.hex_name[Data.hex_ids.SNIPER], Data.hex_name[Data.hex_ids.LASER]:
			weapon.setup(building_name, level)
	
	var adjacent_tiles = Methods.get_adjacent_hexes(tile_pos)
	for tile in adjacent_tiles:
		var adjacent_building = Methods.find_building(tile)
		if adjacent_building and adjacent_building.tag == Data.hex_name[Data.hex_ids.ENHANCER]:
			add_enhancer()

func apply_enhancement():
	var adjacent_tiles = Methods.get_adjacent_hexes(tile_pos)
	for tile in adjacent_tiles:
		var adjacent_building = Methods.find_building(tile)
		if adjacent_building:
			adjacent_building.add_enhancer()

func remove_enhancement():
	var adjacent_tiles = Methods.get_adjacent_hexes(tile_pos)
	for tile in adjacent_tiles:
		var adjacent_building = Methods.find_building(tile)
		if adjacent_building:
			adjacent_building.remove_enhancer()

func add_enhancer():
	enhancer_count += 1
	if not is_enhanced and enhancer_count >= 1:
		enhance_building()

func remove_enhancer():
	enhancer_count -= 1
	if is_enhanced and enhancer_count <= 0:
		revert_enhance_building()

func enhance_building():
	is_enhanced = true
	hp *= Data.ENHANCEMENT_MULTI
	max_charge *= Data.ENHANCEMENT_MULTI
	charge_rate *= Data.ENHANCEMENT_MULTI
	mine_rate *= Data.ENHANCEMENT_MULTI
	
	if weapon:
		weapon.enhance_weapon()

func revert_enhance_building():
	is_enhanced = false
	hp /= Data.ENHANCEMENT_MULTI
	max_charge /= Data.ENHANCEMENT_MULTI
	charge_rate /= Data.ENHANCEMENT_MULTI
	mine_rate /= Data.ENHANCEMENT_MULTI
	
	if weapon:
		weapon.revert_enhance_weapon()
