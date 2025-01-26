extends Sprite2D

class_name Weapon

@export var ammo_amount: int = 0

@export var attack_speed: float = 0 # Time between shots in seconds
@export var cooldown:float = 0

@export var projectile : Resource
@export var charge_cost = 10.0
var ammo_remaining = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var external_timer: Timer = Timer.new() # Internal cooldown timer
var internal_timer: Timer = Timer.new() # Longer cooldown timer for reloading

func _ready():
	set_up_timers()

func set_up_timers():
	external_timer.one_shot = true
	internal_timer.one_shot = true
	add_child(external_timer)
	add_child(internal_timer)
	external_timer.timeout.connect(_cooldown_timeout)
	internal_timer.timeout.connect(_attackspeed_timeout)
	set_cooldown(cooldown)
	set_attack_speed(attack_speed)
	external_timer.start()

func _cooldown_timeout():
	ammo_remaining = ammo_amount
	_attackspeed_timeout()


func _attackspeed_timeout():
	if ammo_remaining > 0:
		if get_tree().get_nodes_in_group("enemy").size() > 0 and get_tree().get_first_node_in_group("game_manager").consume_charge(get_parent().tile_pos, charge_cost):
			var projectile_instant = projectile.instantiate()
			var enemy_pos = Methods.find_closest("enemy", global_position)[0]
			projectile_instant.global_position = global_position
			rotation = (enemy_pos-global_position).angle() + deg_to_rad(90.0)
			get_tree().get_first_node_in_group("game_manager").add_child(projectile_instant)
			projectile_instant.set_target(enemy_pos)
			
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
