extends CharacterBody2D

class_name Enemy

@export var SPEED : float = 40.0
@export var hp: float = 10
@export var knockback_resistance : float = 4
@export var value = 1
var knockback : float = 0
var knockback_dir : Vector2 = Vector2(0, 0)

@onready var sprite = $Sprite2D

var target_pos : Vector2 = Vector2.ZERO

func _ready():
	find_target()

func _physics_process(delta):
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

func _on_hurt_box_hurt(damage: float, knockback_mag: float, knockback_dir: Vector2):
	damage(damage, knockback_mag, knockback_dir)

func damage(damage: float, knockback_mag: float = 0.0, knockback_dir: Vector2 = Vector2.ZERO):
	hp -= damage
	set_knockback(knockback_mag, knockback_dir)
	if hp <= 0:
		queue_free()
		get_tree().get_first_node_in_group("game_manager").add_currency(value)

func set_knockback(magnitude: float, direction: Vector2):
	knockback = magnitude
	knockback_dir = direction

func find_target():
	var target_node = Methods.find_closest("building", position)[0]
	if target_node:
		target_pos = target_node.global_position
	else:
		target_pos = Vector2.ZERO
