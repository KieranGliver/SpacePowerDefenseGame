extends Weapon

class_name AutoWeapon

enum target_modes {CLOSET, HEALTH, SHIELD}

@onready var internal_timer : Timer = $InternalTimer
@onready var external_timer : Timer = $ExternalTimer

@export var cooldown: float = 0.0
@export var range: float = 0.0

var mode: int = target_modes.CLOSET

var target: Node

func _on_internal_timer_timeout():
	pass 

func _on_external_timer_timeout():
	pass 

func get_barrel_end_position():
	return Vector2(0, -texture.get_height()/2)
	

func set_target():
	var enemies = get_tree().get_nodes_in_group("enemy").filter(in_range)
	
	if enemies.is_empty():
		target = null
		return
	
	enemies.sort_custom(func(a, b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	
	match mode:
		target_modes.CLOSET:
			target = enemies[0]
		target_modes.HEALTH:
			enemies.sort_custom(func(a, b): return a.hp > b.hp)
			target = enemies[0]
		target_modes.SHIELD:
			var shield_enemies = enemies.filter(func(e): e.max_shield > 0)
			if not shield_enemies.is_empty():
				target = shield_enemies[0]
			else:
				target = enemies[0]

func enemy_exists():
	return !get_tree().get_nodes_in_group("enemy").is_empty()

func in_range(enemy: Enemy):
	return enemy.global_position.distance_to(global_position) < range

func paid_cost(cost: float):
	return get_tree().get_first_node_in_group("game_manager").consume_system_charge(building_owner, cost)
