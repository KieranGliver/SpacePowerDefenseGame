extends Node

func unpack(scene:PackedScene, parent:Node = get_node("/root/Main"), pos:Vector2 = Vector2.ZERO,hide:bool=false):
	var scene_instance = scene.instantiate()
	scene_instance.position = pos
	if hide:
		scene_instance.hide()
	parent.add_child(scene_instance)
	return scene_instance

func player(stream:AudioStream, parent:Node = get_node("/root/Main"), volume:float = 0.0):
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = stream
	parent.add_child(audio_player)
	audio_player.volume_db = 0.0
	return audio_player
