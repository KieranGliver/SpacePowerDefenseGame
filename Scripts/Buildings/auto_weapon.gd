extends Sprite2D

class_name AutoWeapon

const SPRITE_ROTATION_OFFSET = deg_to_rad(90.0)
var building_owner : Building = null

@onready var internal_timer = $InternalTimer
@onready var external_timer = $ExternalTimer

@export var damage_val: float = 0.0
@export var charge_cost: float = 0.0
@export var cooldown: float = 0.0

func _on_internal_timer_timeout():
	pass 


func _on_external_timer_timeout():
	pass 

func get_barrel_end_position():
	return Vector2(0, -texture.get_height()/2)
	
