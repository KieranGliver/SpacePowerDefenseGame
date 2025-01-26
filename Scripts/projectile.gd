extends Area2D

var angle : Vector2 = Vector2.ZERO

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback = 1000
var att_size = 1.0

func _on_timer_timeout():
	queue_free()

func set_target(target: Vector2):
	angle = global_position.direction_to(target)
	rotation = angle.angle()

func _physics_process(delta):
	position += angle*speed*delta
