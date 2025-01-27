extends Weapon

class_name AutoWeapon

@onready var internal_timer = $InternalTimer
@onready var external_timer = $ExternalTimer

@export var cooldown: float = 0.0

func _on_internal_timer_timeout():
	pass 

func _on_external_timer_timeout():
	pass 

func get_barrel_end_position():
	return Vector2(0, -texture.get_height()/2)
	
