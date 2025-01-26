extends Sprite2D

var hex_id = -1

func _input(event):
	if event is InputEventMouseMotion:
		visible = true
		global_position = get_global_mouse_position()
