extends CharacterBody2D

@export var SPEED : float = 40.0
@export var hp = 1
@export var knockback_resistance : float = 4
@export var value = 1
var knockback : float = 0
var knockback_dir : Vector2 = Vector2(0, 0)

@onready var sprite = $Sprite2D

@onready var target : Vector2 = Methods.find_closest("building", position)[0]

func _ready():
	if target == Vector2.INF:
		target = Vector2.ZERO

func _physics_process(delta):
	var direction = Vector2(0, 0)
	
	# if knockback exists apply knockback and reduce it otherwise move towards the player
	if knockback <= 0:
		
		direction = global_position.direction_to(target)
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

func _on_hurt_box_hurt(damage, direction, knockback):
	hp -= damage
	set_knockback(knockback, direction)
	if hp <= 0:
		queue_free()
		get_tree().get_first_node_in_group("game_manager").add_currency(value)

func set_knockback(magnitude: float, direction: Vector2):
	knockback = magnitude
	knockback_dir = direction

func find_target():
	target = Methods.find_closest("building", position)[0]
	if target == Vector2.INF:
		target = Vector2.ZERO
