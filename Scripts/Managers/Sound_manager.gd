extends Node

const SOUNDS_NODE_PATH = "/root/Main/Sounds"
const AUDIO_FOLDER_PATH = "res://Audio/"
var audio_paths = []
var audio_names = []

func _ready():
	audio_paths = FileExplorer.traverse_directory(AUDIO_FOLDER_PATH)
	var i = 0
	while i < audio_paths.size():
		if audio_paths[i].get_extension().to_lower() == "import":
			var audio_name = audio_paths[i].get_file().to_lower()
			audio_paths[i] = audio_paths[i].substr(0,audio_paths[i].length()-7)
			audio_name = audio_name.substr(0,audio_name.length()-11)
			audio_names.append(audio_name)
			i += 1
		else:
			audio_paths.remove_at(i)

func _process(delta):
	close_finished()

func play(audio_name:String,volume:float = 0,debug:bool = false):
	for i in audio_names.size():
		if audio_names[i] == audio_name && (!exists(audio_name) || !debug):
			var player = ResLoader.player(ResourceLoader.load(audio_paths[i]) as AudioStream,get_node(SOUNDS_NODE_PATH))
			player.name = audio_names[i]
			player.volume_db = volume
			player.play()
			return true
	if debug:
		print("Failed at finding audio stream " + audio_name)
	return false


func stop_all():
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		i.queue_free()

func stop(child_name:String):
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		if i.name.begins_with(child_name):
			i.queue_free()

func set_volume(val:float):
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		i.volume_db = val

func close_finished():
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		if !i.playing:
			i.queue_free()

func exists(child_name:String):
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		if i.name.begins_with(child_name):
			return true
		
	return false

