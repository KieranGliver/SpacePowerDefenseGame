extends Sprite2D

const SPRITE_ROTATION_OFFSET = deg_to_rad(90.0)

@export var attack_duration: float = 0 # Time between shots in seconds
@export var cooldown:float = 0
@export var damage_val: int = 5
@export var charge_cost = 10.0
@export var beam_width = 2
@export var beam_colour = Color(0.169, 0.431, 0.824)

var active : bool = false
var beam : Line2D = Line2D.new()

var external_timer: Timer = Timer.new()
var internal_timer: Timer = Timer.new()

func _ready():
	set_up_timers()
	set_up_beam()

func set_up_beam():
	beam.width = beam_width
	beam.default_color = beam_colour
	beam.visible = false
	add_child(beam)

func set_up_timers():
	external_timer.one_shot = true
	internal_timer.one_shot = true
	add_child(external_timer)
	add_child(internal_timer)
	external_timer.timeout.connect(_cooldown_timeout)
	internal_timer.timeout.connect(_attack_duration_timeout)
	set_cooldown(cooldown)
	set_attack_duration(attack_duration)
	external_timer.start()

func _process(delta):
	var process_charge_cost = charge_cost * delta
	var process_damage = damage_val * delta
	if active:
		if get_tree().get_nodes_in_group("enemy").size() > 0 and get_tree().get_first_node_in_group("game_manager").consume_system_charge(get_parent(), process_charge_cost):
			beam.visible = true
			var enemy = Methods.find_closest("enemy", global_position)[0]
			rotation = (enemy.global_position-global_position).angle() + SPRITE_ROTATION_OFFSET
			beam.points = [get_barrel_end_position(), to_local(enemy.global_position)]
			enemy.damage(process_damage)
		else:
			beam.visible = false

func _cooldown_timeout():
	beam.visible = true
	active = true
	internal_timer.start()

func _attack_duration_timeout():
	beam.visible = false
	active = false
	external_timer.start()

func set_cooldown(c):
	cooldown = c
	external_timer.wait_time = c

func set_attack_duration(a):
	attack_duration = a
	internal_timer.wait_time = a

func get_barrel_end_position():
	return Vector2(0, -texture.get_height()/2)
	
