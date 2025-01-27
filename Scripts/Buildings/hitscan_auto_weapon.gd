extends AutoWeapon

const TRACER_PREFAB = preload("res://Scenes/Buildings/Weapons/Effects/tracer.tscn")

@export var ammo_amount: int = 0
@export var attack_speed: float = 0 

var ammo_remaining = 0

func _ready():
	set_up_timers()

func set_up_timers():
	set_cooldown(cooldown)
	set_attack_speed(attack_speed)
	external_timer.start()

func _on_external_timer_timeout():
	ammo_remaining = ammo_amount
	_on_internal_timer_timeout()

func _on_internal_timer_timeout():
	if ammo_remaining > 0:
		if enemy_exists():
			var enemy = Methods.find_closest("enemy", global_position)[0]
			if in_range(enemy) and paid_cost(charge_cost):
				rotation = (enemy.global_position-global_position).angle() + SPRITE_ROTATION_OFFSET
				create_tracer(to_local(enemy.global_position))
				enemy.damage(damage_val)
		ammo_remaining -= 1
		internal_timer.start()
	else:
		external_timer.start()

func set_cooldown(c):
	cooldown = c
	external_timer.wait_time = c

func set_attack_speed(a):
	attack_speed = a
	internal_timer.wait_time = a

func create_tracer(end_pos: Vector2):
	var origin = get_barrel_end_position()
	var tracer = TRACER_PREFAB.instantiate()
	tracer.points = [origin, end_pos]
	add_child(tracer)
	
