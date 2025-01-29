extends CharacterBody2D

class_name Enemy

@export var SPEED : float = 0
@export var max_hp : float = 0
@export var max_shield : float = 0
@export var shield_recharge_rate: float = 0

@export var currency_value: int = 0

var hp: float = 0
var shield: float = 0
var knockback_resistance : float = 4
var knockback : float = 0
var knockback_dir : Vector2 = Vector2(0, 0)
var shield_recharge: bool = true

@onready var sprite = $Sprite2D
@onready var shield_timer = $ShieldTimer

@onready var health_bar = $BarDisplay/HealthBar
@onready var shield_bar = $BarDisplay/ShieldBar

var target_pos : Vector2 = Vector2.ZERO
var building_target : Building = null

func _ready():
	find_target()
	update_health(max_hp)
	update_shield(max_shield)

func _process(delta):
	if shield_recharge and shield <= max_shield:
		update_shield(shield_recharge_rate*delta)

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
	shield_timer.stop()
	shield_recharge = false
	shield_timer.start()
	if shield > 0:
		update_shield(-damage)
	else:
		update_health(-damage)
	set_knockback(knockback_mag, knockback_dir)

func set_knockback(magnitude: float, direction: Vector2):
	knockback = magnitude
	knockback_dir = direction

func find_target():
	building_target = Methods.find_closest("building", position)[0]
	if building_target:
		target_pos = building_target.global_position
	else:
		target_pos = Vector2.ZERO

func update_health(value: float):
	hp = maxf(minf(hp + value, max_hp), 0)
	if hp <= 0:
		get_tree().get_first_node_in_group("game_manager").add_currency(currency_value)
		queue_free()
	health_bar.max_value = max_hp
	health_bar.value = hp

func update_shield(value: float):
	if max_shield <= 0:
		shield_bar.visible = false
	shield = maxf(minf(shield+value, max_shield), 0)
	shield_bar.max_value = max_shield
	shield_bar.value = shield

func _on_shield_timer_timeout():
	shield_recharge = true
