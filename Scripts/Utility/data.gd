extends Node

enum hex_ids {BLANK, WIRE, BATTERY, GENERATOR, MINIGUN, SNIPER, LASER, MANUAL}

var cost = [0, 5, 50, 100, 50, 100, 150, 50]

const TILE_MAP_LAYER = 0
const TILE_MAP_ATLAS_ID = 0

const BASIC_ENEMY = preload("res://Scenes/Enemy/BasicEnemy.tscn")
const SHIELD_ENEMY = preload("res://Scenes/Enemy/ShieldedEnemy.tscn")
const SLOW_ENEMY = preload("res://Scenes/Enemy/SlowEnemy.tscn")

var weapon_stats = {
	"minigun": {
		"damage": 3.0,
		"charge": 5.0,
		"range": 250.0,
		"cooldown": 3.0,
		"attack_speed": 0.25,
		"ammo": 3
	},
	"sniper": {
		"damage": 10.0,
		"charge": 20.0,
		"range": 500.0,
		"cooldown": 5.0,
		"attack_speed": 1.0,
		"ammo": 1
	},
	"manual": {
		"damage": 10.0,
		"charge": 20.0
	},
	"laser": {
		"damage": 1.0,
		"charge": 1.0,
		"range": 400.0,
		"cooldown": 3.0,
		"attack_duration": 10.0,
	}
}

var wave_data = [
	[
		{
			"time_start": 0,
			"time_end": 30,
			"enemy": BASIC_ENEMY,
			"enemy_num": 3,
			"enemy_spawn_delay": 3
		},
		{
			"time_start": 10,
			"time_end": 30,
			"enemy": SLOW_ENEMY,
			"enemy_num": 1,
			"enemy_spawn_delay": 5
		},
		{
			"time_start": 20,
			"time_end": 30,
			"enemy": SHIELD_ENEMY,
			"enemy_num": 2,
			"enemy_spawn_delay": 4
		}
	]
]
