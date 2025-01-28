extends Enemy

const TRACER_PREFAB = preload("res://Scenes/Buildings/Weapons/Effects/tracer.tscn")

@onready var attack_timer = $AttackTimer

@export var damage_value = 1
@export var attack_range = 300

var attacking : bool = false

func _physics_process(delta):
	if not attacking:
		var direction = Vector2(0, 0)
		
		# if knockback exists apply knockback and reduce it otherwise move towards the player
		if knockback <= 0:
			
			direction = global_position.direction_to(target_pos)
			velocity = direction * SPEED
			
			if direction.x > 0:
				sprite.flip_h = true
			elif direction.x < 0:
				sprite.flip_h = false
			
		else:
			direction = knockback_dir
			velocity = direction * knockback
			knockback = knockback - knockback_resistance
		
		move_and_slide()
		
		if target_pos.distance_to(global_position) <= attack_range:
			attacking = true
		
	elif attack_timer.is_stopped():
		_on_attack_timer_timeout()


func _on_attack_timer_timeout():
	shoot()
	

func shoot():
	create_tracer(to_local(target_pos))
	if building_target:
		building_target.damage(damage_value)
	attack_timer.start()


func create_tracer(end_pos: Vector2):
	var tracer = TRACER_PREFAB.instantiate()
	tracer.points = [Vector2.ZERO, end_pos]
	add_child(tracer)

func find_target():
	super()
	attack_timer.stop()
	attacking = false
