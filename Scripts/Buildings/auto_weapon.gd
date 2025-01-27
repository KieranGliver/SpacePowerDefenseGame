extends Weapon

class_name AutoWeapon

@onready var internal_timer = $InternalTimer
@onready var external_timer = $ExternalTimer

@export var cooldown: float = 0.0
@export var range: float = 0.0

func _on_internal_timer_timeout():
	pass 

func _on_external_timer_timeout():
	pass 

func get_barrel_end_position():
	return Vector2(0, -texture.get_height()/2)
	

func enemy_exists():
	return get_tree().get_nodes_in_group("enemy").size() > 0

func in_range(enemy: Enemy):
	return enemy.global_position.distance_to(global_position) < range

func paid_cost(cost: float):
	return get_tree().get_first_node_in_group("game_manager").consume_system_charge(building_owner, cost)
