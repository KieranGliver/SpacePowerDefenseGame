extends Node2D

@export var spawns: Array[Wave_Info] = []
@onready var camera: Camera2D = $"../Camera2D"
@onready var timer = $Timer

var time = 0
var time_end = 0

signal wave_done()

func start_wave(level: int):
	spawns = []
	time = 0
	time_end = 0
	
	var wave_data_array = Data.wave_data[level]
	
	for wave_data in wave_data_array:
		var wave_info = Wave_Info.new()
		wave_info.time_start = wave_data["time_start"]
		wave_info.time_end = wave_data["time_end"]
		
		if wave_info.time_end > time_end:
			time_end = wave_info.time_end
		
		wave_info.enemy = wave_data["enemy"]
		wave_info.enemy_num = wave_data["enemy_num"]
		wave_info.enemy_spawn_delay = wave_data["enemy_spawn_delay"]
		spawns.append(wave_info)
	
	timer.start()

func _on_timer_timeout():
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.position = get_random_position()
					enemy_spawn.modulate = [Color.WEB_GRAY, Color.WHITE_SMOKE, Color.DIM_GRAY, Color.SLATE_GRAY, Color.GHOST_WHITE, Color.DARK_GRAY, Color.GRAY].pick_random()
					add_child(enemy_spawn)
					counter += 1
	if time >= time_end and get_tree().get_nodes_in_group("enemy").is_empty():
		timer.stop()
		emit_signal("wave_done")


func get_random_position():

	var radius = position.distance_to(Vector2((camera.limit_right-camera.limit_left)/2, (camera.limit_bottom-camera.limit_top)/2))# * randf_range(1.1,1.4)
	
	var angle = randf_range(0, TAU)  # TAU is 2 * PI
	
	var x_spawn = global_position.x + radius * cos(angle)
	var y_spawn = global_position.x + radius * sin(angle)
	
	return Vector2(x_spawn,y_spawn)

