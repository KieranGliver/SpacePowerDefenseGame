extends AutoWeapon

@onready var beam = $Beam

@export var attack_duration: float = 0 # Time between shots in seconds

var active : bool = false

func _ready():
	set_up_timers()

func set_up_timers():
	set_cooldown(cooldown)
	set_attack_duration(attack_duration)
	external_timer.start()

func _process(delta):
	var process_charge_cost = charge_cost * delta
	var process_damage = damage_val * delta
	if active:
		if get_tree().get_nodes_in_group("enemy").size() > 0 and get_tree().get_first_node_in_group("game_manager").consume_system_charge(building_owner, process_charge_cost):
			beam.visible = true
			var enemy = Methods.find_closest("enemy", global_position)[0]
			rotation = (enemy.global_position-global_position).angle() + SPRITE_ROTATION_OFFSET
			beam.points = [get_barrel_end_position(), to_local(enemy.global_position)]
			enemy.damage(process_damage)
		else:
			beam.visible = false

func _on_external_timer_timeout():
	beam.visible = true
	active = true
	internal_timer.start()

func _on_internal_timer_timeout():
	beam.visible = false
	active = false
	external_timer.start()

func set_cooldown(c):
	cooldown = c
	external_timer.wait_time = c

func set_attack_duration(a):
	attack_duration = a
	internal_timer.wait_time = a
