extends PanelContainer

@onready var name_label = $MarginContainer/VBoxContainer/Name

var building : Building = null

signal sell_button_pressed(building : Building)
signal upgrade_button_pressed(building : Building)

func _input(event):
	if event is InputEventMouseMotion:
		var global_mouse_position = get_global_mouse_position()
		var max_x = global_position.x + size.x * 1.1
		var min_x = global_position.x - size.x * 0.1
		var max_y = global_position.y + size.y * 1.1
		var min_y = global_position.y - size.y * 0.1
		if global_mouse_position.x <= min_x or global_mouse_position.x >= max_x or global_mouse_position.y <= min_y or global_mouse_position.y >= max_y: 
			queue_free()

func _on_upgrade_button_pressed():
	emit_signal("upgrade_button_pressed", building)

func _on_sell_button_pressed():
	emit_signal("sell_button_pressed", building)

func set_name_text(string: String):
	name_label.text = string
