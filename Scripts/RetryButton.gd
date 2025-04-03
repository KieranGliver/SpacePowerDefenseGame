extends Button


func _on_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/GameScenes/main.tscn")
