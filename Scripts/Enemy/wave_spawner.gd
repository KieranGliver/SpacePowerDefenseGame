extends Node2D

@export var spawns: Array[Wave_Info] = []

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
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1
	if time >= time_end:
		timer.stop()
		emit_signal("wave_done")


func get_random_position():

	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	
	var top_left = Vector2(global_position.x - vpr.x, global_position.y - vpr.y)
	var top_right = Vector2(global_position.x + vpr.x, global_position.y - vpr.y)
	var bot_left = Vector2(global_position.x - vpr.x, global_position.y + vpr.y)
	var bot_right = Vector2(global_position.x + vpr.x, global_position.y + vpr.y)
	
	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bot_right
		"down":
			spawn_pos1 = bot_left
			spawn_pos2 = bot_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bot_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	
	return Vector2(x_spawn,y_spawn)

