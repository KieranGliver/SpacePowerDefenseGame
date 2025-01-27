extends Area2D

var angle : Vector2 = Vector2.ZERO

var speed = 200
var damage: float = 10.0

func _on_timer_timeout():
	queue_free()

func set_target(target: Vector2):
	angle = global_position.direction_to(target)
	rotation = angle.angle()

func _physics_process(delta):
	position += angle*speed*delta
