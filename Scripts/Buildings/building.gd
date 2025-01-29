extends Node2D

class_name Building

@export var tag : String = "Invalid"
@export var level: int = 0
@export var hp : int = 10
@export var max_charge : float = 0
@export var charge_rate : float = 0
@export var mine_rate: float = 0
@export var tile_pos : Vector2 = Vector2.ZERO

var charge : float = 0

var weapon: Node = null
var is_weapon: bool = false

signal destroyed(tile_pos: Vector2)

@onready var enery_bar = $EnergyBar

func _ready():
	add_charge(0)

func _process(delta):
	var gm = get_tree().get_first_node_in_group("game_manager")
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
	for e in get_tree().get_nodes_in_group("enemy"):
		e.call_deferred("find_target")

func add_charge(c: float):
	charge += c
	enery_bar.max_value = max_charge
	enery_bar.value = charge
	if max_charge == 0:
		enery_bar.visible = false

func setup(level: int = 0):
	var building_name = tag
	self.level = level
	var building_stats = Data.building_stats[building_name][level]
	
	if building_stats:
		hp = building_stats["health"]
		max_charge = building_stats["max_charge"]
		charge_rate = building_stats["charge_rate"]
		mine_rate = building_stats["mine_rate"]
	
	match building_name:
		Data.hex_name[Data.hex_ids.MANUAL], Data.hex_name[Data.hex_ids.MINIGUN], Data.hex_name[Data.hex_ids.SNIPER], Data.hex_name[Data.hex_ids.LASER]:
			weapon.setup(building_name, level)
