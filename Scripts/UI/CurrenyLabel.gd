extends PanelContainer

@onready var label = $MarginContainer/HBoxContainer/Label

func set_text(str: String):
	label.text = str
	size = Vector2.ZERO
