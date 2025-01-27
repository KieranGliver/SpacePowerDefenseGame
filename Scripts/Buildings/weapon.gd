extends Sprite2D

class_name Weapon

const SPRITE_ROTATION_OFFSET = deg_to_rad(90.0)

@export var damage_val: float = 0.0
@export var charge_cost: float = 0.0

var building_owner : Building = null
