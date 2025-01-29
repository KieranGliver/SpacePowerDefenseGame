extends Node2D

@onready var timer = $DisplayTimer

func _ready():
	visible = false


func _on_value_changed(value):
	visible = true
	timer.start()


func _on_display_timer_timeout():
	visible = false
