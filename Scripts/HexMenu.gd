extends PanelContainer

@onready var button_arr : Array[Node] = $MarginContainer/HBoxContainer.get_children()

signal button_pressed(button: int)

func _on_button_down():
	var button = get_pressed()
	emit_signal("button_pressed", button)

func get_pressed():
	for i in button_arr.size():
		if button_arr[i].button_pressed:
			# Since tilemap has a blank hex we add one to the index 
			return i + 1
	return -1
