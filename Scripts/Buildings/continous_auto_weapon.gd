extends AutoWeapon

class_name ContinousAutoWeapon

@onready var beam = $Beam

@export var attack_duration: float = 0

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
		if enemy_exists():
			var enemy = Methods.find_closest("enemy", global_position)[0]
			if in_range(enemy) and paid_cost(process_charge_cost):
				if internal_timer.is_stopped():
					internal_timer.start()
				beam.visible = true
				rotation = (enemy.global_position-global_position).angle() + SPRITE_ROTATION_OFFSET
				beam.points = [get_barrel_end_position(), to_local(enemy.global_position)]
				enemy.damage(process_damage)
			else:
				beam.visible = false
		else:
			beam.visible = false

func _on_external_timer_timeout():
	active = true

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
