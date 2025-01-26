extends Sprite2D

var projectile = preload("res://Scenes/Buildings/Weapons/projectile.tscn")

func _input(event):
	if event is InputEventMouse:
		if event is InputEventMouseMotion:
			# I don't really know why I have to add 90 degress
			rotation = get_global_mouse_position().angle() + deg_to_rad(90.0)

func _unhandled_input(event):
	if event is InputEventMouse:
		if event is InputEventMouseButton:
			if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
				fire_projectile()

func fire_projectile():
	var projectile_instant = projectile.instantiate()
	projectile_instant.set_target(get_global_mouse_position())
	get_parent().add_child(projectile_instant)
