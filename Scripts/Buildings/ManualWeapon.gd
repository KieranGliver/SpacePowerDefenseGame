extends Weapon

var projectile = preload("res://Scenes/Buildings/Weapons/Effects/projectile.tscn")

func _input(event):
	if event is InputEventMouse:
		if event is InputEventMouseMotion:
			# I don't really know why I have to add 90 degress
			rotation = (get_global_mouse_position()-global_position).angle() + SPRITE_ROTATION_OFFSET

func _unhandled_input(event):
	if event is InputEventMouse:
		if event is InputEventMouseButton:
			if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and get_tree().get_first_node_in_group("game_manager").consume_system_charge(building_owner, charge_cost):
				fire_projectile()

func fire_projectile():
	var projectile_instant = projectile.instantiate()
	projectile_instant.set_target(get_global_mouse_position()-global_position)
	projectile_instant.damage = damage_val
	get_parent().add_child(projectile_instant)
