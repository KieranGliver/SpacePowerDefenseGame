extends Sprite2D

const TRACER_PREFAB = preload("res://Scenes/Buildings/Weapons/tracer.tscn")
const SPRITE_ROTATION_OFFSET = deg_to_rad(90.0)

@export var ammo_amount: int = 0
@export var attack_speed: float = 0 # Time between shots in seconds
@export var cooldown:float = 0
@export var damage_val: int = 10
@export var charge_cost = 10.0

var ammo_remaining = 0

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
		if get_tree().get_nodes_in_group("enemy").size() > 0 and get_tree().get_first_node_in_group("game_manager").consume_system_charge(get_parent(), charge_cost):
			var enemy = Methods.find_closest("enemy", global_position)[0]
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

func get_barrel_end_position():
	return Vector2(0, -texture.get_height()/2)
	

func create_tracer(end_pos: Vector2):
	var origin = get_barrel_end_position()
	var tracer = TRACER_PREFAB.instantiate()
	tracer.points = [origin, end_pos]
	
	add_child(tracer)
	
